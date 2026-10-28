# A. Product Requirements Document

## 1. Product Definition

**Product:** Khartoum Markets Intelligence Platform.

**Purpose:** Turn secondary evidence and reproducible geospatial analysis into a donor-facing digital assessment and an authenticated recovery-planning workspace. The public experience combines a narrative report with usable exploration; the internal workspace exposes approved evidence, uncertainty, scenarios and conditional investment preparation.

**Decision supported:** Which documented constraints and market-system connections justify further recovery preparation, which populations may have physical access under stated assumptions, and which actions remain conditional on evidence or safeguards?

**Not supported:** Safe-route guidance, structural approval, explosive clearance, trader-grant eligibility, representative participation/preference estimates, automatic funding awards, and causal jobs/income claims.

## 2. Audience and Personas

| Persona | Need | Primary journey | Success criterion |
|---|---|---|---|
| UNDP management | A concise accountable recovery picture and decision limits. | Overview -> narrative -> comparison -> recommendations. | Can distinguish supported findings, readiness and unresolved conditions in minutes. |
| Government planning stakeholder | Locality/site dependencies and preparation requirements. | Explorer -> profile -> access/risk -> option prerequisites. | Finds the correct documented site and next action without treating an urban label as verified administration. |
| Donor/partner reader | Evidence, rationale, uncertainty and responsible use of funds. | Digital report -> supporting chart -> sources -> conditional opportunities. | Can trace a recommendation and understand what is not verified. |
| Recovery/GIS analyst | Reproducible scenarios and evidence quality. | Authenticated explorer -> raw-to-score view -> exploratory model -> export permitted results. | Can reproduce model behavior without changing the official release. |
| Data steward/reviewer | Controlled source intake and release assurance. | Restricted review -> QA -> approval -> published snapshot. | No unreviewed source, geometry or sensitive field is promoted. |

No persona is assumed to have authority to disclose a provider's restricted data or approve a safety/tenure gate. Actual authorization belongs to organizational roles.

## 3. User Journeys

**J01: Understand the assessment.** Open Overview; see the literal study name, observation/release dates and an inspectable map/image; read supported findings or evidence-gap statements; continue into the seven-part report. No sign-in is required for cleared public content.

**J02: Find a market.** Search Arabic/English aliases; filter locality/type/evidence/operation; inspect map and equivalent list; open a stable profile link. Unresolved location records appear in the directory with no invented pin or catchment.

**J03: Compare access.** Select an approved population/network/mode scenario; inspect potential reachable residents, disconnection and time bands; open the definition/source. The selection preserves a coherent release across charts and map.

**J04: Assess a recovery option.** Move from profile deficit to risk and gate status, then to a conditional option including no-build/service alternatives, maintenance and prerequisites. A high score is not a works approval.

**J05: Explore weights.** Authorized analyst starts from an approved snapshot; changes weights in a visibly marked sandbox; receives bounds/eligibility and sensitivity, not invented missing scores; optionally saves a private experiment. Published base values remain unchanged.

**J06: Publish a reviewed update.** Steward registers permitted existing data; a worker builds immutable outputs; independent reviewers examine QA and rights; a separate authorized publisher promotes the release; prior version remains recoverable.

## 4. Information Architecture and Routes

| Route | Page | Main content |
|---|---|---|
| `/` | Overview | Compact real-place hero, scope/date/evidence statement, supported summary metrics, overview map, findings and report entry. |
| `/markets` | Market Explorer | Map/list, search, filters, result counts, unresolved entries and compare selection. |
| `/markets/:marketId` | Market Profile | Overview, access, potential residents, role/supply, condition/services, risks, evidence, opportunities and gates. |
| `/risk/conflict` | Conflict Intelligence | Recorded exposure, precision exclusions, windows and documentary disruption. |
| `/risk/flood` | Flood Intelligence | Separate river-hazard and observed-event views, asset/access/population exposure and coverage. |
| `/risk/infrastructure` | Infrastructure Vulnerability | Visible condition, observable denominator, service dependencies and uncertainty. |
| `/priorities` | Prioritisation | Official comparison, need/readiness portfolio, bounds, gates, stability and analyst weight sandbox. |
| `/recommendations` | Recovery Recommendations | Conditional options, enabling work, phased pathways, no-build alternatives, responsibility and evidence gaps. |
| `/report/:chapter` | Digital Assessment | Context; market systems; accessibility; functionality; vulnerability; prioritisation; recommendations. |
| `/evidence` | Evidence and Methods | Cleared sources/indicators/definitions, license status, observations and methodology/downloads. |
| `/review` | Restricted Review | Authorized release/source/QA review; not a new field-survey form. |
| `/sign-in` | Authentication handoff | Institution-approved OIDC flow, not a custom password database. |

Use a persistent compact header with Overview, Markets, Risk, Priorities, Recommendations and Report; Evidence/Methods and language/accessibility controls remain discoverable. Risk uses tabs within its three-page family. Mobile uses a keyboard-accessible drawer and map/list segmented control. Avoid hiding core interpretation in hover-only tooltips.

## 5. Functional Requirements

