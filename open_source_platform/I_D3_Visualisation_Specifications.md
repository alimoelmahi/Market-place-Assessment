# I. D3 Visualisation Specifications

## 1. Shared Visualization Contract

The release-scoped API `/v1/releases/{release_id}/analytics/{product_id}` supplies reviewed V01-V10 data, not raw restricted records. Envelope fields include release, scenario, model, status, unit, source references and limitations. The data is either `tabular` rows or a `flow` nodes/links structure. Backend response models must enforce the product-specific columns below; the generic OpenAPI envelope is not permission to leak arbitrary JSONB fields.

Use React-owned SVG for the modest selected-market cohort, with D3 scales, arrays, shapes, layouts and time formatting. Canvas may be appropriate for large safe aggregates, with an equivalent accessible table. MapLibre/deck handles geospatial rendering; charts do not create a second unsynchronized global selection store.

Common optional row fields: evidence_type, confidence_class, observed_start/end, missing_reason, source_refs and native_support. Unknown is null, not zero. Every chart has title, concise supported finding, units/period/scenario, accessible description, keyboard selection, table alternative, stable layout, responsive labels and reduced-motion behavior. No interaction is hover-only.

## V01. Market Ranking and Contribution Chart

**Purpose:** Explain complete eligible scores and incomplete intervals, not a league table of humanitarian worth.

**Data:** rows `{market_id,label,point_score:number|null,lower:number,upper:number,covered_weight:number,coverage_class,analytical_rank:number|null,investment_rank:number|null,need_class,gate_status,contributions:{P,A,F,C,E,R}}`. Each contribution is points or null/bounds; one release/scenario/model. Values cannot be mixed across criteria units.

**D3 implementation:** `scaleBand` for market rows and fixed `scaleLinear([0,100])` for score; `stack` only for valid additive criterion contributions; interval lines for bounds; text for unknown/unranked. Stable sorting uses approved analytical rank with a separate unranked section. Do not sort a fabricated interval midpoint.

**Interaction:** keyboard/pointer focus opens raw-to-score evidence and profile; approved scenario selection updates context; sandbox values visibly nonofficial. **Fallback:** if no point comparison is eligible, show intervals/coverage and preparation categories. **Library:** d3-scale/shape/array; React SVG.

## V02. Potential Population-Served Visualization

**Purpose:** Show unique potential resident reach and its population/network assumptions.

**Data:** rows `{market_id,case_id,population_basis,population:number|null,lower:number|null,upper:number|null,unallocated:number|null,threshold_minutes,aggregation:'unique_allocation'|'union'|'individual_overlap'}`. Backend defines valid aggregation and population denominator; low/central/high cases are alternatives.

**D3 implementation:** horizontal range/dot bars using linear scales and common units, or mutually exclusive assignment shares when a coherent union is selected. Use `extent`/`max` only for appropriate display domains; maintain comparability across paired scenarios. No additive stack of overlapping catchments or alternatives.

**Interaction:** select scenario/threshold and linked market; reveal source-year/basis. **Fallback:** dated baseline/hypothetical label or no numeric reach when denominator invalid. **Library:** d3-scale/array/format; React SVG/table.

## V03. Accessibility Comparison

**Purpose:** Compare origin-weighted burden, known disconnection and coherent scenario effects.

**Data:** rows `{market_id,mode,case_id,median_minutes:number|null,reachable_fraction:number|null,unresolved_fraction:number|null,time_band,population:number|null,detour_ratio:number|null,route_status}`. Distinct states include over-threshold reachable, disconnected and data-unresolved.

**D3 implementation:** paired-dot chart for compatible median/time values and mutually exclusive band bars for origin distributions; use `scaleBand`, `scaleLinear` and keyed joins. Different modes use separate panels. Do not derive a state median from mean market medians or finite values for disconnected routes.

**Interaction:** reference/slower/bridge scenario and walking/freight selection; focus reveals denominators. **Fallback:** status table for unresolved/invalid routes. **Library:** d3-scale/array/shape, React SVG.

## V04. Recorded Conflict Trend

**Purpose:** Describe qualifying reported exposure and reporting/precision limitations.

**Data:** rows `{period_start,period_end,reporting_area_id,event_count:number|null,weighted_count:number|null,excluded_precision_count:number,possible_count:number|null,coverage_note}`. Counts are unique over the selected geographic union, not the sum of overlapping market buffers. Aggregates meet source rights/publication policy.

**D3 implementation:** `scaleUtc` and `scaleLinear`, bars or `line().defined(...)` preserving missing intervals; separate precision/exclusion panel. Do not call a smoothed line risk probability or imply complete surveillance.

**Interaction:** approved window/category/geography; source explanation on keyboard focus. **Fallback:** broader contextual summary or unknown when fine geocodes unsuitable. **Library:** d3-scale/time/shape/axis; React SVG.

## V05. Risk Dashboard Small Multiples

**Purpose:** Compare flood, infrastructure and contextual exposure without an invented all-risk score.

**Data:** rows `{market_id,risk_theme,hazard_definition,metric,unit,exposed:number|null,valid_denominator:number|null,unknown:number|null,coverage_fraction:number|null,scenario_id}`. Different units remain separate. Gates are a distinct categorical panel, not averaged numerically.

**D3 implementation:** small multiples with per-metric scales, explicit valid/unknown segments and synchronized labels; categorical gate table. A depth map/area fraction is not expected economic loss. Do not add return periods.

