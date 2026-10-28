# Complete Data Inventory and Source Catalogue

## 1. Purpose and Inventory Status

This catalogue identifies the secondary datasets, existing documentary evidence, institutional record requests, and methodological references required for the Khartoum market assessment. It supports data acquisition and technical appraisal; it does not represent a warehouse of acquired and validated analytical data.

The detailed inventory is provided in [Deliverable_D_Data_Inventory.csv](Deliverable_D_Data_Inventory.csv). Every record contains the nine requested fields: dataset name, source, URL, coverage, resolution, update frequency, reliability assessment, intended use, and processing requirements. Additional fields document access, limitations, priority, indicator links, original source IDs, review status, and acquisition status.

The inventory contains **94 records**, not 94 independent or already available datasets. It includes alternatives, subsets of common parent datasets, documentary collections, and requests for existing records whose availability remains unconfirmed. This distinction prevents a long catalogue from being mistaken for complete evidence coverage.

| Record type | Number | Meaning |
|---|---|---|
| Dataset/product candidates | 50 | Distinct selected product families or series; actual versions/resources still require acquisition and review. |
| Extract subsets | 6 | Thematic subsets of a shared parent extract, principally OSM; not independent corroboration. |
| Report collections | 15 | Relevant publication families requiring selection of actual reports and extraction of scoped observations. |
| Existing institutional record requests | 12 | Records to seek through authorized custodians; no public downloadable layer or current record is assumed. |
| Specifically cited but unreceived report | 1 | The SAMRA report referenced in the supplied benchmark; its substantive contents are not treated as reviewed. |
| Supplied references | 3 | The questionnaire/framework, benchmark StoryMap PDF, and Arabic concept note. |
| Individually identified published reports/articles | 3 | Dated contextual documents with explicit review limitations. |
| Methodological guidance | 4 | Assessment standards/tools; these do not provide observed Khartoum conditions. |

**Catalogue date:** 27 October 2026. A catalogue date is not a common observation date for its contents. All external analytical resources remain `not_acquired` or `not_received`; the three supplied references remain `supplied_reference_only`.

The original [source_catalogue.csv](source_catalogue.csv) and [indicator_catalogue.csv](indicator_catalogue.csv) remain unchanged. The expanded inventory uses DS001-DS094 identifiers and retains legacy source crosswalks rather than renumbering earlier deliverables. Its `related_indicator_ids` field links to the existing I01-I42 framework. Listing a supporting source does not establish that the indicator can currently be calculated.

## 2. How to Read and Use the Catalogue

### 2.1 Required Metadata

| Requested field | Inventory column | Interpretation |
|---|---|---|
| Dataset name | `dataset_name` | Specific product, series, extract, report family, or requested record; not simply an agency name. |
| Source | `source` | Original publisher/custodian and distributor where relevant. |
| URL | `url` | Exact known entry point, landing page, repository, discovery portal, or local attachment reference, distinguished by `url_type`. |
| Coverage | `coverage` | Geographic and population/feature coverage, including where Sudan/Khartoum applicability still requires confirmation. |
| Resolution | `resolution` | Actual pixel/grid or feature/administrative support; not a promise of positional or thematic accuracy. |
| Update frequency | `update_frequency` | Provider release cadence, or explicitly unknown/irregular cadence; not the assessment team's refresh schedule. |
| Reliability | `reliability_assessment` | Fitness for the specified inference, conditional on actual resource review. |
| Intended use | `intended_use` | The assessment decision or indicator the resource may support. |
| Processing | `processing_requirements` | Required transformations, source checks, harmonization, and exclusion safeguards before analytical use. |

### 2.2 Additional Control Fields

The remaining columns are `dataset_id`, `theme`, `record_type`, `url_type`, `temporal_coverage`, `access_and_license`, `limitations`, `priority`, `related_indicator_ids`, `legacy_source_ids`, `review_status`, and `asset_status`.

Semicolon-delimited ID lists are crosswalks, not additional data observations. Blank legacy IDs identify new source families introduced in this expanded inventory, not a missing mandatory source. Nonspatial records use their actual support rather than an invented raster resolution. An administrative table is not a 100 m observation simply because it will later be joined to a raster.

The URL field does not imply a verified direct-download file. `custodian_entrypoint` and `discovery_portal` explicitly mean that an exact existing resource must still be found or requested. Unknown resolution/cadence is stated where justified rather than fabricated. After acquisition, the exact resource ID/URL, version, observation dates, native grid, license, checksum and retrieval date must be added to the asset manifest.

