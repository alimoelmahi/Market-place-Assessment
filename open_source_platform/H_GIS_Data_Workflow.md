# H. GIS, Data and Market-Prioritisation Workflow

## 1. Indicator and Source Contract

[data/indicator_contracts.csv](data/indicator_contracts.csv) specifies all 42 existing indicators: source/dataset identifiers, formats, frequency, reliability score state/rule, processing, eligibility, allowed evidence types and limitations. DS IDs resolve to [the complete source inventory](../deliverables/Deliverable_D_Data_Inventory.csv); legacy source IDs resolve to [the original catalogue](../deliverables/source_catalogue.csv).

Every `reliability_score` is initially `null` because actual observations have not been appraised. The ingestion model converts that literal CSV sentinel to JSON/SQL null, never numeric zero. Q4 means $100(q_r+q_s+q_t+q_m)/4$, with provenance/reliability, spatial specificity, temporal relevance and methodological transparency each scored 0, 0.5 or 1 using recorded reasons. An absent/unsupportable estimate remains null. Critical validity failures override an otherwise high average for eligibility.

High confidence requires at least 80/100, no zero dimension and no unresolved material contradiction; medium requires at least 50 without a critical validity failure and without meeting high; otherwise low for supported qualified use or unknown when no defensible estimate exists. Confidence is not multiplied into performance. A published institutional source is not automatically market-specific or current.

Open-source software can process public or authorized data but cannot change its rights. Default public releases use cleared reusable sources and derivatives; ACLED/GSMA/commercial/land/clearance/confidential records require explicit terms. UCDP or public UN reports can support appropriately scoped alternatives but not an asserted equivalent true event count or safe-access finding.

## 2. Open-Source Processing Stack

Use reviewed versions of GDAL, Rasterio, GeoPandas, Shapely, pyproj and PostGIS for spatial/raster preparation; pgRouting and/or a vetted routing engine for network costs; NetworkX for defined graph statistics; SNAP or a suitable existing specialist product for SLC/coherence; NumPy/Pandas for controlled tabular transforms. Pin interpreter/package/container versions only after compatibility tests in the chosen environment.

No inference engine, routing physics or satellite parser should be improvised from scratch. Files use GeoTIFF/COG, GeoJSON/GeoPackage, Parquet/CSV and registered MVT/PMTiles where appropriate. Raw analytical data remain separate from public display generalizations.

## 3. Processing Pipeline

1. **Acquire:** register exact resource/version/URL, licence, sensitivity, acquisition/observation/publication/retrieval dates, support, units, masks and hash. A portal review is not an acquired dataset.
2. **Resolve:** adopt one boundary version; preserve Arabic aliases; confirm site identity, footprint and entrances from existing sources. Keep the 14-entry/possible-merged-market issue unresolved until clarified; no automatic fifteenth seed.
3. **Standardize:** validate CRS, X/Y, geometry, keys, units and sources; never overwrite raw assets. Metric local analysis normally uses EPSG:32636 after extent review; long/upstream contexts use suitable geodesic/regional methods.
4. **Build graph:** preserve true same-level intersections, bridges/tunnels, foot/vehicle access, direction and barriers. Unknown passability is a scenario assumption, not open fact.
5. **Represent origins:** use defensible population cells/settlement parts and barrier-aware points; preserve parent mass/locality totals and first-mile uncertainty.
6. **Route:** mode-specific directed costs, reviewed origin/entrance connectors, complete statuses and separate threshold/unrestricted passes.
7. **Interpret:** suitable imagery/UNOSAT products for visible conditions; explicit service/availability/price records; qualified environmental/activity signals.
8. **Expose:** precision-aware conflict summaries; native-support flood/event overlays with coverage; safe public aggregation.
9. **Score:** approved raw-to-normalized rules, twenty leaves, uncertainty/gates/need, coherent sensitivity and exploratory separation.
10. **Review and release:** independent desk review, rights and analytical acceptance, sanitized immutable outputs, ready tiles/assets and transactional release promotion.

## 4. Accessibility and Population

For traversable edges, $t_e=60L_e/v_e+d_e$ in minutes with length km and speed km/h. Block restrictions must use the chosen engine's actual exclusion semantics; in pgRouting a negative cost may mean an excluded direction, not a physical negative travel time. Test engine behavior rather than pass invalid speed/cost values.

Total origin-market cost is the minimum over eligible entrances of origin connector + network cost + entrance connector, charging each exactly once. If a connector is explicitly traversed in the graph, do not add it again. A nearest road across a river/wall is not a valid connector by distance alone.