**Interaction:** one hazard/event/scenario at a time; link to appropriate map and evidence. **Fallback:** coverage and unresolved-condition table rather than no-risk green. **Library:** d3-scale/array/shape, React components and MapLibre links.

## V06. Quantified Supply-Chain Sankey

**Purpose:** Show compatible documented quantities through a valid directed flow structure when such data actually exist.

**Data:** `flow` nodes `{id,label,role}` and links `{id,source,target,value:number|null,evidence_type,commodity,period}` plus envelope unit and coverage. Nonnegative values must refer to the same commodity/unit/period; stage accounting must be defensible, with documented losses/source/sink handling. Cycles or incompatible values fail Sankey eligibility.

**D3 implementation:** use the established `d3-sankey` library, not a handwritten flow engine; clone layout inputs because the layout mutates its nodes/links. Set `nodeId`, consistent alignment and minimum label space; widths encode quantities only. Do not replace missing volumes with 1 to create persuasive quantitative widths.

**Interaction:** commodity/season/period, keyboard node/link details, linked hub/market profile. **Fallback:** V07 equal-width documented relation diagram when volume or balance is absent. **Library:** d3-sankey, d3-scale and React SVG.

## V07. Supply-Chain Flow/Relationship Diagram

**Purpose:** Explain documented relations and modelled alternatives even without volume.

**Data:** same FlowData with nullable value; link evidence, commodity/period and reported-versus-modelled distinction retained. Optional `route_kind` is documented/modelled/schematic as specified in the API; backend response models must validate the chosen relation type.

**D3 implementation:** stable staged node layout or a deterministic vetted D3 force layout with bounded iterations/seed for a schematic. Use `linkHorizontal`/paths and equal width when magnitude unknown; map equivalent uses Deck.gl PathLayer/ArcLayer with actual-versus-schematic distinction. Do not animate speed as throughput.

**Interaction:** focus a commodity/hub and reveal the scoped source; keyboard table offers every link. **Fallback:** source-destination table if the graph is dense or unverified. **Library:** d3-shape/force where justified; Deck.gl for geographic view.

## V08. Radar Comparison

**Purpose:** Provide an optional overview of six complete comparable normalized dimensions, not primary evidence of overall superiority.

**Data:** rows `{market_id,criterion_id,score:number|null,lower:number|null,upper:number|null,eligible:boolean}` with exactly P/A/F/C/E/R for each compared case. Raw units and weights remain available separately. No inferred zero on missing axes.

**D3 implementation:** fixed angle order and fixed [0,100] radial scale; `lineRadial`/closed line only for fully eligible cases. Prefer outlined low-opacity polygons with explicit labels; note that polygon area is not aggregate benefit. Limit simultaneous cases to preserve readability.

**Interaction:** choose a small complete comparator set and keyboard-axis details. **Fallback:** parallel horizontal component bars or interval matrix for incomplete cases; never close a fabricated polygon. **Library:** d3-scale/shape; React SVG.

## V09. Treemap

**Purpose:** Show a genuinely additive mutually exclusive hierarchy, such as deduplicated observable baseline footprint area by market/type, not relative readiness.

**Data:** rows `{node_id,parent_id,label,value:number|null,unit,coverage_note}` with acyclic hierarchy, unique membership and one comparable nonnegative additive measure. Overlapping catchment populations, ordinal scores, unknown-as-zero areas and duplicate buildings are ineligible.

**D3 implementation:** `stratify`/`hierarchy().sum(...)` and `treemap`, with stable order and readable labels; do not silently sum an unobserved branch as measured zero. Backend supplies known-measure coverage and omitted/unknown state separately. Aspect/size changes cannot alter the metric.

**Interaction:** keyboard drilldown/breadcrumb, focus details and linked profile; table equivalent. **Fallback:** grouped bars/coverage table if additivity is not established. **Library:** d3-hierarchy/scale; React SVG.

## V10. Bubble Comparison

**Purpose:** Explore association among eligible access, functionality and potential reach without causal inference.

**Data:** rows `{market_id,label,x_median_minutes:number|null,y_functionality:number|null,size_unique_residents:number|null,reachable_fraction:number|null,need_class,eligibility}` under the same coherent scenario. All displayed dimensions must be eligible; absence is reported in a separate excluded-case list.

**D3 implementation:** linear x/y scales, `scaleSqrt` radius so area represents population, stable axes and a size legend; use point labels/selection rather than jitter that implies new observations. Different support/periods cannot be silently merged. Mark the reachable-subset nature of a median.

**Interaction:** keyboard/pointer select, rectangle selection only with equivalent controls, approved filters and raw evidence detail. **Fallback:** comparable table without a size circle if population is unknown; do not default missing size to a meaningful quantity. **Library:** d3-scale/array/format; React SVG.

## 2. Cross-Chart Selection and Testing

Selections emit stable market/node IDs to page state and map adapters. They do not propagate by label matching or silently change the approved scenario. D3 helpers receive immutable validated data; React controls accessibility and lifecycle; ResizeObserver updates measured layout without viewport-sized fonts or destructive redraws.

Test each product with complete, partial, missing, zero, extreme, long Arabic/English labels, tiny viewport, reduced motion and denied/withdrawn data. Numerical assertions compare to released aggregates and fixtures; visual snapshots alone cannot validate a denominator. The API/renderer validates V06 flow quantities and V09 additivity before drawing. No demonstration fixture enters real findings.