### 2.3 Priority Classes

- **P1: First acquisition/decision priority.** Required for core analysis or for identifying an essential unresolved condition. This does not mean every P1 resource is public, available, or an obligatory additional dataset where an approved equivalent exists.
- **P2: Supporting, conditional, or complementary.** Improves interpretation, validation, feasibility appraisal or a specific analytical component when relevant and obtainable.
- **P3: Alternative, optional, or methodological/contextual support.** Use selectively where it fills a real gap or tests sensitivity; do not acquire merely to increase dataset count.

For example, one appropriate population surface is needed for a model, not the sum of WorldPop, HRSL, and GHSL. Existing tenure or explosive-clearance records may be P1 because they determine whether implementation can proceed, while remaining unavailable to the desk team. The appropriate consequence is an unresolved gate, not a fabricated substitute.

## 3. Reliability Assessment

Reliability is assessed for an intended use, not assigned solely on institutional reputation. A credible national estimate can be highly reliable for national context and unsuitable for an individual market. Similarly, a precise building footprint can be useful for physical inventory but provide no evidence of operation, occupancy, ownership or structural safety.

| Working assessment | Appropriate interpretation |
|---|---|
| High, conditional | Identifiable authoritative/qualified method with adequate geographic, temporal and variable fit after the actual resource has been reviewed. |
| Medium, conditional | Useful evidence or model with material but understood limitations, such as population disaggregation, event reporting, mapped completeness or contextual scale. |
| Low for a stated inference | The resource cannot reliably establish that concept, for example mapped bank presence as evidence of liquidity or lights as market turnover. |
| Unassessed/unknown | The actual report/resource or necessary methods have not been obtained; no substantive reliability rating is justified. |

Actual observations will be appraised for provenance/reliability, spatial specificity, temporal relevance, and methodological transparency as defined in the assessment methodology. The catalogue's expected reliability is not a statistical confidence interval or a pre-awarded quality rating for future findings.

A source fails an intended use when its critical validity requirement is missing, even if its other attributes are strong. These restrictions apply particularly to current market operation, resident population totals, trader participation, safe access, food quality, engineering safety, and tenure.

## 4. Thematic Inventory and Selection Notes

The tables below provide the readable thematic index. The linked CSV is the complete per-record source catalogue, including the nine required fields and acquisition/status details. Dataset families named here remain candidates or existing-record requests unless explicitly supplied.

### 4.1 Administrative Geography and Market Identity

| ID | Dataset/record | Selection and processing significance |
|---|---|---|
| DS001 | Sudan COD boundaries and PCodes | Preferred operational reporting geography after exact version/geometry review. |
| DS002 | GADM administrative boundaries | Alternative comparison only after permission and administrative equivalence checks. |
| DS003 | Existing government administrative records | Resolve official labels/codes and dated changes where obtainable. |
| DS004 | Existing market gazetteer/location-role records | Resolve identities and the intended missing entry without generating new respondent observations. |
| DS005 | OSM marketplaces/commercial place records | Corroboration and mapped-presence context; not a complete market universe. |
| DS006 | Existing land/parcel/permission records | Intervention-specific lawful-access/tenure evidence; not assumed available as public cadastral GIS. |

Adopt one administrative version for reporting. Do not splice inconsistent COD, GADM and government polygons into one apparent official boundary. Retain original market labels and aliases, and geocode only after identity review. Existing trading areas, sub-sites, entrances and proposed intervention parcels require separate geometries.

### 4.2 Population and Movement

| ID | Dataset/record | Selection and processing significance |
|---|---|---|
| DS007 | WorldPop population counts | Primary candidate for gridded baseline; product choice and mass conservation essential. |
| DS008 | WorldPop age/sex estimates | Compatible demographic context, not trader demographics. |
| DS009 | Meta/CIESIN HRSL Sudan candidate | Optional alternative; actual availability/year/rights unconfirmed. |
| DS010 | COD/subnational population statistics | Seek compatible administrative totals; projections are not current counted residents. |
| DS011 | UN World Population Prospects 2024 | National estimates/projections for context and plausibility only. |
| DS012 | DTM mobility-tracking IDP estimates | Assessed mobility categories and locations, not a complete resident denominator. |
| DS013 | DTM return monitoring | Return context; distinguish cumulative movements from current stocks. |
| DS014 | DTM Integrated Location Assessments | Existing assessed-location service/living-condition context where applicable. |
| DS015 | GHS-POP R2023A | Alternative historical/modelled distribution; 2025/2030 values are projections. |

