# E. Component Inventory

## 1. Shared Contract

Analytical components receive an immutable context: release ID, scenario ID, model version, observation period, audience and data status. They do not fetch arbitrary source files, override evidence eligibility or calculate an independent official model. React props/types are generated/aligned with the OpenAPI schemas; runtime validation guards malformed/null data.

| Component | Purpose and principal input | Interaction | Accessibility and state requirements |
|---|---|---|---|
| InstitutionalHeader | Approved logo/name, audience and navigation. | Route/language/account commands. | Landmarks, skip link, current route and approved trademark/font assets. |
| ReleaseContextBar | Release/model/scenario/period metadata. | Approved release/scenario selector. | Never imply upload date equals observation date; announces coherent context change. |
| OverviewHero | Actual cleared image/map and scope copy. | Direct Explorer/report links. | No text in a decorative card or image-only title; inspectable asset and next-section hint. |
| SummaryMetric | Value/unit/bounds/status/source. | Open definition/evidence. | Null not zero; eligible range distinct from confidence interval. |
| SearchField | Arabic/English query and result state. | Debounced search and clear. | Label, keyboard suggestions only if implemented correctly, cancel obsolete requests. |
| FilterPanel | Approved locality/type/status/evidence values. | Apply/reset and URL state. | Native controls, focus-safe mobile drawer; unknown locality distinct. |
| SegmentedMode | Map/list, walking/freight, official/sandbox. | Single controlled selection. | Radio/tab semantics chosen by actual behavior; no color-only active state. |
| MarketResultCard | Cleared identity/status/role/date/coverage. | Select or open profile. | Single understandable main link; no nested interactive traps or fictitious metrics. |
| GeoCanvas | Approved layer descriptors and features. | Pan/zoom/select/pick. | List/table equivalent, explicit map label, attribution not obscured. |
| LayerControl | Allowed layer IDs/visibility/scenario. | Toggle/select and legend. | Checkboxes/toggles; no client control of source access policy. |
| MapLegend | Units/breaks/source support/unknown. | Expand definitions. | Text and patterns alongside color; stable within comparison. |
| FeaturePopup | Approved feature summary and evidence link. | Open profile/close. | Focus/close behavior; no hidden restricted payload in props. |
| ChartFrame | Title, finding, unit, period, uncertainty. | Data-table toggle and permitted export. | Accessible heading/description; stable size and meaningful empty states. |
| D3RankingChart | Eligible score/bounds/contributions. | Focus/select comparison. | SVG keyboard marks/table, no midpoint for incomplete inputs. |
| PopulationRangeChart | Unique reach cases and denominator. | Scenario selection. | Alternatives not stacked; model basis/period explicit. |
| AccessComparisonChart | Origin-weighted time/disconnection. | Mode/approved scenario. | No averaging market medians; over-threshold/disconnected/unresolved distinct. |
| ConflictTrendChart | Unique recorded quantities and precision. | Window/category view. | No safety/attack-probability language; data/coverage gaps exposed. |
| FlowDiagram | Documented nodes/links or quantities. | Commodity/season focus. | Equal-width fallback without volumes; labels/table equivalent. |
| RadarComparison | Complete comparable normalized dimensions only. | Select limited cases. | Unknown axis disables filled polygon; parallel bars preferred where incomplete. |
| TreemapView | Valid mutually exclusive additive hierarchy. | Focus/zoom and breadcrumb. | No area encoding for ordinal score or overlapping catchments; list alternative. |
| BubbleComparison | Comparable x/y and optional size measure. | Focus/select. | Area not radius represents quantity; no income proxy from lights. |
| EvidenceBadge | D/R/M/A/U and observation quality. | Open evidence drawer. | Text label and definition; confidence not blended into performance. |
| EvidenceDrawer | Source claims, methods, dates, rights and gaps. | Focus-safe dialog/details. | Approved records only; Escape/focus return; no client redaction of private data. |
| StatusMatrix | Services/basket/gates and source dates. | Row detail. | Real table headers and explicit unknown; gate status not averaged. |
| NeedReadinessMatrix | Supported need and preparation category. | Open evidence/action. | Unknown need separate from numerical zero; categorical legend. |
| WeightEditor | Six weights and official baseline. | Slider + numeric input; reset. | Sum validation and keyboard adjustment; no official mutation. |
| ExperimentBanner | Owner/context/weights/fingerprint/nonofficial scope. | Cancel/reset/private save. | Persistent sandbox distinction, including exports. |
| JobProgress | Authorized job ID/status/retry info. | Poll with backoff/cancel if allowed. | Progress status not fake percentage; results visible only when complete/authorized. |
| OptionSummary | Problem, alternatives, O&M, gates and stage. | Open conditional detail. | Proposed/approved/completed status evidence; cost unknown stays unknown. |
| NarrativeScene | Chapter copy, allowed map/chart state. | Chapter progression/explorer link. | Reading independent of motion; no scroll instructions as feature copy. |
| AccessibleDataDialog | Approved chart rows/definitions. | Sort/download allowed scope. | Semantic table, stable headers, numeric formats and permissions. |
| EmptyOrErrorState | Distinct loading/zero/missing/stale/denied/failed. | Retry/change allowed context. | Never coerce data failure to zero; understandable remedy and status. |
| ReviewDecisionPanel | Candidate QA/rights and role-authorized decisions. | Approve/reject/promote as permitted. | Audit confirmation; no new field-observation capture. |
| FooterAndSources | Scope/limitations/credits/update role. | Approved documents/contact role. | No local paths as production links or personal secrets. |

## 2. Data and Event Ownership

Page controllers own query context and data loading. Map/chart components emit stable entity IDs and requested approved scene changes. They do not embed another independent router or mutate shared fetched objects. Query invalidation is keyed to release/scenario/model; an experiment never invalidates official score caches.

Use DOM/React events for controls and accessible selection. D3 scale/layout functions are pure helpers; isolate imperative rendering and clean up observers/listeners on unmount. MapLibre/deck instances are created/destroyed once per appropriate lifecycle, not rebuilt for every filter keystroke. Abort requests and dispose WebGL resources when leaving heavy routes.

## 3. Responsive and Visual Contracts

Result cards and option cards have restrained 4-6 px radii; section bands remain unframed. A chart container defines a minimum height and aspect constraint, reports measured size through ResizeObserver and has a nonvisual data equivalent. No card contains another card. Buttons use lucide-react where a familiar symbol exists, with accessible names/tooltips; statuses are not disguised as commands.

Mobile list/map mode preserves the selected market and filters when switching. A desktop side panel becomes a focus-managed drawer or normal stacked content; do not trap page scrolling in a full-screen map. Arabic direction handling belongs in component stories and browser tests, not an untested global CSS flip.

## 4. Component Acceptance Suite

For every analytical component, test known zero, null/unknown, incomplete bounds, stale data, denied source, malformed response, pending/failed job and withdrawn release. Use synthetic fixtures only in tests and clearly marked development stories, never in the published real directory. Add automated accessibility checks plus manual focus/keyboard/screen-reader and 200% zoom/reflow tests.

A CI visual regression suite should cover the approved desktop/mobile/Arabic/reduced-motion states. A screenshot match is not a replacement for numerical, rights or accessibility assertions. Keep component docs linked to the domain definition so that the same label cannot mean two different metrics on different pages.