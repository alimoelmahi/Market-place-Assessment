# GIS Analysis Workflow and Data Schema

Implementation specification | ArcGIS Pro, ArcGIS Online, Experience Builder, and StoryMaps

## 1. Environment and Reproducibility

This document specifies workflows; it does not claim that GIS analysis has been run. No ArcGIS organization login, licensed installation, processing credits, acquired raster stack, or validated market geometry has been supplied.

Use ArcGIS Pro 3.x at the organization's supported version. Before work, verify entitlement to Network Analyst for a local network dataset, Spatial Analyst or suitable Image Analyst tools for raster workflows, and appropriate publication privileges. ArcGIS Online routing, hosted storage, imagery, and analysis may consume credits. Global routing coverage does not guarantee current Sudan road conditions. Never route confidential points through a third-party service without approval.

Open alternatives where needed: QGIS/GRASS/GDAL for vector/raster processing, pgRouting or a vetted OSM network engine for routing, ESA SNAP for SAR preprocessing. Outputs may be imported into Pro. Do not substitute straight-line distance for network travel time without relabeling the result.

Suggested processing structure:

```text
project/
  raw/                 immutable acquired assets and original metadata
  metadata/            resource register, retrieval manifests, hashes, licenses
  working/             reproducible intermediates; no hand-edited raw files
  analysis/            Khartoum_Markets.gdb and versioned model outputs
  models/              ModelBuilder packages and parameter exports
  review/              interpretation/adjudication records and QA reports
  publication/         sanitized service exports, map layouts, cleared media
  archive/             dated releases and source-to-output manifests
```

Use WGS 84 (EPSG:4326) for exchange coordinates; store longitude as X and latitude as Y. Use WGS 84 / UTM zone 36N (EPSG:32636) for local distance/area analysis after checking extent suitability. Web Mercator (EPSG:3857) is a display CRS, not the analytical area CRS. Use geodesic distances or suitable regional projections for long national corridors. Record transformations and units.

Keep native resolutions: Sentinel-2 10/20/60 m by band; Sentinel-1 product sampling is not independent resolving power; Landsat commonly delivered at 30 m although thermal information is coarser; CHIRPS v2 at 0.05 degrees; reanalysis and nightlights at their specified product grids. A fine display grid does not create fine information. Use a 100 m population/access reporting grid only where warranted and retain coarser indicators at their native support.

## 2. Step-by-Step Processing

### Step 1: Adopt geography and identify markets

1. Acquire COD administrative boundaries from the exact resource/version and verify Khartoum State and locality PCodes. Use government publications to resolve naming/version issues; use GADM for comparison only if license permits. Do not merge conflicting boundary sets as though equivalent.
2. Import the provisional CSV as a nonspatial table. Preserve all original names. Confirm market IDs, aliases, market type, and whether an entry is a complex or sub-site.
3. Search OSM and existing maps, documentary descriptions, and dated imagery. Require corroboration before assigning a verified point. Retain multiple candidates with scores when names are ambiguous.
4. Digitize distinct market footprint, entrance points, and proposed intervention parcels from suitable sources. A neighborhood centroid must be labeled approximate and is unsuitable for entrance-level routing without an uncertainty test.
5. Join points to adopted localities using Spatial Join; review boundary cases and contradictory source labels. Do not overwrite the source location wording.
6. Use Check Geometry / Repair Geometry on working copies; detect duplicate footprints and IDs. Ensure entrance-road proximity is plausible, not separated by a wall, canal, railway, river, or grade separation.

Outputs: `markets`, `market_footprints`, `market_entrances`, `admin2`, `market_aliases`, and identity-resolution log. Do not create a location layer for unresolved entries just to fill a map.

### Step 2: Acquire transport and facility networks

1. Download a dated OSM extract covering Khartoum plus a documented external buffer sufficient for catchments and route alternatives; use national coverage for supply networks. Preserve attribution and ODbL obligations.
2. Retain highway class, surface, bridge/tunnel/layer, access, foot/motor_vehicle restrictions, one-way, and source timestamp. Model walking restrictions separately from freight restrictions.
3. Build true topology at same-level intersections only. Preserve bridge/tunnel separation. Check disconnected components, road ends at bridges, and duplicated parallel ways.
4. Create restrictions and versioned status from dated documentary evidence. Classify unknown bridge/road status as unknown, not open. Test open/closed alternatives rather than invent a passability report.
5. Add documented health/education facilities, banks/agents, warehouses, transport hubs, water points, and logistics sites. Keep `mapped_presence` separate from `operating_status` and `operating_date`.