Do not add population products together. Reconcile dates, geographic units, projected populations, current residents, IDPs and cumulative returns before constructing scenarios. If a valid current resident total cannot be established, retain a dated baseline or explicitly hypothetical scenario rather than label it current population.

Fine cells are not fine observational certainty. WorldPop, HRSL and GHSL can share upstream census or settlement information, so agreement is not necessarily independent validation. Population counts must be conserved when reprojecting, clipping, partitioning and allocating.

### 4.3 Conflict, Access, Safety and Disaster Movement

| ID | Dataset/record | Selection and processing significance |
|---|---|---|
| DS016 | ACLED events | Primary recorded-exposure candidate; authorized access, precision and revision controls required. |
| DS017 | UCDP GED | Alternative/corroborating organized-violence evidence with different definitions. |
| DS018 | Existing humanitarian access/interruption reports | Market/corridor-specific documentary claims and broader context. |
| DS019 | Existing qualified explosive-hazard/clearance records | Independent implementation requirement; no assumption of public availability. |
| DS020 | DTM disaster/flood displacement reporting | Event impact context separate from hazard and full exposure. |

Event points require location/date precision review before small-buffer analysis. Alternative providers' events and repeated report mentions must not be added without identifying overlap. No qualifying record means no qualifying record in that source/window, not a safe area or cleared site. Sensitive operational information remains restricted where required.

### 4.4 Transport and Logistics

| ID | Dataset/record | Selection and processing significance |
|---|---|---|
| DS021 | OSM road network | Tag-rich physical graph; not a current passability service. |
| DS022 | OSM crossings and restrictions | Shared parent extract; preserve bridges/tunnels/layers and mode permissions. |
| DS023 | Sudan LCA roads/border chapters | Structural corridor context; index review is not review of chapter claims. |
| DS024 | Logistics Cluster operational maps | Relevant dated route/access context after product/permission checks. |
| DS025 | Sudan LCA ports/rail/waterways/hubs | Gateway and modal context with chapter-specific dates. |

The Geofabrik Sudan page reviewed for this inventory lists PBF, shapefile and GeoPackage options. A convenient GIS export is not automatically equivalent to the full PBF for routing: inspect whether it retains all required access, direction, bridge and topology information. Capture the extract timestamp; a frequently regenerated extract does not guarantee recently verified road conditions.

The LCA index contains mixed chapter dates, including older entries alongside more recent ones. Use the actual chapter's observation and revision context. A historic airport, railway or storage capacity must not become a current operational claim. Avoid importing personal contact lists into public outputs simply because they accompany a logistics chapter.

### 4.5 Buildings, Facilities, Utilities and Engineering

| ID | Dataset/record | Selection and processing significance |
|---|---|---|
| DS026 | OSM building footprints | Baseline candidate after date/overlap review. |
| DS027 | Google Open Buildings v3 | Alternative polygons with detection confidence, not use/damage labels. |
| DS028 | Microsoft Global ML Building Footprints | Optional tile-dependent alternative or gap filling. |
| DS029 | Healthsites/OSM facility locations | Mapped institutions; source overlap with OSM must be recognized. |
| DS030 | WHO HeRAMS records/reports | Actual assessed facility/service functionality where applicable. |
| DS031 | Existing education-facility inventories | Location/status context; schools are not automatically active institutional buyers. |
| DS032 | Existing WASH/waste/utility records | Market-service evidence with actual operating dates. |
| DS033 | Sudan LCA storage/milling chapters | Existing logistics capacity descriptions after chapter review. |
| DS034 | Existing power-service records | Operation/reliability context separate from physical grid presence or radiance. |
| DS035 | Existing qualified engineering/design assessments | Technical preparation and limitations of proposed works. |

Select or create one deduplicated adopted building inventory. Do not sum overlapping OSM, Google and Microsoft footprints. Release/inference dates are not necessarily acquisition dates and do not establish that all features existed in a pre-conflict baseline.

Mapped presence, documented operation, capacity, adequacy and professional safety conclusions are different attributes. The absence of a current service record must remain unknown. Engineering evidence is usable only within its actual qualified scope and validity; archival photographs do not certify present structural condition.

### 4.6 Optical, Radar and Damage Evidence