OD-A finds all eligible destinations within a suitable 60-minute network candidate cutoff, followed by total-time filtering at 15/30/60. OD-B has no cutoff/destination limit for each market's fixed 5 km terrestrial neighborhood so that longer reachable paths are not misclassified disconnected. Preserve origin unlocated, entrance unlocated, connector unresolved, beyond threshold, disconnected and solve failed separately. OD display lines are not actual route geometry.

Select one counts baseline and compatible current-resident totals/scenarios. Do not add WorldPop, HRSL, GHSL, COD, IDPs and cumulative returns. If a defensible current resident total is unavailable, label a dated baseline or hypothetical scenario, not current occupancy. For locality total $T_{l,s}$, baseline cell count $B_g$ and justified redistribution modifier $q$:

$$N_{g,s}=T_{l,s}\frac{B_gq_{g,s}}{\sum_{h\in l}B_hq_{h,s}}.$$

Default $q=1$ unless evidence supports change; do not set population to zero because a roof is damaged. Stop invalid zero-denominator allocations. Count rasters need conservative mass allocation, not bilinear interpolation followed by a false conserved sum. Split boundary/water/settlement cells only with documented allocation preserving parent mass.

Individual catchment $H_m(b)=\sum_gN_gI(t_{gm}\leq b)$ can overlap. Unique reach is $\sum_gN_gI(\min_mt_{gm}\leq b)$. Unique allocation assigns each origin once to the nearest eligible market, deterministic exact ties, explicit unallocated remainder. These are potential residents among the selected market set, not actual customers or program beneficiaries.

## 5. Remote Sensing and Risk

Use matched pre-conflict 2022/January-March-2023 and comparable later observations when available. Pre-conflict never includes post-15-April-2023 scenes. Suitable-resolution visible-condition metrics need registration, baseline inventory, observable denominator and independent review. Medium-resolution disturbance is not stall/building destruction certainty or structural integrity.

Sentinel-2 Level-2A uses actual reflectance scaling and cloud/shadow/invalid masks. NDVI $(B8-B4)/(B8+B4)$ retains actual band support and excludes invalid denominators; vegetation is not yield/income. Sentinel-1 GRD backscatter change requires compatible orbit/polarization/calibration; SLC coherence needs a qualified complex-data workflow and cannot be recovered equivalently from GRD.

Landsat temperature needs exact scale/offset and quality flags; delivered 30 m grids do not create 30 m native thermal information or measured air/WBGT. WorldCover 2020/2021 algorithm changes confound raw map differences. CHIRPS version transition requires a coherent reprocessed climatology/current series, not v2/v3 concatenation. Surface water is not potable/operating supply.

VIIRS/Black Marble needs collection/platform continuity, observation quality, gap-fill flags, valid coverage and above-noise baseline. Use neighborhood support; report absolute change when baseline percent is invalid. No radiance-to-GDP/jobs/turnover conversion.

Conflict analysis selects permitted unique violence records with appropriate date/location precision; use 5 km/180 days and alternative windows/distances as declared. No qualifying records does not mean safe. Uncertain geocodes/date windows need broader summaries or possible-inclusion bounds, not exact point assumptions.

Flood analysis uses the actual global JRC raw-depth product (about 90 m in the reviewed release), masks, units and nodata. A classified lowest depth bin cannot support an exact 0.3 m threshold. Separate observed-event extent from river-hazard return periods; preserve unknown areas and small-zone raster support. A modelled exposure is not local drainage approval, actual damage or monetary expected loss.

## 6. Authoritative Scoring Contract

Retain P 20%, A 15%, F 20%, C 15%, E 15%, R 15%. Define $c(z)=\max(0,\min(1,z))$ and validate raw domains before clipping.

$$P=100c\left(\frac{\ln(\max(p,1000)/1000)}{\ln100}\right).$$

Here p is unique potential resident allocation within 60 minutes. Missing/invalid p is not zero. Fixed provisional anchors require approval, not per-run min-max fitting.

$$A=\begin{cases}0,&f<0.5\\100f\,c((90-t)/75),&f\geq0.5,\end{cases}$$

where f is local neighborhood population reachability and t its weighted median among reachable origins using unrestricted required paths. Test sensitivity near the discontinuity at f=0.5. Invalid denominators/unresolved paths require missingness or bounds.

$$F=0.30V+0.30I+0.25O+0.15U.$$

