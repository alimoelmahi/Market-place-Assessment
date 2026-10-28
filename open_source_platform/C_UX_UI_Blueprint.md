# C. UX/UI Blueprint and Storytelling Framework

## 1. Brand and Visual Direction

Create a restrained, editorial geospatial assessment with a useful operational workspace. Preserve UNDP institutional recognition and the benchmark's geographic progression and repeated site profiles, while improving evidence visibility, accessibility, mobile reading and scenario comparison.

The official public [design system](https://design.undp.org/) and [repository](https://github.com/undp/design-system) were reviewed; the repository states an MIT code licence and reusable component/token tooling. Do not assume the code licence grants logo/trademark or embedded font redistribution rights. Obtain the actual current foundation tokens and communications approval before branded release.

The following is a **proposed implementation token mapping**. Reconcile brand-specific values with the approved current token export, not a screenshot or this document's existence. It is not a claim of completed brand certification.

| Semantic token | Proposed value | Use |
|---|---|---|
| `brand.primary` | `#006EB5` | UNDP-blue candidate mapping, institutional focus and primary actions. |
| `text.primary` | `#20262C` | Main text. |
| `text.secondary` | `#4B5563` | Qualified labels and metadata on light backgrounds. |
| `surface.base` | `#FFFFFF` | Main canvas. |
| `surface.muted` | `#F4F5F6` | Toolbars and grouped data background, not floating sections. |
| `border.default` | `#D0D5DA` | Dividers and control boundaries, with stronger focus boundaries where required. |
| `recovery` | `#007A5E` | Supported operation/recovery signal, never safe-route certification. |
| `risk` | `#A62639` | Recorded exposure/important constraint, with text/symbol meaning. |
| `opportunity` | `#6A4C93` | Sparing categorical option/selection accent, not dominant purple theme. |
| `caution` | `#8A5A00` | Conditional/stale state. |
| `focus` | `#003A70` | Strong focus outline independent of data palette. |
| `unknown` | `#666666` | Explicit unknown text/pattern, not a zero result. |

Open-source font baseline: locally hosted Noto Sans and Noto Sans Arabic with their actual distribution licences. If an official institutional font is required, use it only after verifying availability and redistribution rights; record the approved substitution. Do not claim that a fallback font is identical to an official typeface.

Type tokens: metadata 12-14 px, UI/body 16 px, narrative body 18 px, compact panel heading 20-24 px, page heading 32 px and overview display heading 40 px. Use fixed readable tokens, line-height 1.4-1.6 and letter spacing 0; no viewport-scaled text or negative tracking. Ensure zoom to 200% and reflow do not hide controls.

## 2. Layout System

Use an 8 px spacing base with 4 px fine increments. Main narrative width approximately 680-760 px within full-width map/section bands; operational pages use a 12-column desktop grid and a stacked mobile layout. Cards have 4-6 px radii and are limited to repeated market/option items or genuinely framed tools. Do not place cards inside cards or style every page section as a floating panel.

Explorer desktop: compact filter rail, unframed map occupying the main workspace and a controlled list/profile column. Mobile: map/list segmented control with an accessible filter drawer; essential controls do not sit underneath map attribution. Maps, charts, toolbars and icon buttons have stable constrained dimensions so dynamic labels cannot shift layout.

The requested overview hero uses a real cleared market image or inspectable map background, with title and short evidence/date statement outside a decorative card. Keep enough height available to reveal the next section on common mobile and wide desktop viewports. No generic gradient/orb backdrop or invented documentary picture.

## 3. Component and Interaction Principles

Use conventional controls: lucide-react icons with accessible names and tooltips for tools; segmented controls for mode; checkboxes/toggles for binary choices; sliders plus numeric inputs for weights; selects/menus for option sets; tabs for profile/risk views. Text buttons are commands such as Reset official weights or Export permitted table, not a substitute for every tool icon.

Market result cards show approved name, locality or unresolved label, documented role/status period, evidence coverage and a clear profile link. Do not fill the card with six incomparable headline counts or use a green badge for missing events. Selection works through keyboard/list as well as map picking.

Charts expose a concise finding, definition and data-table alternative. Pointer hover is additive, not required. Framer Motion is limited to meaningful panel/chapter transitions; disable nonessential movement for `prefers-reduced-motion`, avoid perpetual animated trade flows, and do not move focus unexpectedly.

## 4. WCAG 2.1 AA Implementation

- Semantic landmarks, skip link, logical heading order and actual buttons/links.
- Visible focus, keyboard-operable drawers/tabs/map alternatives, Escape close and focus restoration.
- Text contrast at least 4.5:1 for normal text and 3:1 for qualifying large text; meaningful UI/graphical boundaries at least 3:1 as applicable. Test actual combinations, not just tokens.
- No information conveyed only by color, location, drag, animation, hover or map canvas.
- Scenarios and filters announce results through a polite status region without repeating the whole page.
- SVG charts have accessible names/descriptions and a tested table alternative; canvas/WebGL has a corresponding structured list/table.
- Date/number formatting follows language and clearly distinguishes units; Arabic uses approved translations, `dir=rtl` and isolated IDs/numbers where necessary.
- Touch controls target about 44 px as a design goal; WCAG 2.1 AA conformance is assessed against its actual criteria, not claimed solely from this target.
- Error summaries identify fields and remedies; loading, no-data, not-assessed, denied, stale and failed states differ.

Accessibility needs automated and manual keyboard/screen-reader/reflow testing. This design does not itself certify conformance.

## 5. Seven-Part Digital Report

Each chapter has actual reader copy below, followed by its intended visuals and released data products. Copy is original framing, not fabricated assessment findings. Insert actual numerical conclusions only after review; never publish production placeholders as results.

### Context

**Narrative:** Khartoum's markets depend on more than trading space. The conditions surrounding exchange include where people live, whether services function, whether suppliers can replenish goods, and whether households can afford them. Conflict-related disruption and movement can change these conditions unevenly. This assessment uses dated existing evidence and explicit models rather than a new survey. National trends provide context; site-level claims require evidence that actually describes the market and period concerned.

**Visuals/maps:** locator, adopted locality view, compatible population/movement panels and an observation timeline. **Charts:** source dates, population scenarios and applicable price context. **Data products:** cleared registry, source metadata, compatible population totals and context claims. **Message:** movement or return is not proof of recovered purchasing power or safe reintegration.

### Market Systems

**Narrative:** A neighborhood market, an aggregation point and a specialized trading node perform different functions. Their usefulness rests on connections between producers, transport, storage, services and consumers. Reported commodity links are therefore shown separately from routes calculated through a road network. A modelled path demonstrates a conditional physical connection, not measured current trade or the volume passing through it. Rehabilitation options should address the actual bottleneck, including constraints beyond the market boundary.

**Visuals/maps:** role map, documented network, modelled alternative and supporting-service view. **Charts:** role matrix, flow schematic and eligible Sankey only with compatible quantities. **Data products:** dated trade links, nodes, source evidence and graph scenarios. **Message:** more roads do not necessarily mean more independent suppliers.

### Accessibility

**Narrative:** A market that looks close may remain difficult to reach because of a river, crossing dependency, disconnected road or unsuitable entrance. The model estimates physical travel under named assumptions, including the connection from a population origin to the road and from the road to the market. Potential reachable residents are a planning estimate, not customers observed buying goods. Individual catchments can overlap; unique summaries count people once within the defined candidate set.

**Visuals/maps:** time reach, allocation, reference/disruption comparison. **Charts:** resident ranges, mutually exclusive time bands and valid detour/disconnection comparisons. **Data products:** conserved population origins, total-cost OD, unique allocations and eligible market sets. **Message:** modelled reach does not establish safety, affordability or equal social access.

### Market Functionality

**Narrative:** Buildings and trading are different observations. A shelter may stand while services, supplies or working capital constrain its use. Each profile distinguishes documented operating status, observable physical condition, monitored goods and supporting services. The amount of evidence matters: a damage fraction needs its observable baseline, and availability needs its basket coverage. Where sources do not establish current conditions, an unknown result is more responsible than a complete-looking score.

**Visuals/maps:** repeatable market profiles and qualified imagery comparisons. **Charts:** component/service matrices, comparable price series and recovery sequence. **Data products:** status observations, imagery interpretations, availability panels and documented finance/service evidence. **Message:** visible intactness is not structural safety or a working business ecosystem.

### Vulnerability

**Narrative:** Recovery can be interrupted through assets, access, utilities or supply connections. Recorded events help describe exposure but do not establish the absence of violence when records are missing. Modelled river flooding and observed inundation answer different questions, and neither captures every urban drainage problem. Environmental and protection constraints should shape preparation and design. Some requirements remain independent conditions that a favorable analytical score cannot replace.

**Visuals/maps:** generalized recorded exposure, separate hazard/event flood panels and relevant heat/water context. **Charts:** exposure with unknown coverage and gate status. **Data products:** precision-reviewed event summaries, hazard masks/overlays and qualified existing records. **Message:** unknown is not safe, dry or cleared.

### Prioritisation

**Narrative:** The comparison combines potential reach, access, functionality, lower recorded conflict exposure, economic-system role and rehabilitation feasibility. Its weights describe a declared decision preference, not humanitarian worth. Missing components widen uncertainty instead of becoming guessed observations. Analysts can examine alternative weights in a separate sandbox, while the approved model remains intact. High-need markets with unresolved conditions remain visible for enabling work rather than disappearing below a ranking.

**Visuals/maps:** opportunity/preparation map and need-readiness portfolio. **Charts:** contributions, intervals, scenario stability and sandbox sensitivity. **Data products:** model version, twenty-leaf components, bounds, eligibility and independent gates. **Message:** analytical rank does not authorize funding or works.

### Recommendations

**Narrative:** A useful recommendation links an evidenced problem to a response and a realistic preparation pathway. Some constraints may call for services, access arrangements, finance or maintenance before new structures. Other options require qualified technical work, lawful permission and environmental or protection conditions. The assessment identifies those dependencies rather than promising that construction alone restores income. Decisions remain dated and revisable as evidence and operating conditions change.

**Visuals/maps:** conditional package map and verified existing/proposed dependency plan. **Charts:** constraint-response matrix, phased prerequisites and responsibility/gap register. **Data products:** approved option records, no-build alternatives, O&M/permission evidence and review triggers. **Message:** identify the appropriate next action, not an unsupported success story.

## 6. Universal States and Narrative-to-Explorer Handoff

Every route supports loading, valid data, legitimate zero, no observations, ineligible/unknown, stale, denied, missing ID, service failure and withdrawn release. These are separate render states, not one "no data" message. Profiles for unresolved locations can still show permitted documentary text but no pin, travel surface or fabricated score.

Narrative scene state is a controlled descriptor such as chapter, released layer IDs, camera bounds, chart ID and scenario. An Explore this evidence link carries only allowlisted stable IDs into the explorer. Scrolling may change the map state but never the official model or reader's auth. On mobile/reduced motion, use static figures and explicit chapter progression rather than mandatory scroll-linked animation.