| ID | Dataset/record | Selection and processing significance |
|---|---|---|
| DS036 | Sentinel-2 Level-2A | Neighborhood spectral context at 10/20/60 m band support. |
| DS037 | Sentinel-1 GRD | Reviewed backscatter/flood or disturbance context; not coherence. |
| DS038 | Sentinel-1 SLC | Optional specialist coherence workflow using compatible complex data. |
| DS039 | Landsat Level-2 reflectance | Historical/seasonal area-level context with sensor/product QA. |
| DS040 | Landsat Level-2 temperature | Surface heat with actual thermal support, not air temperature. |
| DS041 | Existing UNOSAT damage products | Preferred existing specialist interpretation when suitable coverage/rights exist. |
| DS042 | Licensed archival very-high-resolution imagery | Optional adequate visible-condition evidence where authorized and obtainable. |

Satellite revisit, actual acquisition, processing latency, cloud-free coverage and frequency of usable comparable observations must be distinguished. Sentinel-2's nominal mission revisit does not guarantee a usable market image on that cadence. SAR sampling is not independent resolving power, and displayed sharpness does not establish analytical detail.

Structure-level condition requires appropriate existing specialist products or suitable imagery and an observable baseline denominator. Medium-resolution imagery can support broader disturbance/context but cannot replace individual-stall inspection. A licence to view a basemap or commercial image does not necessarily permit downloading, digitizing or republishing it.

### 4.7 Flood, Terrain, Rainfall, Climate, Land and Water

| ID | Dataset/record | Selection and processing significance |
|---|---|---|
| DS043 | Global JRC river-flood hazard | About 90 m/3 arc-second depth scenarios; masks and artifacts must be addressed. |
| DS044 | Existing UNOSAT observed floods | Dated event extents separate from probability/hazard. |
| DS045 | Copernicus DEM GLO-30/GLO-90 | Global DSM with quality layers and dated acquisitions; no EEA-10 assumption for Sudan. |
| DS046 | SRTM 1 arc-second | Optional older regional elevation alternative, not current urban drainage terrain. |
| DS047 | HydroRIVERS | Major-river topology derived from 15 arc-second source grids; no small-drain completeness. |
| DS048 | HydroBASINS | Upstream aggregation and basin context, not storm-drain catchments. |
| DS049 | CHIRPS v2 | Fixed-version historical rainfall analysis with a declared continuity limit. |
| DS050 | CHIRPS v3 | Continuity option requiring version-consistent climatology/current processing. |
| DS051 | ERA5-Land | Hourly regional reanalysis on a 0.1-degree distributed grid. |
| DS052 | ESA WorldCover | Fixed 2020/2021 map releases with different algorithms. |
| DS053 | JRC Global Surface Water | Historical occurrence/seasonality, not drinking-water service. |
| DS054 | NASA FIRMS | Optional thermal/fire contextual check, not exact damage or causation. |

**Flood resource selection.** The JRC metadata/README reviewed for this inventory describes version 2.1.2 at 3 arc-second, approximately 90 m support, water depth in metres, irregular updates, and seven return-period folders. Raw-depth and categorized-depth products are different. The categorized file is unsuitable for an exact 0.3 m threshold because its lowest depth bin does not resolve that threshold. Use an appropriate raw-depth asset and actual nodata/valid-coverage handling. Acquire permanent-water and spurious-depth masks; known extreme-depth, terrain and tile-boundary artifacts require caution. File modification dates are not flood-observation dates.

**Terrain selection.** Copernicus GLO-30/GLO-90 are global surface models, including buildings/vegetation, with main TanDEM-X acquisitions from 2011-2015 and older infill. They are not contemporary bare-earth plot surveys. GLO-30's approximate 30 m spacing and published accuracy specifications do not support automatic micro-drainage or engineering-height conclusions at every market. Check vertical datum and units before comparing elevations.

**Rainfall continuity.** The CHC page reviewed on 27 October 2026 states that CHIRPS v2 production will end after December 2026. The v3 page describes 0.05-degree coverage from 60S-60N, 1981-near-present; preliminary updates about two days after pentads; and final monthly production typically in the third week of the following month. Its two daily disaggregations have different upstream information. A v3 daily date is not a uniform local gauge-observation window. Transition by rerunning a coherent historical/climatological and current series, not by appending v3 observations to an unchanged v2 baseline. This catalogue records the transition requirement without silently changing the existing methodology's chosen rainfall version.