V is explicit available/observed eligible basket items times 100 with at least proposed 80% basket coverage; I is $100(1-d/v)$ among observable baseline structures with at least proposed 80% observable coverage; O is documented closed=0, partial=50, open=100; U averages four equally weighted documented service categories. Unknown service categories remain missing leaves.

$$x=\sum_{e}2^{-a_e/90},\qquad C=100\left[1-c\left(\ln(1+x)/\ln21\right)\right].$$

Eligible violence events are within the configured 5 km/180-day window. C is lower **recorded** exposure, not safety. The 20-event anchor is a scaling assumption, not a danger threshold.

$$E=0.40H+0.30B+0.30D,\qquad R=0.30L+0.25G+0.25M+0.20Z.$$

H uses supported hierarchy 25/50/75/100; B is $100c(b/0.10)$ on a fixed normalized-betweenness graph; D assigns 25 each for positively documented retail/wholesale/aggregation/distribution roles, with unsupported absence left unknown. L/G/M/Z use the approved documentary-maturity rubric 0/25/50/75/100 or null for unknown, covering lawful permission, technical preparation, viable O&M and environmental/social mitigation. Geometry/lighting cannot fill those documents.

$$S=0.20P+0.15A+0.20F+0.15C+0.15E+0.15R.$$

Expand into twenty leaves for coverage: P/A/C; F availability/condition/operation/four service leaves; E hierarchy/betweenness/four role leaves; R four maturity leaves. Effective leaf weight is top weight times subweight (and category share). Sum weights to one.

$$S^-=\sum_kw_kl_k,\qquad S^+=\sum_kw_ku_k,\qquad W=\sum_{k\in K}w_k.$$

Known exact leaves have l=u=value; unknown leaves have null observed score and bounding [0,100]. Do not renormalize away missing weights or report midpoint as measured. Complete point scoring requires all required leaves eligible. Provisional screening requires W>=0.8, each criterion's within-criterion coverage>=0.5, and F/R>=0.75; otherwise insufficient. Preserve within-criterion validity even if an analyst sets its top weight to zero: zeroing an unavailable criterion cannot create an official complete or investment-ready result.

Need is a separate supported category. Five independent gate groups remain identity/scope; security/access/explosive remnants; tenure/permission; technical/environmental-social; economic additionality/O&M. Any failed/unknown gate prevents investment-ready status without assigning zero humanitarian need. No evidenced deficit/additionality means no established rehabilitation case even for a high-functioning market.

## 7. Sensitivity, Confidence and Experimental Behavior

Use fixed approved anchors and comparison universe per release. For relative weight change $\delta=\pm0.2$, set $w'_j=w_j(1+\delta)$ and $w'_k=w_k(1-w'_j)/(1-w_j)$ for others. Compare equal weights and declared policy views separately from the official base. Test population, speed, network failure, exposure precision/window/buffer, completeness thresholds and anchor choices.

Coherent network/population changes rerun dependent P/A/B and exposure, not independent point subtractions. Optional >=1,000 robustness draws require approved distributions/dependencies/seed and convergence review; frequencies are not success probabilities. Report rank bands/score bounds, availability of comparable scenarios and high-need blocked/evidence-gap portfolios.

Risk treatment defaults to independent gates, explicitly represented base inputs, and coherent stress scenarios. Do not apply a generic risk/confidence haircut that double-counts C/R/F. Any optional incremental residual adjustment requires a separate model, nonduplicative evidence and explicit assumptions; it stays disabled in the official base.

Use [the existing synthetic fixtures](../deliverables/Deliverable_E_Synthetic_Test_Cases.json): X=65, Y=67.5; missing R gives 59-74 and W=.85 but fails criterion coverage; raw example A approximately64.8535; a single unknown service widens by .75 points. Backend and client-preview helpers must pass the same tests. These fixtures never enter real released data.

## 8. QA and Data Refresh

Source cadence is not observation currency or platform polling. Review existing access/conflict material frequently, market/price/availability according to actual monitoring cadence, population on compatible releases, imagery on suitable acquisitions, static hazards on versions and events, and gates on validity/material change. Always show last actual observation and last successful analysis/release separately.

Automate schema/units/date/geometry/lineage checks and conservation/status reconciliation; independently review shortlisted site interpretations and conditions; keep failures/quarantine. Idempotent versioned jobs preserve originals, retries and audit. Failed refresh retains last approved scoped release or withdraws unsafe/rights-invalid content, never publishes half-updated or zero-filled results.