### Step 3: Parameterize and solve accessibility

Define edge minutes as:

$$t_e = 60 L_e / v_e + d_e$$

where $L_e$ is edge length in km, $v_e$ scenario speed in km/h, and $d_e$ a documented or explicitly assumed delay in minutes. Blocked edges have no feasible traversal, not a large but passable speed. Network costs must be nonnegative and respect mode restrictions.

Illustrative speeds for sensitivity, not observed Khartoum travel speeds:

| Mode / surface | Central scenario | Slower scenario | Notes |
|---|---|---|---|
| Walking | 4 km/h | 2.5 km/h | Add 5 km/h as fast sensitivity; not a disability-access model. |
| Freight paved major road | 40 km/h | 20 km/h | Urban congestion and road damage may make these optimistic. |
| Freight urban secondary | 25 km/h | 12.5 km/h | No assumed current traffic observations. |
| Freight unpaved | 15 km/h | 7.5 km/h | Wet-season closure modeled only as an explicit scenario. |

1. Build a local Network Dataset and travel modes, with minutes impedance and walking/freight-specific rules. Verify turn restrictions and travel direction.
2. Snap verified entrances only, with initial maximum tolerance 50 m. Manually review every snap beyond 25 m and all river/rail/barrier crossings. Do not use a tolerance large enough to bridge disconnected networks.
3. Run Service Area for 15/30/60-minute walking and separately selected freight thresholds. Use network segments/OD times for population assignment; polygon envelopes can incorrectly include river-separated areas.
4. Generate population-origin points at a defensible reporting grid or settlement level. Use origin-to-market OD Cost Matrix; for consumer access solve toward markets with directional restrictions. For freight use documented supply origins toward destinations.
5. Store unreachable origins with null time and explicit status. For market comparison calculate population-weighted median time across a fixed 5 km terrestrial neighborhood, plus share of its residents network-reachable. If over half are unreachable, the accessibility score is 0 under the specified scoring rule; retain null median for the raw statistic.
6. Repeat baseline, slower-speed, wet-season, and selected bridge-closure scenarios. Report changes in access and detour ratios, not a single misleading optimum.

Outputs: service areas, OD table, nearest-market assignment, reachable fractions, and scenario comparisons. These are modeled physical access, not safe routes, fares, or observed travel times.

### Step 4: Build population scenarios without double counting

Select a counts raster; if the source is density convert using true cell area before summation. Audit native totals. Avoid bilinear interpolation of population counts; reaggregate conservatively or use mass-preserving areal allocation. Use nearest-neighbor resampling for categorical classes, bilinear where appropriate for continuous fields, but never silently apply continuous interpolation to counts.

For grid cell $g$ in locality $l$ and scenario $s$:

$$P_{g,s}=T_{l,s}\frac{B_g q_{g,s}}{\sum_{h\in l}B_h q_{h,s}}$$

$B_g$ is a selected baseline population count; $q$ is a justified redistribution modifier; and $T$ is a date-aligned total current-resident scenario. Default $q=1$ unless documentary evidence justifies a change; do not set population to zero because buildings appear damaged. If the denominator is zero with positive $T$, flag the locality for a documented settlement-based allocation instead of dividing by zero. Fractionally allocate boundary-straddling cells consistently.

DTM-only IDP/returnee totals generally do not supply a full resident denominator. If a valid $T$ cannot be constructed, retain baseline exposure and explicitly named population-change scenarios; do not label them estimated current residents. Do not combine COD projections, UN national estimates, and DTM cumulative returns by addition. WorldPop and HRSL are alternatives, not additive layers. HRSL availability, year, redistribution rights, and suitability for Sudan must be confirmed before use.

For unique nearest-market allocation:

$$P_{m,s}=\sum_g P_{g,s} I[m=\arg\min_{j\in J_s}t_{gj,s}] I[t_{gm,s}\leq60]$$

Use deterministic market-ID tie-breaking and a separate unreachable/unallocated class. $J_s$ is the scenario's eligible market set. Add an "other market/unmapped option" caveat if the study is a selected cohort rather than an exhaustive market inventory. The output is allocation among modeled candidates, not observed consumer preference. For arbitrary individual catchments, overlaps are retained but must not be summed.

QA: each locality scenario sums to $T$ within numerical tolerance; assigned plus unassigned residents equals the modeled study population; union catchment residents do not exceed the study population; cross-boundary population is reported separately. Use the same allocation rules for low/central/high scenarios and provide min/max scenario exposure, not a fabricated statistical interval.

### Step 5: Interpret infrastructure and disturbance

1. Prefer existing UNOSAT vectors or appropriately licensed pre/post very-high-resolution imagery, preserving the original dates and categories. Record image provider, acquisition time, sensor, spatial resolution, cloud/shadow coverage, off-nadir differences, and license.
2. Register pre/post images and review displacement at building scale. Do not classify roof damage where registration or image quality is insufficient.
3. Use a stable baseline footprint inventory. Record visible condition per observable structure and interpretation confidence. Maintain `unobservable` separately from intact.
4. Calculate visible damaged structures / observable baseline structures and publish the observable / total baseline fraction. Do not extrapolate unobservable roofs to the whole site.
5. Sentinel-2 Level-2A: mask cloud, shadow, and poor-quality pixels; create matched-season reflectance composites; inspect burns and land-cover changes only at supported scale.
6. Sentinel-1: use compatible orbit/pass/polarization, calibration, terrain correction and quality masks; apply appropriate speckle/change methods. Coherence requires a suitable SLC workflow; do not calculate it from GRD as if equivalent. Urban layover/shadow and vegetation/moisture changes confound inference.
7. Independently desk-review the classifications. Report inter-review agreement; without verified reference labels do not claim field-validated damage accuracy.

Outputs: interpretation records, observed coverage, candidate disturbance layer, and qualified before/after panels. No automated change result becomes a structural or ordnance safety finding.

### Step 6: Prepare price, commodity, finance, and supply evidence

1. Parse permitted tabular monitoring files or manually extract reported observations with page/table references. Keep retail/wholesale, units, grades, currencies, and collection methods distinct.
2. Deduplicate observations by original source lineage and market-item-date. Maintain a crosswalk between source market names and verified IDs.
3. Calculate comparable nominal changes, availability fractions with completeness, and volatility only when panel coverage is adequate. Proposed minimum for monthly log-change standard deviation: 12 consecutive monthly prices producing 11 valid changes; otherwise show a shorter-series descriptive chart, not the standardized volatility indicator.
4. Keep locality/state observations in contextual tables rather than assigning them as market observations. For finance record mapped point, operating confirmation, source date, services, and applicable limitations separately.
5. Digitize evidence-backed supply links; attach reported quantities only with units and period. Generate modeled least-cost routes in a separate layer and field, not by overwriting reported paths.

### Step 7: Calculate conflict exposure and disruptions

1. Obtain licensed events via authorized access and codebook. Select relevant violent-event types explicitly; protests or strategic developments must not enter the violence metric by default.
2. Retain original event ID, date precision, location precision, event type, source lineage, and retrieval date. Review duplicates and revisions.
3. Calculate market-neighborhood and corridor exposure separately. The scoring implementation uses a 5 km market buffer and 180-day recency weighting; 1/10 km and 90/365-day outputs are sensitivity/context views.
4. Exclude spatially unsuitable events from fine-buffer counts and record exclusion counts. Summarize them at an appropriate administrative scale instead of treating coarse geocodes as exact points. Propagate uncertainty when potential location areas overlap market buffers.
5. Create restricted analytical layers and a generalized public exposure summary. Absence of events means no qualifying records in that dataset/window, not absence of violence or protection risks.

### Step 8: Screen flood, climate, heat, land cover, and water