**Land cover and climate.** WorldCover's 2020 v100 and 2021 v200 algorithm differences mean raw differences are not pure real land-cover change. Obtain the analytical class map rather than RGB WMS tiles. ERA5-Land metadata states native support of about 9 km, distributed 0.1-degree grids, hourly data and daily updates; those are not market measurements or guaranteed zero-latency values. Surface water and vegetation are environmental context, not evidence of potable supply, crop yield or trader income.

### 4.8 Economic Proxies, Connectivity and Finance

| ID | Dataset/record | Selection and processing significance |
|---|---|---|
| DS055 | NASA Black Marble | Preferred science-quality radiance candidate; neighborhood attribution and quality controls. |
| DS056 | EOG VIIRS composites | Optional alternative collection after current terms/quality review. |
| DS057 | GHSL built-up surface | Settlement/built-environment context, not operating business space. |
| DS058 | GSMA mobile coverage | Potential coverage only where authorized Sudan layers exist. |
| DS059 | Ookla performance tiles | Optional sampled-test context; no tests is missing information. |
| DS060 | OSM financial POIs | Mapped proximity only; common OSM lineage. |
| DS061 | Existing regulator/provider service records | Actual documented terms/status/constraints if available. |
| DS062 | National CPI/macroeconomic indicators | Contextual deflator/inflation use only when fit is defensible. |

Nightlight grid spacing is not the independent footprint of a market-specific economic signal. Use consistent products/platforms and quality masks; separate actual observations from gap-filled values; check noise floors, fire, grid restoration and residential spillover. Sensor continuity must be rechecked against provider notices before ongoing monitoring. Do not convert radiance to jobs, market GDP or revenue.

Mobile coverage, sampled internet speed, branch location, provider operation, liquidity, adoption, affordability and women's access are separate concepts. This inventory provides candidates for those distinctions, not evidence that they have all been measured. Alternative data are not an excuse to infer unobserved finance access or representative digital use.

### 4.9 Markets, Food, Livelihoods and Feasibility

| ID | Dataset/record | Selection and processing significance |
|---|---|---|
| DS063 | WFP Sudan food prices | Primary comparable price panel candidate; price rows are not stock observations. |
| DS064 | FEWS NET price series | Alternative/corroboration with source-lineage checks. |
| DS065 | FAO FPMA prices | Additional series only where comparable coverage exists. |
| DS066 | IFPRI commodity monitor | Explicit availability evidence if applicable methods/panel can be obtained. |
| DS067 | FEWS NET trade/production maps | Documentary commodity-system structure and seasonality. |
| DS068 | Unreceived SAMRA report | Obtain actual report before adopting detailed corridor or quantity claims. |
| DS069 | Existing FAO/partner agricultural assessments | Upstream crop/livestock/seasonal context, not inferred market supply volumes. |
| DS070 | FEWS NET livelihood zones/profiles/calendars | Structural context with vintage and urban applicability caveats. |
| DS071 | IPC analyses | Assessed-area food-security context; not market-functionality or all-household data. |
| DS072 | Existing enterprise/inclusion studies | Sampling-defined finance/trader/participation evidence. |
| DS073 | Existing wage/income/employment evidence | Compatible purchasing-power denominators where obtainable. |
| DS074 | Existing management/O&M records | Responsibility, viable funding and inclusion arrangements. |
| DS075 | Existing environmental/social/works permissions | Scope-specific implementation conditions and unresolved requirements. |
| DS076 | Existing food-safety/veterinary/hygiene reports | Qualified existing findings only; no remote food-safety certification. |
| DS077 | Existing protection/access/inclusion evidence | Sensitive scoped findings, not inferred consent or social safety. |
| DS078 | Existing disease/public-health reports | Context with definitions/reporting gaps; no automatic market attribution. |
| DS079 | Existing humanitarian situation/service reports | Broad evidence search and corroboration with original-source tracing. |
| DS080 | World Bank economy/damage/recovery reports | Macro/sector context, not site engineering or market turnover. |

Commodity panels require exact market, item, grade, unit, retail/wholesale level, currency, date and source. Do not combine incompatible sack weights or infer stockouts from missing price rows. A minimum-basket cost indicates expenditure requirements, not affordability unless a compatible wage/income/transfer denominator exists.

Existing enterprise and inclusion studies must retain sampling frames, age definitions, dates and denominators. Population age/sex layers cannot estimate the women/youth trader share, disability, ownership, employment or working capital. Livelihood-zone maps provide context, not contemporary prevalence among urban traders.

### 4.10 Supplied References, Dated Reports and Guidance

