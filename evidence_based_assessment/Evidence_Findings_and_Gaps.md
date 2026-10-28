# Evidence Findings and Gaps

Snapshot notice: this report records the initial indicator-evidence run. The later [market inventory](market_inventory/README.md) supersedes its market-identity and OSM/publication acquisition status: two OSM source points and one market polygon have since been retained, with other identities unresolved. The original 14-file counts and the initial indicator matrix are not a current gazetteer acquisition total. The new inventory remains provisional and does not enable market rankings.

Assessment evidence review: 27 October 2026. This is a source-coverage audit and limited contextual analysis, not a completed market-functionality assessment. No selected-market ranking, synthetic observation, inferred customer count or fabricated market coordinate is supplied.

## Evidence Actually Obtained

The [verified input register](processed/verified_input_assets.csv) identifies 14 downloaded files with exact URLs, byte lengths and SHA-256 checksums. These are not 14 independent datasets: some are metadata, documentation or resources from the same provider dataset. The acquisition manifest preserves 25 attempts, including failed attempts and successful retries; attempts must not be counted as independent evidence.

The [42-indicator matrix](indicator_evidence_matrix.csv) supplies the requested source, methodology, date coverage, limitations and confidence for every indicator. Candidate sources are explicitly distinguished from acquired resources. Its confidence statements concern the intended use, not merely publisher reputation. No eligible selected-market measurement has yet been established. A contextual observation is not assigned to a selected market without identity and geographic support.

## Defensible Findings

### WFP Price Monitoring