1. Acquire the global JRC river-flood raster for selected return periods, not its Europe-only observed-flood catalogue. Verify Sudan coverage and nodata rules.
2. Calculate market area, baseline buildings, access-road length, and catchment residents intersecting modeled depth categories. Publish thresholds, such as depth over 0.3 m, as explicit analytical choices; these are not vehicle-safety limits.
3. Add dated UNOSAT/Sentinel observed flood extents independently, masking permanent water, radar shadow, and urban uncertainty. Do not add modeled and observed extents into a single probability layer.
4. Use CHIRPS v2 monthly rainfall against a consistent 1991-2020 climatology: anomaly in mm and percent where climatological rainfall is nonzero. Near-zero baselines require absolute anomalies instead. Analyze relevant upstream basin rainfall for river flooding.
5. Use land cover (e.g., ESA WorldCover) for built/crop/water context, not current business status. Calculate matched-season NDVI $(NIR-Red)/(NIR+Red)$ with denominator/quality checks in producer areas; common 10 m Sentinel-2 NDVI uses B8/B4, whereas indices using 20 m bands retain their effective resolution.
6. Retrieve Landsat surface-temperature products with quality masks and correct scale/offset; report hot-surface exposure and sampling times. Use ERA5-Land for contextual thermal conditions. Do not label land surface temperature as measured air temperature or heat-stress index.
7. Use JRC Global Surface Water occurrence for historical water context and existing utility/WASH records for operational supply. Avoid inferring drinking-water quality or groundwater yield.
8. Carry all environmental screening into feasibility/options appraisal; the user's six top-level MCDA weights remain unchanged. Flood-related costs and safeguards belong in environmental feasibility and in separate exposure maps, not an undisclosed seventh weight.

### Step 9: Analyze nighttime lights and economic proxies

Use one NASA Black Marble product/collection and platform for a consistent series where possible, or document and test cross-sensor harmonization. Product grid spacing (often about 500 m for gridded Black Marble products) is not the native VIIRS DNB resolving power (about 750 m). Do not interpret one grid cell as a precisely observed individual market.

Apply mandatory quality, cloud, moon/stray-light and valid-observation checks appropriate to the chosen product. Keep gap-filled and actually observed data distinguishable. Compare matched-month medians over a justified neighborhood polygon; retain radiance units and valid-pixel counts. Proposed quality gate: at least five valid nightly observations per month for a monthly statistic and at least 70% valid area coverage; test sensitivity and mark insufficient data unavailable. A published monthly product's own quality metadata may warrant a different documented gate.

Report $100(R_t-R_b)/R_b$ only for a valid positive baseline above the product-specific noise floor. For near-zero baselines publish absolute radiance change and uncertainty, not explosive percentage growth. Screen fires/flaring and grid-restoration effects. No causal GDP or livelihood conversion.

NASA's portal reviewed on 27 October 2026 flags a scheduled cessation of new Suomi NPP observations on 2 November 2026. Recheck the provider alert before implementation; plan continuity using appropriate NOAA-20 products, overlap tests, and version control, not automatic splicing of different sensors.

### Step 10: Integrate, score, and publish

Use `market_id + period_id + scenario_id + indicator_id` as analytical keys. Compute observations in long form, keep source lineage, normalize only eligible indicators, and apply the separate scoring specification. Produce contribution charts, coverage, bounds, gates, rank stability, and high-need/low-readiness quadrants. Do not store missing scores as zero in the database.

Publish only approved derivative layers. Keep authoring sources and detailed event data in restricted groups. Use service views with a true field/record allowlist; hiding a popup field is not access control. If field restriction is insufficient, create a sanitized derivative feature class. Verify REST responses and exports as an anonymous user before public release.

## 3. Data Model

All dates use ISO 8601/UTC where time exists; unknown dates are null, not extraction dates. Domains are coded values. Use UTF-8 for bilingual names; retain stable ASCII field names. Every derived row carries `run_id`, `method_version`, and `review_status`. File geodatabase `GlobalID` supports relationships; stable market IDs remain portable to CSV/GeoPackage.