| ID | Reference | What it can and cannot support |
|---|---|---|
| DS081 | Supplied UNDP Market Assessment Framework | Questionnaire and thematic scope; not completed observations or valid empty-form scores. |
| DS082 | Supplied rehabilitation StoryMap PDF | Attributed dated/undated prior claims and narrative structure, subject to classification/rights. |
| DS083 | Supplied Arabic concept note | Objectives and intended cohort; planned interviews are not collected data. |
| DS084 | FEWS NET September 2026 update | Reviewed national/regional contextual analysis; projections distinct from observations. |
| DS085 | WFP October 2026 trade article | Reviewed explanatory trade/fuel context, not a measured local corridor dataset. |
| DS086 | DTM Snapshot 10 | Portal listing seen but direct content blocked; no report numbers adopted. |
| DS087 | WFP MFI guidance | Dimensions and assessment methods, not a completed corporate MFI exercise. |
| DS088 | EMMA toolkit | Candidate methodological reference; not field evidence. |
| DS089 | Sphere Handbook | Relevant principles after actual consultation; not proof of assessment compliance. |
| DS090 | ICRC/IFRC RAM guidance | Candidate/previously inaccessible method document; inaccessible text not claimed read. |

The attachment URLs in the CSV are workspace-relative paths to the actual supplied files, not invented public URLs. Exact observation dates, reuse conditions and classification remain part of the evidence review. A published story date does not establish when field photographs or observations were collected.

### 4.11 Cost, Trader Registers, Exchange Rates and Country Context

| ID | Dataset/record | Selection and processing significance |
|---|---|---|
| DS091 | Existing unit rates/BOQs/procurement evidence | Comparable technical scope, price date, currency and confidentiality required; no invented budget. |
| DS092 | Existing trader/occupancy/fee/license registers | Distinguish unique traders from stalls/permits; informal and displaced vendors may be missing. |
| DS093 | Official/documented parallel exchange rates | Separate rate regime, date, buy/sell basis and original provenance. |
| DS094 | WFP Sudan country briefs/context | Reviewed portal context; individual linked publications still require acquisition and date checks. |

Cost and trader records are requests for existing evidence, not permission to initiate new interviews or count vendors remotely. Official and parallel currency quotes are not interchangeable. National country-brief statistics cannot be distributed to each market as though locally measured.

## 5. Minimum Acquisition Packages and Alternatives

| Analytical requirement | First-choice package | Defensible alternative or fallback | Decision not supported if unresolved |
|---|---|---|---|
| Identity/reporting geography | DS001 with DS004 and corroborating DS005/source records. | Existing authorized geography/market records with documented uncertainty. | Detailed routing/footprint ranking for unresolved sites. |
| Population/access | One suitable DS007 baseline, compatible DS010/DS012/DS013 totals/definitions, DS021/DS022 and verified entrances. | Alternative DS009/DS015 sensitivity; dated-baseline scenarios when current totals cannot be established. | Current customers/beneficiaries or a verified current resident census. |
| Physical condition | Suitable DS041 and/or authorized DS042 with an adopted baseline inventory. | Area-level optical/radar context, plus existing DS035 records; omit unsupported structure-level metrics. | Structural integrity, hidden damage, ordnance safety or precise stall damage from 10 m imagery. |
| Availability/prices | DS066 explicit monitoring and compatible DS063/DS064/DS065 series. | Applicable existing market-specific reports with observation completeness; retain unknown basket items. | Complete assortment, stock volumes, food safety or affordability without denominators. |
| Conflict/disruption | Authorized suitable DS016 and original DS018 claims. | DS017/context reporting at actual support; broader uncertain summaries. | Safe access or absence of violence from missing/zero records. |
| Flood/environment | DS043 raw depth plus masks; applicable DS044 and relevant DS045/DS047/DS049 or DS050 context. | Declared susceptibility/context with limits; omit falsely precise depths. | Plot drainage certification or quantified losses without vulnerability/value evidence. |
| Functioning services/finance | Applicable DS032/DS034/DS061 records. | Documented older context with current state unknown. | Service reliability, finance uptake or liquidity from mapped POIs. |
| Inclusive livelihoods | Applicable DS072/DS073/DS076/DS077/DS092 records. | Qualitative source-specific constraints and explicit evidence gaps. | Representative trader shares, incomes/jobs, preferences or consent from demographic proxies. |
| Implementation feasibility | Valid DS006/DS019/DS035/DS074/DS075 and cost context DS091. | Conditional options identifying unmet due diligence; high-need/enabling-work portfolio. | Investment-ready status or works authorization where a gate remains unknown. |

