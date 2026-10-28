# D. Page Wireframes

## Shared Shell and State Contract

These are functional wireframes, not pixel-validated screens. All pages inherit the institutional header, active release/period/scenario bar, accessible landmarks, evidence drawer and responsible-use footer. Desktop grids become stacked mobile views; stable map/chart dimensions prevent layout shifts. Buttons use the component conventions in C/E, not literal brackets as a visual design.

Each data page supports loading, true zero, not assessed, stale, denied, failed, withdrawn release and unknown identity. Never render fictional scores or coordinates to make an empty design appear finished. Public/internal content is decided by server policy, not hidden tabs.

## 01. Overview `/`

```text
DESKTOP
Institutional header | Markets | Risk | Priorities | Recommendations | Report
Release / observed periods / evidence coverage
Full-width real-place image or inspectable map with Khartoum State Markets title
Supported findings and qualified summary metrics | direct Explorer/report entry
Interactive overview map | concise evidence/context summary
Next report section visible below first viewport
```

**Mobile:** compact header, literal title and image/map, concise scope/date, stacked metrics then map/list entry. Hero height must not hide all following content. **State:** no eligible numeric observations means evidence-gap labels, not zero population or a made-up top market. Hero assets require rights and dates.

## 02. Market Explorer `/markets`

```text
DESKTOP
Search and result count | active filters | release/scenario
Filter rail | unframed map and legend | results list / selected preview
Type/locality/status/evidence filters | permitted layer controls
Compare selection (limited supported cases) | accessible table alternative
```

**Mobile:** map/list segmented mode, search above, filter drawer, selection opens a sheet/profile link without covering attribution. **Behavior:** search debounced/cancelable; URL state; list/map share stable ID. Unresolved location appears in list only with reason, never at 0/0.

## 03. Market Profile `/markets/:marketId`

```text
Name Arabic/English | locality or unresolved | role | source periods
Overview | Access | Supply | Condition | Risk | Evidence | Opportunities
Site map/approved image | documented status and evidence summary
Potential residents / access chart | service/commodity/condition matrix
Supply role / recorded exposure | independent gate/action panel
Conditional options and no-build alternatives | source details
```

**Mobile:** header, tabs with overflow-safe alternatives, map then stacked charts and evidence. **Behavior:** changing scenario updates compatible panels only; source-specific periods remain explicit. Unknown identity or no geometry suppresses location-dependent panels rather than the whole documentary record.

## 04. Conflict Intelligence `/risk/conflict`

```text
Risk tabs: Conflict | Flood | Infrastructure
Window/category/approved geography selection | observation coverage
Generalized recorded-exposure map | trend and precision exclusions
Documented interruptions | source/limitations table
No safe-route or clearance inference
```

**Mobile:** summary/definitions, map, trend, exclusions, evidence. **Behavior:** unique event totals over selected union, not sum of overlapping buffers. Restricted raw events never appear through hidden downloadable JSON. Zero records and unavailable dataset have different states.

## 05. Flood Intelligence `/risk/flood`

```text
Hazard scenario / raw-depth threshold | observed-event selection
Modelled river hazard map | separate observed-event view
Asset / road / potential population exposure with valid coverage
Unknown area and product resolution | related access-stress scenario
```

**Mobile:** separate hazard/event tabs with the same definition text and noninteractive equivalent. **Behavior:** return periods are alternatives, not additive. No-data is hatched/unknown; classified depth cannot support arbitrary exact thresholds. Site drainage/engineering approval remains outside the map.

## 06. Infrastructure Vulnerability `/risk/infrastructure`

```text
Market/type/observation filter | actual imagery dates
Qualified visible-condition map/pair | observable baseline denominator
Mapped assets and separately documented service status
Unobservable/uncertain structures | technical prerequisites
```

**Mobile:** single qualified image/map with comparison control if usable, then condition and coverage. **Behavior:** unsupported image pair yields a qualified single view or no fine damage metric. An apparently intact roof is not coded structurally safe.

## 07. Prioritisation `/priorities`

```text
Official model/version/scenario | coverage and decision-status legend
Opportunity map | contribution/ranking matrix + score intervals
Need/readiness portfolio | gate/action register
Authenticated ANALYST SANDBOX (separate region)
Six weights: sliders + numeric inputs + sum / reset official
Preview bounds -> server evaluation job -> sensitivity / private save
```

**Mobile:** official table/portfolio first, sandbox collapsed until explicitly opened. **Behavior:** edits never change official results; unknown leaves stay unknown; invalid weight sum blocks evaluation. Job progress/cancel/error states do not show zero results. Analyst sandbox always carries a nonofficial label.

## 08. Recommendations `/recommendations`