| Entity | Key and geometry | Required fields |
|---|---|---|
| `markets` | `market_id`; point only after geolocation | `name_ar`, `name_en`, `aliases`, `market_type`, `hierarchy`, `admin2_pcode`, `source_location`, `geometry_status`, `loc_error_m`, `identity_source`, `valid_from`, `valid_to`, `public_ok` |
| `market_footprints` | `footprint_id`; polygon; FK `market_id` | `footprint_role` existing/proposed/sub-site, `imagery_date`, `source_id`, `area_m2`, `interpret_conf`, `tenure_status` |
| `market_entrances` | `entrance_id`; point; FK `market_id` | `mode`, `source_id`, `source_date`, `snap_distance_m`, `barrier_review`, `verified` |
| `market_aliases` | `alias_id`; nonspatial; FK `market_id` | `original_name`, `language`, `source_id`, `page_ref`, `match_status` |
| `sources` | `source_id`; nonspatial | `publisher`, `title`, `url`, `resource_url`, `publication_date`, `observation_start`, `observation_end`, `retrieved_at`, `retrieval_status`, `license`, `reuse_status`, `method`, `geography`, `file_hash`, `sensitivity` |
| `observations` | `obs_id`; nonspatial; FK market/indicator/source | `indicator_id`, `period_id`, `scenario_id`, `value_num`, `value_text`, `unit`, `denominator`, `observed_at`, `evidence_type`, `confidence_class`, `quality_score`, `lower_bound`, `upper_bound`, `bound_type`, `missing_reason`, `page_ref`, `claim_text`, `interpretation` |
| `observation_sources` | composite `obs_id + source_id` | `role` primary/corroborating, `lineage_group`, `supports_or_conflicts` |
| `indicator_definitions` | `indicator_id`; nonspatial | `definition`, `unit`, `valid_min`, `valid_max`, `direction`, `transform`, `source_ids`, `required_specificity`, `freshness_days`, `method_version` |
| `periods` | `period_id`; nonspatial | `start_date`, `end_date`, `label`, `baseline_or_current`, `season` |
| `scenarios` | `scenario_id`; nonspatial | `population_case`, `network_case`, `speed_case`, `security_window`, `parameters_json`, `approved_by` |
| `roads` | `edge_id`; polyline | `osm_id`, `from_node`, `to_node`, `length_km`, `road_class`, `surface`, `bridge`, `layer`, `walk_allowed`, `freight_allowed`, `oneway`, `status`, `status_date`, `source_id` |
| `facilities` | `facility_id`; point/polygon | `facility_type`, `mapped_presence`, `operating_status`, `operating_date`, `source_id`, `market_id` if linked, `confidence_class` |
| `od_costs` | composite origin/market/entrance/scenario | `origin_id`, `market_id`, `entrance_id`, `scenario_id`, `minutes`, `reachable`, `snap_status`, `run_id` |
| `catchment_cells` | composite cell/scenario; grid polygon or raster link | `cell_id`, `admin2_pcode`, `scenario_id`, `population`, `nearest_market_id`, `travel_minutes`, `allocation_status` |
| `trade_links` | `link_id`; directed polyline or schematic relation | `origin_id`, `destination_id`, `commodity`, `season`, `reported_or_modeled`, `quantity`, `quantity_unit`, `period_id`, `status`, `source_id`, `confidence_class` |
| `imagery_interpretations` | `interpret_id`; footprint geometry | `market_id`, `baseline_asset_id`, `post_asset_id`, `condition`, `observable`, `reviewer`, `confidence_class`, `adjudication` |
| `scores` | composite market/period/scenario/version | `P`, `A`, `F`, `C`, `E`, `R`, `score_lower`, `score_upper`, `covered_weight`, `coverage_class`, `readiness_score`, `need_class`, `gate_status`, `rank`, `rank_min`, `rank_max`, `method_version` |
| `investment_gates` | composite market/gate/version | `market_id`, `gate_type`, `status`, `evidence_id`, `review_date`, `expiry_or_trigger`, `reviewer_role`, `required_action` |
| `interventions` | `intervention_id`; market or parcel relation | `market_id`, `package`, `need_evidence`, `option`, `horizon`, `dependencies`, `capex_source`, `opex_owner`, `safeguards`, `decision_status` |