The fallback column does not mean an alternative has equal inferential strength. Each analysis must retain the actual evidence class and limitations. No primary collection is authorized through this inventory; records requests must concern already existing information, not new perceptions or estimates from respondents.

## 6. Acquisition and Processing Requirements

### 6.1 Asset Registration

For every resource actually obtained, create a separate asset record containing: DS ID; original legacy source ID where relevant; exact resource URL/identifier; version; observed/acquired/published/retrieved dates; file format; file path; checksum; geographic support; coordinate reference system; native grid/cell size; variable units; scale/offset; nodata/quality masks; license; attribution; sensitivity; owner; method/run references; and suitability/review decision.

A changing `latest` link must be frozen through a named local copy, timestamp and checksum. A source may publish multiple revisions for the same observation period; retain revision history rather than silently overwrite the analytical baseline.

### 6.2 Processing by Data Type

| Type | Required processing | Prohibited shortcut |
|---|---|---|
| Vector boundaries/features | Validate CRS/geometry/IDs, adopted vintage and topology; project working copies; deduplicate documented overlaps. | Guessing a CRS, merging conflicting boundaries, or deleting apparent duplicates without preserving provenance. |
| Population counts/density | Establish variable meaning and cell area; conserve mass; reconcile stock/flow and compatible totals; record allocation assumptions. | Adding alternatives or bilinearly interpolating counts and summing as if conserved. |
| Transport graph | Preserve access/direction/grade tags, true junctions and barriers; review entrances/origins/connectors; version network. | Connecting every geometric crossing, bridging river gaps by tolerance, or zero-cost unreviewed snaps. |
| Optical/radar | Select matched observations; apply product QA and physical scaling; retain actual support; independent interpretation where needed. | Using RGB screenshots as analytical bands or deriving coherence from GRD. |
| Continuous climate/heat/radiance | Decode units/accumulations/time, apply QA, maintain native information support and valid coverage; document aggregation. | Treating resampled coarse cells as new independent 10 m observations. |
| Categorical land/flood products | Preserve class meaning; correct resampling and masks; use raw depth for arbitrary depth thresholds. | Reading exact depths from a classified bin or changing nodata into zero. |
| Prices/availability/finance tables | Harmonize item/grade/unit/rate regime/period/geography and method; trace duplicates and source lineage. | Missing prices as shortages, provider lists as functioning branches, or mixed-unit averages. |
| Documentary evidence | Preserve scoped original claims and page/table/date references; distinguish original sources from copies; translate ambiguous terms carefully. | Assigning national statements to all sites or treating a report citation as reviewed contents. |
| Institutional/safety records | Check authority, exact scope, validity and sharing restrictions; retain unmet requirements. | Treating a high model score or an apparently clear image as the missing approval. |

### 6.3 Date and Freshness Controls

Maintain distinct dates for observation, satellite acquisition, source publication, file release/revision, retrieval, model run and report publication. A daily refreshed portal can host an old observation; an annual series can be released irregularly; a static hazard map can remain valid context without being a current event map.

Use the assessment's proposed freshness alerts as review triggers, not as evidence of validity: 30 days for operational security/road context, 90 days for current market status/prices, and 180 days for current-condition imagery. Actual suitability still depends on source, geography, change rate and methods. Administrative versions, historical baselines and climatologies use different validity rules. Reassess after major conflict, movement, bridge/access, flood, service or sensor changes.

### 6.4 Rights and Sensitive Use

Public accessibility is not a blanket open license. In particular:

- GADM redistribution/commercial use requires specific permission under the reviewed terms.
- OSM-derived data retain ODbL/attribution obligations and shared lineage.
- ACLED and GSMA require current access/use verification; they are not assumed unconditionally open.
- Commercial archival imagery requires explicit acquisition and derivative-publication rights.
- JRC flood metadata/README lists ODbL; the selected resource and attribution obligations must be retained.
- WorldCover states CC-BY 4.0 with required acknowledgment; use actual analytical map assets rather than rendered service colors.
- CDS and other account-based services may change terms; verify the terms in force at acquisition.
- Supplied reference material, clearance records, personal trader lists, sensitive facilities and operational details require the appropriate classification/permission controls.

Hiding a field in a popup is not data protection. Any public derivative must contain only approved fields and records, and its service/export must be tested without the author's privileges.

## 7. Metadata Verification and Remaining Gaps