| ID | Requirement | Priority and acceptance |
|---|---|---|
| FR01 | Display only approved audience-safe release snapshots. | Must: no draft/private source through public endpoints or tiles. |
| FR02 | Search Arabic/English names and aliases; filter using supported fields. | Must: query state is URL-shareable and null geography is explicit. |
| FR03 | Map/list selection is synchronized by stable market ID. | Must: keyboard/list access provides the same profile information as the map. |
| FR04 | Profile separates operation, visible condition, services, prices and evidence. | Must: source dates/coverage accompany every numerical claim. |
| FR05 | Switch precomputed access/population/risk scenarios coherently. | Must: charts and geometry cannot silently combine releases/scenarios. |
| FR06 | Show recorded conflict and flood layers with precision/nodata limits. | Must: zero records and missing coverage never mean safe/dry. |
| FR07 | Produce official six-criterion scores/bounds and eligibility. | Must: incomplete inputs have no midpoint/renormalized point rank. |
| FR08 | Offer exploratory normalized weight adjustment and sensitivity. | Must: separate scope/version label; no official mutation. |
| FR09 | Connect evidenced deficits to conditional investment/service options. | Must: proposed versus approved versus completed states distinct. |
| FR10 | Provide seven report chapters with linked map/chart states. | Must: native page reading works without required map interaction. |
| FR11 | Export approved scoped tables/figures and evidence metadata. | Should: export includes release/model/scenario/rights and excludes secrets/raw restricted data. |
| FR12 | Review/publish/withdraw releases with audit and rollback. | Must: reviewer and publisher permissions separated; publication is explicit. |
| FR13 | English/Arabic UI and approved bilingual place names. | Must before bilingual launch: professional translation and RTL QA. |
| FR14 | All ten visualization families have evidence-based fallbacks. | Must: Sankey/radar/treemap cannot fabricate missing volume/axes/additive area. |

## 6. Landing Page and Module Requirements

The requested landing page is a **usable assessment overview**, not a marketing detour. Its first viewport shows Khartoum State Markets as the subject, scope and dates, a real cleared image or inspectable map, and direct access to Explorer/report. The next section remains partially visible across common viewports. No statistic is populated from a fictional fixture or a confidential source that has not been cleared.

Summary statistics are distinct confirmed market identities, supported operating-status coverage, eligible modeled reach, and rank/evidence completeness only if the underlying release supports them. Otherwise use a factual gap label such as "Current operating status not established"; never put 0 in a missing KPI.

Risk dashboards and profiles reuse the same released analytical objects. Recommendations are grounded in the same versioned evidence. The analyst sandbox can explore a policy preference but cannot clear a gate, fill unknown data, overwrite default weights or publish its result as official.

## 7. Data and Analytical Requirements

The current source register has 14 populated market entries with an unresolved possible merged livestock/camel line. No fictitious fifteenth entry or verified coordinates are assumed. The concept note footer and benchmark classification require owner clearance before public reuse; the internal provisional registry is not automatically a public dataset.

All 42 existing indicators receive an ingestion/format/frequency/reliability/processing contract. Runtime observations carry measured quality scores only after appraisal; numeric quality is null when not assessed. The product distinguishes documented D, remotely observed R, modelled M, assumption A and unknown U evidence. Scenario bounds are not statistical confidence intervals.

Open-source technologies do not make ACLED, GSMA, commercial imagery or institutional records open data. The default public build uses only cleared reusable sources/derivatives. A legally permitted internal layer can be retained separately; unavailable inputs produce explicit gaps, not fake equivalence or zeros.

## 8. Nonfunctional Requirements

| Area | Requirement and proposed acceptance |
|---|---|
| Accessibility | WCAG 2.1 AA acceptance for actual pages/tasks; keyboard alternatives, text/table equivalents, noncolor cues, contrast and focus. No claim of conformance before audit. |
| Performance | Initial useful overview target <=5 s and explorer useful map/list <=8 s on a defined reference network; p95 common cached query target <=500 ms API and <=3 s full UI interaction. Measure under agreed load, not vendor guarantees. |
| Mobile | Readable 360 px viewport; map/list alternatives; large controls; no text/legend overlap; reduced motion. |
| Security | Least privilege, OIDC, server-side scope checks, private data isolation, nonpublic cache separation, input validation, audit and tested negative access. |
| Reproducibility | Immutable input/output manifests and released model/scenario versions; no production dependence on analyst-local paths. |
| Reliability | Last approved release retained on failed refresh; unsafe/rights-invalid content withdrawn; health includes actual release readiness. |
| Portability | Docker images and standard PostgreSQL/PostGIS/HTTP/object-store contracts; no ArcGIS runtime or proprietary map-token requirement. |
| Operations | Named institutional owner/backup, budget, restore drill and monitoring. Hosting approval/data residency remain organizational gates. |

## 9. Success Measures and Release Gates

Measure task completion, traceability of sampled findings, access-control failures, broken/slow interactions, freshness clarity and repeatability of approved calculations. Do not define product success as more markets declared open, more high scores, or invented beneficiaries.

MVP release requires: valid public or restricted dataset scope; resolved geometry or honest nonspatial entries; complete source/rights traceability; tested API/database permissions; all mandatory null/gate/MCDA tests; accessible primary tasks; measured performance; approved narrative/media; institutional go-live and rollback owners. An evidence-gap MVP is acceptable if accurately labeled. A visually complete fabricated assessment is not.

Out of MVP: new field collection, live safe-route navigation, live business transactions, automatic grant/funding decisions, real-time satellite inference, fully calibrated consumer-choice models and automatic structural/safety certification. Add microservices or custom AI only for a demonstrated need and separate approval.