Conflict raw events and sensitive facility details belong in restricted storage and are not assumed publishable. Keep restricted records referenced by controlled IDs rather than copying sensitive text to public observations.

Recommended domains:

```text
evidence_type: D | R | M | A | U
geometry_status: verified | approximate | disputed | unverified
operating_status: documented_open | documented_partial | documented_closed | historical_only | unknown
missing_reason: not_reported | stale | not_applicable | inaccessible | conflicting | unsuitable_scale | insufficient_coverage
gate_status: pass | fail | unknown
review_status: draft | desk_reviewed | approved_internal | approved_public
confidence_class: high | medium | low | unknown
```

Null semantics: `0` is an observed or valid modeled zero; null plus `not_reported` means missing; `not_applicable` is reserved for a pre-declared market-type rule. Do not dynamically exclude inconvenient subcriteria and reweight a market's score.

## 4. ArcGIS Online, Dashboards, and Experience Builder

1. Publish versioned hosted feature layers for approved market profiles, market-period indicators, scenario catchments, generalized risk, and conditional priorities. Use hosted feature layer views or sanitized derivatives for public data.
2. Keep rasters as appropriate imagery layers only where entitlement, performance, and license permit. For public consumption use tiled derivatives or cleared static images at appropriate resolution.
3. Create thematic web maps with consistent market IDs, extent bookmarks, source/date text, symbology, and field aliases. Configure popup expressions to display "Not assessed" for nulls, never numeric zero.
4. Create a small current-profile summary layer for dashboards; retain historical/long-form observations for traceability. Avoid duplicating population totals across joined observation rows.
5. Build market, locality, period, scenario, and confidence selectors; configure actions to filter all widgets on shared keys. Scenarios must never be summed together.
6. Dashboard indicators show denominator coverage and current selection. Reachable population totals use a union or unique allocation, not summed overlapping service areas. For multiple periods, show latest comparable period or a trend, not a sum.
7. Experience Builder layout: map; market directory; comparative profile; scenario/evidence filters; sources/methods panel; approved downloads. Use standard map, list, chart, table, filter, and feature-info widgets; confirm availability in the organization's supported version before promising a widget or interaction.
8. Use a URL parameter or supported selection workflow for market links from StoryMaps, tested in the actual deployment. Do not assume cross-app selections persist automatically.
9. Restrict editing, exports, and sync as appropriate, but recognize that public readable records can be recovered via the service. Sensitive data must be removed, not merely hidden.
10. Assign service owner, review date, refresh schedule, and rollback release; protect production dependencies against deletion. StoryMaps and embeds must share compatible permissions and remain usable without the author's login.

## 5. QA and Release Tests

| Test | Expected result |
|---|---|
| Market identity | Unique stable IDs; unresolved sites not falsely geocoded; sub-sites do not inflate market count. |
| Coordinates/CRS | Correct X/Y and Sudan extent; verified local projection; no degree-based area calculations. |
| Network | No unreviewed river jumps; directional rules respected; unreachable origins explicit; snaps reviewed. |
| Population | Scenario locality totals preserved; no IDP/return double counting; allocated plus unallocated closes. |
| Raster alignment | Native support documented; correct masks/nodata; no fake fine-resolution inference. |
| Evidence dates | Acquisition, publication, observation, retrieval, and analysis dates separated. |
| Damage | Observable denominator published; independent review; no structural-safety inference. |
| Prices | Units/grades/currencies aligned; missing rows not stockouts; volatility completeness enforced. |
| MCDA | Weights sum to one; directions correct; bounds/gates/coverage respected; no live ranking from placeholders. |
| Web totals | Filters apply consistently; scenarios/periods not added; overlaps and joined rows do not inflate counts. |
| Public access | Anonymous browser and REST/export review show only cleared fields and records; no restricted dependencies. |
| Accessibility | Keyboard navigation, contrast, alt text, English/Arabic name display, 360 px mobile and desktop readability. |
| Auditability | Every published number links to method and resource; model inputs, parameters, versions, and approvals archived. |

Produce one run manifest with tool versions, model parameters, source resource IDs, file hashes, spatial references, failed/omitted steps, output counts, reviewer and approval date. A map exported successfully is not evidence that these analytical checks passed.