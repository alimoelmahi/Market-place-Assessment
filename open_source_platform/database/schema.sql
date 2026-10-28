BEGIN;

CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE SCHEMA IF NOT EXISTS catalog;
CREATE SCHEMA IF NOT EXISTS analysis;
CREATE SCHEMA IF NOT EXISTS publish;
CREATE SCHEMA IF NOT EXISTS ops;
CREATE SCHEMA IF NOT EXISTS app_private;

CREATE TABLE catalog.datasets (
    dataset_id text PRIMARY KEY CHECK (dataset_id ~ '^DS[0-9]{3}$'),
    name text NOT NULL,
    publisher text NOT NULL,
    source_url text NOT NULL,
    record_type text NOT NULL,
    format_contract jsonb NOT NULL DEFAULT '{}'::jsonb,
    frequency_note text NOT NULL,
    rights_status text NOT NULL DEFAULT 'unreviewed',
    sensitivity text NOT NULL DEFAULT 'internal' CHECK (sensitivity IN ('public','internal','restricted')),
    metadata jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE catalog.assets (
    asset_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    dataset_id text NOT NULL REFERENCES catalog.datasets,
    object_key text NOT NULL UNIQUE,
    sha256 text CHECK (sha256 IS NULL OR sha256 ~ '^[0-9a-f]{64}$'),
    observed_start date,
    observed_end date,
    acquired_at timestamptz NOT NULL DEFAULT now(),
    native_crs text,
    native_support text,
    rights_status text NOT NULL DEFAULT 'unreviewed',
    metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
    CHECK (observed_end IS NULL OR observed_start IS NULL OR observed_end >= observed_start)
);

CREATE TABLE catalog.markets (
    market_id text PRIMARY KEY,
    name_ar text NOT NULL,
    name_en text NOT NULL,
    original_name text NOT NULL,
    source_location text,
    admin2_pcode text,
    administrative_unit text,
    market_type text,
    geometry_status text NOT NULL DEFAULT 'unverified' CHECK (geometry_status IN ('verified','approximate','disputed','unverified')),
    geom geometry(Point,4326),
    sensitivity text NOT NULL DEFAULT 'internal' CHECK (sensitivity IN ('public','internal','restricted')),
    identity_evidence jsonb NOT NULL DEFAULT '{}'::jsonb,
    CHECK (geom IS NULL OR ST_IsValid(geom))
);

CREATE TABLE catalog.market_aliases (
    alias_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    market_id text NOT NULL REFERENCES catalog.markets,
    alias text NOT NULL,
    language text NOT NULL,
    source_dataset_id text REFERENCES catalog.datasets,
    match_status text NOT NULL DEFAULT 'candidate',
    UNIQUE (market_id,alias,language)
);
CREATE INDEX market_alias_search ON catalog.market_aliases USING gin (alias gin_trgm_ops);
CREATE INDEX market_geom_index ON catalog.markets USING gist (geom);

CREATE TABLE catalog.indicators (
    indicator_id text PRIMARY KEY CHECK (indicator_id ~ '^I[0-9]{2}$'),
    name text NOT NULL,
    definition text NOT NULL,
    unit text NOT NULL,
    source_dataset_ids jsonb NOT NULL DEFAULT '[]'::jsonb,
    eligibility_rule jsonb NOT NULL DEFAULT '{}'::jsonb,
    method_version text NOT NULL
);

CREATE TABLE analysis.model_versions (
    model_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    version text NOT NULL UNIQUE,
    config jsonb NOT NULL,
    config_sha256 text NOT NULL CHECK (config_sha256 ~ '^[0-9a-f]{64}$'),
    approved boolean NOT NULL DEFAULT false,
    approved_at timestamptz,
    CHECK (NOT approved OR approved_at IS NOT NULL)
);

CREATE TABLE analysis.scenarios (
    scenario_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    model_id uuid NOT NULL REFERENCES analysis.model_versions,
    name text NOT NULL,
    scenario_type text NOT NULL,
    parameters jsonb NOT NULL,
    parameters_sha256 text NOT NULL CHECK (parameters_sha256 ~ '^[0-9a-f]{64}$'),
    approved boolean NOT NULL DEFAULT false,
    UNIQUE (model_id,parameters_sha256)
);

CREATE TABLE analysis.runs (
    run_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    scenario_id uuid REFERENCES analysis.scenarios,
    model_id uuid REFERENCES analysis.model_versions,
    state text NOT NULL CHECK (state IN ('queued','running','succeeded','failed','cancelled')),
    started_at timestamptz,
    finished_at timestamptz,
    manifest jsonb NOT NULL DEFAULT '{}'::jsonb,
    CHECK (finished_at IS NULL OR started_at IS NULL OR finished_at >= started_at)
);

CREATE TABLE analysis.observations (
    observation_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    market_id text NOT NULL REFERENCES catalog.markets,
    indicator_id text NOT NULL REFERENCES catalog.indicators,
    scenario_id uuid REFERENCES analysis.scenarios,
    run_id uuid REFERENCES analysis.runs,
    observed_start date,
    observed_end date,
    value_num double precision,
    value_text text,
    unit text NOT NULL,
    denominator double precision CHECK (denominator IS NULL OR denominator >= 0),
    evidence_type text NOT NULL CHECK (evidence_type IN ('D','R','M','A','U')),
    reliability_score numeric(5,2) CHECK (reliability_score BETWEEN 0 AND 100),
    quality_appraisal jsonb NOT NULL DEFAULT '{}'::jsonb,
    confidence_class text NOT NULL DEFAULT 'unknown' CHECK (confidence_class IN ('high','medium','low','unknown')),
    eligible boolean NOT NULL DEFAULT false,
    missing_reason text,
    source_refs jsonb NOT NULL DEFAULT '[]'::jsonb,
    lower_bound double precision,
    upper_bound double precision,
    bound_type text,
    CHECK (observed_end IS NULL OR observed_start IS NULL OR observed_end >= observed_start),
    CHECK (lower_bound IS NULL OR upper_bound IS NULL OR lower_bound <= upper_bound),
    CHECK (evidence_type <> 'U' OR (value_num IS NULL AND value_text IS NULL))
);
CREATE INDEX observation_context ON analysis.observations (market_id,indicator_id,scenario_id);

CREATE TABLE analysis.gates (
    gate_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    market_id text NOT NULL REFERENCES catalog.markets,
    gate_type text NOT NULL CHECK (gate_type IN ('identity_scope','security_access_explosive_remnants','tenure_permission','technical_environmental_social','economic_additionality_operations_maintenance')),
    status text NOT NULL DEFAULT 'unknown' CHECK (status IN ('pass','fail','unknown')),
    reviewed_at timestamptz NOT NULL,
    evidence_refs jsonb NOT NULL DEFAULT '[]'::jsonb,
    required_action text NOT NULL,
    reviewer_role text NOT NULL
);

CREATE TABLE publish.releases (
    release_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    version text NOT NULL UNIQUE,
    state text NOT NULL DEFAULT 'draft' CHECK (state IN ('draft','review','approved','published','withdrawn','retired')),
    audience text NOT NULL CHECK (audience IN ('public','internal')),
    model_id uuid NOT NULL REFERENCES analysis.model_versions,
    default_scenario_id uuid NOT NULL REFERENCES analysis.scenarios,
    marketset_id text NOT NULL,
    period_id text NOT NULL,
    observed_start date,
    observed_end date,
    published_at timestamptz,
    is_current boolean NOT NULL DEFAULT false,
    qa_approved boolean NOT NULL DEFAULT false,
    rights_approved boolean NOT NULL DEFAULT false,
    assets_ready boolean NOT NULL DEFAULT false,
    previous_release_id uuid REFERENCES publish.releases,
    metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
    CHECK (NOT is_current OR state = 'published'),
    CHECK (state <> 'published' OR (qa_approved AND rights_approved AND assets_ready AND published_at IS NOT NULL)),
    CHECK (observed_end IS NULL OR observed_start IS NULL OR observed_end >= observed_start)
);
CREATE UNIQUE INDEX one_current_release_per_audience ON publish.releases (audience) WHERE is_current;

ALTER TABLE publish.releases ENABLE ROW LEVEL SECURITY;
ALTER TABLE publish.releases FORCE ROW LEVEL SECURITY;
CREATE POLICY release_read ON publish.releases FOR SELECT USING (
    (state = 'published' AND (audience = 'public' OR current_setting('km.audience',true) = 'internal'))
    OR current_setting('km.actor_role',true) IN ('reviewer','publisher','worker')
);
CREATE POLICY release_write ON publish.releases FOR ALL
    USING (current_setting('km.actor_role',true) IN ('publisher','worker'))
    WITH CHECK (current_setting('km.actor_role',true) IN ('publisher','worker'));

CREATE FUNCTION app_private.can_read_release(target_id uuid) RETURNS boolean
LANGUAGE sql STABLE SECURITY INVOKER SET search_path = pg_catalog,publish
AS $$ SELECT EXISTS (SELECT 1 FROM publish.releases WHERE release_id = target_id) $$;

CREATE TABLE publish.market_snapshots (
    release_id uuid NOT NULL REFERENCES publish.releases,
    market_id text NOT NULL REFERENCES catalog.markets,
    name_ar text NOT NULL,
    name_en text NOT NULL,
    aliases jsonb NOT NULL DEFAULT '[]'::jsonb,
    locality text,
    administrative_unit text,
    market_type text,
    geometry_status text NOT NULL CHECK (geometry_status IN ('verified','approximate','disputed','unverified')),
    geom geometry(Point,4326),
    profile jsonb NOT NULL DEFAULT '{}'::jsonb,
    PRIMARY KEY (release_id,market_id),
    CHECK (geom IS NULL OR (geometry_status = 'verified' AND ST_IsValid(geom)))
);
CREATE INDEX snapshot_geom ON publish.market_snapshots USING gist (geom);
CREATE INDEX snapshot_name_search ON publish.market_snapshots USING gin (name_en gin_trgm_ops);

CREATE TABLE publish.indicator_snapshots (
    release_id uuid NOT NULL,
    market_id text NOT NULL,
    indicator_id text NOT NULL REFERENCES catalog.indicators,
    scenario_id uuid NOT NULL REFERENCES analysis.scenarios,
    payload jsonb NOT NULL,
    PRIMARY KEY (release_id,market_id,indicator_id,scenario_id),
    FOREIGN KEY (release_id,market_id) REFERENCES publish.market_snapshots
);

CREATE TABLE publish.score_snapshots (
    release_id uuid NOT NULL,
    market_id text NOT NULL,
    scenario_id uuid NOT NULL REFERENCES analysis.scenarios,
    score_lower numeric(12,8) NOT NULL CHECK (score_lower BETWEEN 0 AND 100),
    score_upper numeric(12,8) NOT NULL CHECK (score_upper BETWEEN 0 AND 100),
    point_score numeric(12,8),
    covered_weight numeric(10,9) NOT NULL CHECK (covered_weight BETWEEN 0 AND 1),
    coverage_class text NOT NULL CHECK (coverage_class IN ('complete','provisional','insufficient')),
    need_class text NOT NULL DEFAULT 'unknown',
    gate_status text NOT NULL DEFAULT 'unknown' CHECK (gate_status IN ('pass','fail','unknown')),
    analytical_rank integer CHECK (analytical_rank > 0),
    investment_rank integer CHECK (investment_rank > 0),
    components jsonb NOT NULL,
    PRIMARY KEY (release_id,market_id,scenario_id),
    FOREIGN KEY (release_id,market_id) REFERENCES publish.market_snapshots,
    CHECK (score_lower <= score_upper),
    CHECK (point_score IS NULL OR (point_score BETWEEN 0 AND 100 AND covered_weight = 1 AND coverage_class = 'complete')),
    CHECK (analytical_rank IS NULL OR point_score IS NOT NULL),
    CHECK (investment_rank IS NULL OR (point_score IS NOT NULL AND gate_status = 'pass'))
);

CREATE TABLE publish.layers (
    release_id uuid NOT NULL REFERENCES publish.releases,
    layer_key text NOT NULL CHECK (layer_key ~ '^[a-z][a-z0-9_]{0,62}$'),
    scenario_id uuid REFERENCES analysis.scenarios,
    format text NOT NULL CHECK (format IN ('geojson','mvt','cog','pmtiles','static')),
    min_zoom integer NOT NULL CHECK (min_zoom BETWEEN 0 AND 22),
    max_zoom integer NOT NULL CHECK (max_zoom BETWEEN 0 AND 22),
    metadata jsonb NOT NULL,
    PRIMARY KEY (release_id,layer_key),
    CHECK (min_zoom <= max_zoom)
);

CREATE TABLE publish.features (
    feature_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    release_id uuid NOT NULL,
    layer_key text NOT NULL,
    scenario_id uuid NOT NULL REFERENCES analysis.scenarios,
    market_id text,
    geom geometry(Geometry,4326) NOT NULL,
    properties jsonb NOT NULL DEFAULT '{}'::jsonb,
    FOREIGN KEY (release_id,layer_key) REFERENCES publish.layers,
    CHECK (ST_IsValid(geom))
);
CREATE INDEX published_feature_geom ON publish.features USING gist (geom);
CREATE INDEX published_feature_context ON publish.features (release_id,layer_key,scenario_id);

CREATE TABLE publish.analytics_snapshots (
    release_id uuid NOT NULL REFERENCES publish.releases,
    product_id text NOT NULL CHECK (product_id ~ '^V[0-9]{2}$'),
    scenario_id uuid NOT NULL REFERENCES analysis.scenarios,
    payload jsonb NOT NULL,
    PRIMARY KEY (release_id,product_id,scenario_id)
);

CREATE TABLE publish.indicator_definitions (
    release_id uuid NOT NULL REFERENCES publish.releases,
    indicator_id text NOT NULL REFERENCES catalog.indicators,
    payload jsonb NOT NULL,
    PRIMARY KEY (release_id,indicator_id)
);

CREATE TABLE publish.options (
    release_id uuid NOT NULL,
    option_id uuid NOT NULL DEFAULT gen_random_uuid(),
    market_id text NOT NULL,
    stage text NOT NULL CHECK (stage IN ('proposed','preparation','approved','implemented','unknown')),
    payload jsonb NOT NULL,
    PRIMARY KEY (release_id,option_id),
    FOREIGN KEY (release_id,market_id) REFERENCES publish.market_snapshots
);

CREATE TABLE publish.dataset_metadata (
    release_id uuid NOT NULL REFERENCES publish.releases,
    dataset_id text NOT NULL REFERENCES catalog.datasets,
    payload jsonb NOT NULL,
    PRIMARY KEY (release_id,dataset_id)
);

DO $policies$
DECLARE table_name text;
BEGIN
    FOREACH table_name IN ARRAY ARRAY['market_snapshots','indicator_snapshots','score_snapshots','layers','features','analytics_snapshots','indicator_definitions','options','dataset_metadata']
    LOOP
        EXECUTE format('ALTER TABLE publish.%I ENABLE ROW LEVEL SECURITY',table_name);
        EXECUTE format('ALTER TABLE publish.%I FORCE ROW LEVEL SECURITY',table_name);
        EXECUTE format('CREATE POLICY snapshot_read ON publish.%I FOR SELECT USING (app_private.can_read_release(release_id))',table_name);
        EXECUTE format('CREATE POLICY snapshot_write ON publish.%I FOR ALL USING (current_setting(''km.actor_role'',true) IN (''publisher'',''worker'')) WITH CHECK (current_setting(''km.actor_role'',true) IN (''publisher'',''worker''))',table_name);
    END LOOP;
END;
$policies$;

CREATE TABLE ops.jobs (
    job_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_subject text NOT NULL,
    job_type text NOT NULL CHECK (job_type IN ('experiment','sensitivity','export','ingestion','publication')),
    release_id uuid REFERENCES publish.releases,
    state text NOT NULL DEFAULT 'queued' CHECK (state IN ('queued','running','succeeded','failed','cancelled')),
    idempotency_key text NOT NULL,
    payload jsonb NOT NULL,
    result_object_key text,
    error_code text,
    lease_until timestamptz,
    attempts integer NOT NULL DEFAULT 0 CHECK (attempts >= 0),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (owner_subject,job_type,idempotency_key)
);
CREATE INDEX job_queue ON ops.jobs (state,created_at);

CREATE TABLE ops.release_assets (
    release_id uuid NOT NULL REFERENCES publish.releases,
    asset_id uuid NOT NULL REFERENCES catalog.assets,
    ready boolean NOT NULL DEFAULT false,
    approved_use text NOT NULL,
    PRIMARY KEY (release_id,asset_id)
);

CREATE TABLE ops.audit_events (
    event_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    actor_subject text NOT NULL,
    action text NOT NULL,
    target_id text NOT NULL,
    occurred_at timestamptz NOT NULL DEFAULT now(),
    metadata jsonb NOT NULL DEFAULT '{}'::jsonb
);

REVOKE ALL ON SCHEMA catalog,analysis,publish,ops,app_private FROM PUBLIC;
REVOKE ALL ON ALL TABLES IN SCHEMA catalog,analysis,publish,ops FROM PUBLIC;
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA app_private FROM PUBLIC;

COMMIT;