Source: [WFP Sudan food prices on HDX](https://data.humdata.org/dataset/wfp-food-prices-for-sudan), acquired CSV resource and provider metadata. The metadata attributes inputs to FPMA, SIFSIA via FAO GIEWS, and WFP; these lineages are not independent corroboration of each other.

The acquired national file contains 22,698 rows. Filtering the actual `admin1` label `Khartoum` yields 1,127 rows, 17 separate series, and one source market identifier, `2588`, labelled `Khartoum`. Its source `admin2` label is `Jebal Aulya`. This does not establish equivalence to any selected KHM market or justify copying the observations across the market register.

Source observation dates span 15 January 2001 to 15 September 2026 within the Khartoum subset, but individual series have different start/end dates and substantial gaps. Historical wholesale grain observations ending in 2022 are not current quotations. The 17 series include an unofficial exchange-rate series; they are not 17 food commodities. Source dates are retained as provider reporting labels, not claimed field-visit dates.

The [source subset](processed/wfp_khartoum_source_observations.csv) preserves original columns and values. The [series audit](processed/wfp_khartoum_series_coverage_and_changes.csv) separates market ID, commodity ID, unit, retail/wholesale type, currency and actual/other price flag. It performs no unit conversion or inflation/FX adjustment.

For unique positive observations in consecutive months, nominal monthly change is `100 * (latest price / previous-month price - 1)`. Values are absent where the required observations are missing or ambiguous. There is no interpolation across gaps. For instance, the source onion quotation is 1,719 SDG/KG on 15 September 2026; its directly calculated nominal change from the preceding source month is 71.9%. This is a monitoring-location result, not a finding for any particular selected market or for household affordability.

Only three series have an eligible latest window of 12 distinct consecutive positive monthly observations: retail millet (`3.5 KG`), retail sorghum (`3 KG`), and the explicitly labelled unofficial exchange-rate series. The processor calculates sample standard deviation of their 11 monthly log price changes. These are nominal source-series variability measures, not resilience scores. All other series retain missing variability results rather than receiving zero.

Confidence: moderate for faithful extraction and comparable-source arithmetic; low for representativeness beyond the reporting series; not assessable for attribution to a selected market. Price presence does not establish stock quantities, basket availability, nutritious assortment, real purchasing power or business reopening.

### World Bank National Context

Sources: [consumer-price inflation API](https://api.worldbank.org/v2/country/SDN/indicator/FP.CPI.TOTL.ZG?format=json&date=2019:2026&per_page=100) and [official exchange-rate API](https://api.worldbank.org/v2/country/SDN/indicator/PA.NUS.FCRF?format=json&date=2019:2026&per_page=100). Both acquired responses report `lastupdated=2026-10-08`.

For the requested period, both series contain non-null national observations for 2019-2022 and nulls for 2023-2025; no 2026 observation was returned. The [context table](processed/worldbank_national_context.csv) preserves these nulls explicitly. An API update date is not the observation date, and it does not make the older values current.

Confidence: moderate for extracting the published national observations, not for estimating current local conditions. No interpolation, post-2022 projection, local inflation estimate or substitution of official rates for the WFP unofficial series is made.

### Administrative Geography

Source: [Sudan COD administrative boundaries](https://data.humdata.org/dataset/cod-ab-sdn), actual GeoJSON archive. Filtering the actual `adm1_pcode=SD01` produces [seven locality polygons](processed/khartoum_cod_admin2.geojson): Bahri, Jebel Awlia, Karrari, Khartoum, Sharg An Neel, Um Bada and Um Durman. Source names and geometries are preserved.

The resource is v03, with `valid_on=2020-08-31`. Provider metadata records a completeness/accuracy review on 30 October 2025 and original source geometry editing on 13 August 2013. The 2026 resource modification timestamp must not be interpreted as a fresh boundary survey. The subset is administrative context only, not a market-location, accessibility, damage or functionality map. Topology, positional accuracy and present legal validity have not been independently certified.

Confidence: moderate for these source administrative identifiers; unverified for market assignment and current positional/legal validity. The concept-note audit still identifies 14 populated entries with a possible combined livestock/camel entry; it does not identify a defensible missing fifteenth name.

### Population Reference-Date Conflict

Source: [Sudan COD population statistics](https://data.humdata.org/dataset/cod-ps-sdn), actual ADM1/ADM2 CSVs, release note and technical note. The acquired CSVs named 2025 contain 18 ADM1 rows and 188 ADM2 rows, all with `Year=2024`. The acquired release note describes a reference date of 1 July 2025 and a release date of 18 August 2025. Its contents retain draft markings and some inconsistent year headings.

The release note describes cohort-component projection from the 2008 census using fertility, mortality and mobility evidence, followed by ADM2 disaggregation through iterative proportional fitting. It references IOM DTM and UNHCR inputs. These are modelled projections, not observed current occupancy; citing the note is not direct acquisition or independent review of its underlying IOM, UNHCR or ACLED data.

The population notes describe 18 states/188 localities, while the boundary metadata describes 19 states/189 localities. This additional geographic-version issue requires reconciliation before national joins or allocations. Seven Khartoum population rows are present, but no selected-market catchment has been calculated.

The [date-conflict audit](processed/population_reference_date_conflict.csv) blocks assessment use pending custodian clarification or acquisition of a consistent replacement. No totals are silently relabelled, extrapolated to 2026, redistributed or converted into customers, trader demographics or beneficiaries. Confidence for the intended current population denominator is not assessable until the conflict is resolved.

The acquired [WorldPop API catalogue](https://www.worldpop.org/rest/data/pop/wpgp?iso3=SDN) lists 21 Sudan population-count products for 2000-2020. It describes random-forest dasymetric redistribution and approximately 100 m cells. No listed raster has been downloaded or summed. This query does not establish that newer products are unavailable elsewhere, or provide current conflict-adjusted population.

### Flood Product Metadata

Sources: actual JRC [README](https://jeodpp.jrc.ec.europa.eu/ftp/jrc-opendata/CEMS-GLOFAS/flood_hazard/README.txt) and [tile index](https://jeodpp.jrc.ec.europa.eu/ftp/jrc-opendata/CEMS-GLOFAS/flood_hazard/tile_extents.geojson). The README identifies global river-flood hazard v2.1.2, last updated 12 January 2026, approximately 90 m grid spacing, modelled depth in metres and irregular updates. Temporal coverage is explicitly `NA`; this is not an observed 2026 flood extent.

Raw depth differs from the classified product. Permanent-water and spurious-depth masks are separately required. The producer documents possible depth artefacts, DEM and tile-boundary issues. No raw hazard raster or masks have been acquired, no return-period exposure has been calculated, and no market flood percentage is available. Confidence is moderate for the documented product specifications only, not local hazard exposure, drainage performance, mitigation feasibility or approval.

## Requested Sources Not Yet Integrated

These are actual acquisition/review gaps, not substitute observations. The matrix and earlier source inventory identify candidate source URLs; none of the following gaps is represented as an analytical result.

| Source | Current evidence boundary |
| --- | --- |
| ACLED | No authorized event extract acquired; no local event counts, recency scores or safety claims. |
| HDX | COD boundaries, COD population files and WFP resources acquired as described above; other catalogue listings are not acquired evidence. |
| WorldPop | Specified historical catalogue acquired; no population raster acquired. |
| OpenStreetMap | The attempted Overpass query timed out; no road/marketplace/facility extract acquired. This does not mean features are absent. |
| Copernicus / Sentinel-2 | No reflectance scenes acquired or interpreted; no market damage or vegetation result. JRC/CEMS flood metadata is a distinct product, not Sentinel-2 imagery. |
| Landsat | No thermal or reflectance scenes acquired; no heat or image-change indicator. |
| VIIRS | No radiance arrays or QA data acquired; no activity/recovery change result. |
| UNDP | Supplied assessment references reviewed previously; the Kobo framework is an uncompleted questionnaire, not observations. No additional dated market dataset acquired. |
| World Bank | Two national series acquired with the gaps described above; no current market-level or household denominator dataset. |
| OCHA / HNO / HRP | COD resources acquired; attempted ReliefWeb discovery failed or timed out. No HNO/HRP report from those calls was acquired or used for findings. |
| IOM DTM | Mentioned as an input in the acquired population note, not directly acquired or analysed; no current mobility adjustment applied. |
| FEWS NET | No specific report/data extract acquired and reviewed in this evidence run. |
| WFP | Actual price file acquired and processed; no explicit basket-availability, stock or income-denominator assessment acquired. |
| FAO | Named in WFP dataset lineage; no separate FAO assessment or agricultural dataset acquired in this run. |
| REACH | Attempted ReliefWeb discovery did not acquire a report; no current market monitoring report processed. |
| UN-Habitat | Attempted ReliefWeb discovery did not acquire a report; no urban damage/service dataset processed. |
| Google Open Buildings | No building polygons or confidence fields acquired; no footprint/damage/trader calculation. |
| Meta HRSL | The attempted exact HDX package URL returned 404; this does not establish absence of a Sudan product. Correct resource discovery remains open. |

Provider access failures and local processing failures are distinct. Earlier HTTP-200 downloads affected by a local timestamp-handling error were successfully retried; they are not still classified as inaccessible. ReliefWeb 410 responses and Overpass timeout remain documented in the acquisition log. No authentication or access control was bypassed.

## Evidence Gates Before Market Findings

1. Resolve the distinct market list and corroborate actual site entrances/footprints from existing records and maps. Do not invent a fifteenth market or a coordinate.
2. Resolve population observation year and geographic version with the source custodian, and acquire an eligible population surface if catchments are needed.
3. Acquire actual dated, appropriately scoped reports and authorized event, network, imagery and service datasets for the relevant indicators. Preserve rights, provenance, uncertainty and source independence.
4. Derive only observations supported by those resources. Keep demographic context, accessibility, physical condition, operation, safety and investment prerequisites separate.
5. Keep ranking disabled until comparable actual inputs and defensible approved value functions exist. Decision weights are preferences, not observations. Unknown values do not become zeros or pass independent safety/tenure/engineering gates.

## Reproducibility and Rights

[Build-EvidenceAudit.ps1](scripts/Build-EvidenceAudit.ps1) reads only acquired inputs and the existing indicator/source contracts. It verifies all downloaded input hashes and byte lengths, retains original price units/labels, extracts actual boundary features, and requires complete source/method/date/limitation/confidence fields for all 42 indicators. It generates no synthetic observation fixtures. Date gaps remain gaps; reported monthly observations are not filled.

The processing outputs point back to [exact input hashes and URLs](processed/verified_input_assets.csv); [coverage summary](processed/coverage_summary.json) records the current scope. Acquisition statuses and original failed attempts are preserved separately from this scoped content review. Population documentation was examined for reference date and method; no exhaustive verification of its underlying demographic inputs or all technical appendices is claimed.

The HDX metadata identifies CC BY-IGO for the boundary and WFP datasets and CC BY for population. WorldPop supplies its own product licence link. The JRC README identifies ODbL 1.0. Preserve provider attribution and verify resource-specific terms before redistribution. National and source-monitoring observations are not confidential-source permissions. Supplied internal/confidential documents and original files remain unchanged.

Historical A-G/platform worked examples and assumed modelling/scoring parameters are superseded design history, not active observations or validated results. The generated fictional fixture payload has been withdrawn and active ranking remains disabled. This note does not claim that every historical design document has been scrubbed of all earlier examples.