```text
Package / locality / preparation status filters
Conditional option map | option list with evidence and prerequisites
Enabling -> rehabilitation -> longer-term pathway
No-build/service alternative | O&M / inclusion / permissions
Responsible role and next decision | gaps and refresh trigger
```

**Mobile:** option list and short dependency plan; map optional view. **Behavior:** no invented costs, jobs or approval badges. Proposed/approved/implemented state must be explicitly supported; default unknown is not approved.

## Report Template

```text
DESKTOP
Chapter navigation | chapter title and evidence period
Readable narrative column | wide map/chart scene band
Definition / finding / limitation | linked evidence and explorer state
Next chapter preview and previous/next navigation
MOBILE
Chapter chooser -> narrative -> static or interactive figure -> evidence -> next
```

Use the following seven route-specific scenes, not one generic text page with different titles.

## 09. Context `/report/context`

**Wireframe sequence:** locator -> observation timeline -> population/movement context -> economic small multiples -> market-system transition. **Desktop:** narrative plus locality view; **mobile:** source-dated panels stacked. **States:** no harmonized current resident total means historical baseline/model scenario label; national indicators cannot become local observations.

## 10. Market Systems `/report/market-systems`

**Wireframe sequence:** market roles -> commodity-network map -> node-link/eligible Sankey -> supplier/crossing dependencies -> access transition. **Desktop:** system map and role matrix; **mobile:** one commodity/season at a time. **States:** missing volumes replace Sankey with equal-width relations; an unreceived report does not supply flow values.

## 11. Accessibility `/report/accessibility`

**Wireframe sequence:** geographic barrier -> total-cost time reach -> potential residents -> unique allocation -> crossing/slower scenario. **Desktop:** paired reference/disruption map and interval chart; **mobile:** separate explicit states. **States:** invalid geometry/network suppresses reach; modeled customers are never claimed.

## 12. Functionality `/report/functionality`

**Wireframe sequence:** condition versus operation -> repeated illustrative profile -> service/basket matrix -> applicable prices/status -> risks. **Desktop:** site map/qualified imagery pair plus aligned components; **mobile:** inspected single scene and data table. **States:** no suitable imagery or availability panel means unknown, not zero/green.

## 13. Vulnerability `/report/vulnerability`

**Wireframe sequence:** recorded exposure -> precision/exclusions -> hazard versus observed flood -> heat/water context -> independent gates. **Desktop:** distinct map panels; **mobile:** clear theme tabs and text summary. **States:** exposure/hazard/impact/clearance stay distinct and restricted details are absent.

## 14. Prioritisation `/report/prioritisation`

**Wireframe sequence:** six weights -> contributions/bounds -> scenario stability -> need/readiness portfolio -> next-action distinction. **Desktop:** concise map/matrix; **mobile:** readable interval/table. **States:** no eligible point ranking produces an evidence/preparation portfolio, not dummy league-table values. Explorer link carries official approved scenario, not sandbox weights.

## 15. Recommendations `/report/recommendations`

**Wireframe sequence:** constraint-response options -> phases/prerequisites -> responsible roles -> gaps/refresh -> final evidence note. **Desktop:** conditional packages and decision table; **mobile:** prioritized reading sequence without implied funding award. **States:** no viable site case means an explicit preparation/evidence action, not a construction promise.

## 16. Evidence and Methods `/evidence`

```text
Source / indicator / release tabs | search and filter
Coverage / rights / quality definitions
Cleared source and indicator tables | observation lineage drawer
Approved methods and download records with version/date
```

**Mobile:** searchable list with accessible detail pages/drawers. **Behavior:** metadata-only source records do not imply downloaded resources. Protected identifiers, raw personal records, confidential files or unlicensed documents are not discoverable from public results.

## 17. Restricted Review `/review`

```text
Authenticated role and candidate release
Sources/rights -> analytical QA -> findings -> reviewer decision
Candidate versus previous release semantic differences
Publisher promotion/withdrawal and actual audit trail
```

**Mobile:** read/review tasks only where safe; complex publishing can be restricted to supported desktop workflows by organizational policy. **States:** 403 denied not a login loop; reviewer cannot silently publish without publisher rights. Forms capture document workflow decisions, not newly solicited market-condition observations.

## 18. Sign-In `/sign-in`

**Wireframe:** institutional heading -> reason for restricted access -> approved OIDC handoff -> return route. **Mobile:** same semantic flow. **States:** expired session, denied institutional access, provider unavailable and successful return differ. No locally invented password form, shared credential or token in redirect URL; accessible public content remains readable without sign-in.

## Interaction Acceptance

Test each page with keyboard, screen reader, 200% zoom, narrow mobile viewport, reduced motion, delayed/failed fetch, empty/partial data, revoked access, invalid IDs and a withdrawn release. No essential finding may exist only inside WebGL, a hover tooltip, swipe or animation. Wireframes become accepted UI only after actual rendering/task/contrast tests.