### 7.1 Official Resources Checked for This Expansion

| Provider/product | Metadata established | Reference |
|---|---|---|
| Geofabrik Sudan | Available extract formats and dated parent snapshot; ODbL attribution. | [Sudan extract catalogue](https://download.geofabrik.de/africa/sudan.html). |
| UN WPP 2024 | National estimates/projections, coverage and annual time/age support. | [WPP](https://population.un.org/wpp/). |
| GHS-POP R2023A | Counts, available grids, five-year epochs, and 2025/2030 projections. | [GHS-POP](https://human-settlement.emergency.copernicus.eu/ghs_pop2023.php). |
| ESA WorldCover | Fixed 2020/2021 releases, algorithm differences, data/quality layers and license. | [WorldCover data access](https://esa-worldcover.org/en/data-access). |
| ERA5-Land | 0.1-degree distributed/9 km native support, hourly values and daily update metadata. | [CDS dataset](https://cds.climate.copernicus.eu/datasets/reanalysis-era5-land). |
| Copernicus DEM | DSM nature, global 30/90 m products, acquisition/release distinction and quality/rights. | [Copernicus DEM](https://dataspace.copernicus.eu/explore-data/data-collections/copernicus-contributing-missions/collections-description/COP-DEM). |
| HydroRIVERS | Thresholded major-river coverage and 15 arc-second source support. | [HydroRIVERS](https://www.hydrosheds.org/products/hydrorivers). |
| CHIRPS v2/v3 | v2 production notice; v3 coverage, 0.05-degree grid, preliminary/final cadence and daily variants. | [CHIRPS v2](https://www.chc.ucsb.edu/data/chirps) and [CHIRPS v3](https://www.chc.ucsb.edu/data/chirps3). |
| JRC river-flood hazard | Global model scope, irregular updates, available masks/return periods, README version and 3 arc-second resolution. | [Landing page](https://data.jrc.ec.europa.eu/dataset/jrc-floods-floodmapgl_rp50y-tif), [directory](https://jeodpp.jrc.ec.europa.eu/ftp/jrc-opendata/CEMS-GLOFAS/flood_hazard/), and [README](https://jeodpp.jrc.ec.europa.eu/ftp/jrc-opendata/CEMS-GLOFAS/flood_hazard/README.txt). |
| Sudan LCA | Contents and mixed chapter revision dates only. | [LCA index](https://lca.logcluster.org/sudan). |

These are metadata/page checks. They do not establish that Sudan pixels, event records, price tables, chapters, or licensed files were downloaded and processed. Earlier successfully reviewed sources and failed/unreviewed candidates retain those distinctions in the CSV. HTTP reachability of every candidate URL has not been tested or claimed.

### 7.2 Unresolved Acquisition Questions

Before analysis, resolve the exact COD version/population resource; each market's identity/geometry; the availability and vintage of HRSL/Sudan building tiles; actual price and availability coverage for the selected cohort; a compatible current-resident denominator; suitable pre/post image coverage and rights; exact authorized conflict exports; original SAMRA contents; and applicable existing finance, inclusion, engineering, tenure, maintenance, environmental and clearance records.

For each unresolved question, record the affected indicator/decision, responsible acquisition role, deadline or review trigger, and fallback consequence. Do not upgrade a discovery portal or unreceived report to analysis-ready status to close the inventory.

## 8. Completeness and Handover

The inventory covers administrative geography; population/age-sex/movement; conflict/access/safety; transport/crossings/national supply logistics; buildings and public/market services; optical/radar/thermal imagery; physical damage; floods/terrain/hydrography; rainfall/climate/land/vegetation/water; nightlights/commercial/finance/digital context; commodities/prices/affordability; supply networks/agriculture/livelihoods; inclusion/protection/food/public health; tenure/engineering/O&M/environmental permissions; costs/trader registers; and the supplied and methodological references.

Its source/indicator crosswalk supports all 42 existing indicator definitions and preserves references to all source IDs from the earlier catalogue. This demonstrates inventory coverage, not data availability or valid calculation of every indicator. An assessment can retain unknowns when evidence is unavailable or unsuitable.

The handover consists of this catalogue guide and [Deliverable_D_Data_Inventory.csv](Deliverable_D_Data_Inventory.csv). Neither an acquired-data geodatabase nor a completed analytical dataset is claimed. Subsequent acquisition must populate the asset manifest and pass the defined suitability, rights, temporal, spatial and processing checks before any substantive result is published.