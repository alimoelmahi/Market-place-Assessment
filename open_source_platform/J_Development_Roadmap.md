# J. Development Roadmap and Acceptance

## 1. Delivery Approach

Implement vertical slices of real released evidence, not a polished frontend full of invented values. Indicative 12-16 weeks assumes an available multidisciplinary team and timely organizational/data/rights decisions; it is not a fixed delivery promise or budget. A secondary-evidence gap release is preferable to unsupported complete-looking findings.

| Phase | Indicative period | Deliverables and exit gate |
|---|---|---|
| R01 Governance and spike | Weeks 1-2 | Confirm cohort/aliases, brand tokens/font/logo rights, hosting/identity/data-residency, source licences, accessibility plan; spike MapLibre/deck compatibility and actual PostGIS roles. |
| R02 Contracts and foundations | Weeks 2-4 | Apply reviewed migrations in isolated environment; FastAPI models/auth; OpenAPI-generated clients; design primitives; release-aware vertical directory/profile with null geometry/evidence. |
| R03 Evidence/GIS pipeline | Weeks 3-7 | Acquire permitted assets; topology/connectors, population conservation, suitable imagery/price/service evidence, risk summaries; independent interpretation and source-rights QA. |
| R04 Explorer and risk | Weeks 5-9 | Real map/list/search/profiles; V02-V05/V07; approved tile/raster/GeoJSON delivery; responsive/Arabic/keyboard testing. |
| R05 Prioritisation and options | Weeks 8-11 | Authoritative twenty-leaf engine and fixtures; official comparison, private weight sandbox/jobs, coherent sensitivity, need/gates and conditional recommendations. |
| R06 Digital report | Weeks 9-12 | Seven narrative chapters, reviewed charts/media/links, V01/V06/V08-V10 only where eligible; static/table fallbacks and editorial clearance. |
| R07 Hardening and UAT | Weeks 12-14 | Security/RLS/CSRF/object access, release/cache/export tests, performance, WCAG manual/automated audit, backup/restore and withdrawal drill. |
| R08 Institutional deployment | Weeks 14-16 | Approved Docker/hosting deployment, staging-to-production release, role-based training, runbooks, support/refresh ownership and signed acceptance. |

Parallel work is possible only when contracts are stable; GIS/data readiness controls whether result views can launch. Defer ineligible Sankey/radar/treemap rather than manufacture the missing measurements.

## 2. Engineering Backlog by Slice

| Epic | First runnable slice | Completion evidence |
|---|---|---|
| Release/security | One public snapshot and one internal snapshot with no raw data access. | Anonymous/private negative tests, row-policy tests with nonowner roles and connection-pool reset. |
| Identity/explorer | Real approved market directory plus unresolved entries. | Arabic alias search, stable pagination/map-list IDs, no null-to-0/0 geometry. |
| Access/population | One reviewed scenario with full origin accounting. | Conservation, unique union/allocation, valid connector costs and unrestricted reachability tests. |
| Function/risk | One evidence-supported profile and generalized risk dataset. | Dates/units/coverage correct; no-records not safe and nodata not dry. |
| MCDA | Complete and missing-leaf fixtures, then eligible real snapshot inputs. | X=65/Y=67.5; missing R 59-74; confidence separate; gate unknown prevents investment-ready status. |
| Experiment/jobs | Owner-scoped weight-only experiment on a release. | Invalid weights blocked; official result hash unchanged; retry/idempotency and unauthorized job tests. |
| Report/options | One chapter with real figure and evidence trail. | Readable without interaction, correct sources/rights and conditional claims. |
| Deployment | One reproducible staging release and rollback. | Data/assets/app version consistency, approved audience access and tested restore. |

## 3. CI and Quality Gates

- TypeScript lint/typecheck, unit/component tests and generated-client contract checks.
- FastAPI domain tests, OpenAPI response validation, migrations applied to a disposable real PostGIS instance and least-privilege/RLS tests.
- Shared backend/client scoring fixtures and monotonic/threshold/bound tests; no point rank from incomplete required leaves or gate bypass.
- GIS tests for true crossings, directed restrictions, connector accounting, origin status closure, population mass and hazard masks.
- Browser E2E for all 18 route states, Arabic/English, keyboard, 200% zoom, mobile, reduced motion, no-data/failure/withdrawn and permissions.
- Accessibility automation plus manual screen-reader/focus/contrast/reflow audit against WCAG 2.1 AA; document remaining failures rather than assert compliance.
- Tile/raster/PMTiles range tests, private cache isolation, export rights recheck, SSRF/input validation and no token/personal-data telemetry.
- Dependency/SBOM/licence/container scanning, pinned lockfiles and reproducible images.

Proposed performance budgets come from A/B: measure reference network/device/cache/concurrency; avoid fake server benchmarks. Test meaningful map/list and filter tasks, not just HTTP liveness. Tune indexes, summaries, geometry simplification, object range/caching and bundle/code splitting without changing analytical definitions.

## 4. Release, Refresh and Rollback

Deploy in a private staging environment with approved data and actual identity integration. Acquire/recompute/review/build immutable snapshot plus objects, verify readiness, then atomically switch the database current-release pointer. Static/tile objects are versioned; the transaction does not make object/CDN changes atomic. Test complete dependency visibility before promotion.

Public outputs require explicit rights/privacy/brand/editorial approval. Internal authorization is not enough to share confidential concept/benchmark details or provider event data. No production deployment is authorized by this specification alone.

Observe provider/source cadence and material-change triggers; run idempotent jobs with leases/retry limits. Keep actual source-age versus publication/last-success timestamps. Failed refresh retains the last valid release with explicit age/gap state or withdraws unsafe/rights-invalid content. Never publish mixed graph/population/score versions.

Back up database/PITR where supported, object assets/manifests, migrations/config/model, map styles/fonts/glyphs/media rights, identity/gateway configuration and app image versions. Practice restoring a coherent release and access rules; data exports alone are not a complete platform backup. Assign institutional owner, backup, on-call/escalation and cost budget before go-live.

## 5. Open Decisions and Procurement Boundaries

Resolve exact UNDP brand tokens/font/logo permissions; permitted public cohort; actual identity upstream and role mapping; hosting/data residency; data/imagery/ACLED/GSMA rights; whether suitable current-resident and availability records exist; graph/MCDA anchor approval; optional raster/object storage choice; and real workload/recovery objectives.

Docker tooling does not make every distribution/licence free in every organizational setting. Review engine/runtime, container images, data, fonts, map styles and object/identity services as a bill of materials. Managed Azure components are optional hosting choices, not required proprietary application logic. No paid map/chart service is a runtime dependency in the baseline.

## 6. Definition of Done

The actual approved release implements the required routes and contracts, uses only supported evidence or explicit gaps, preserves official/sandbox separation, passes numerical and access tests, meets agreed accessibility/performance, retains all required rights and independent conditions, survives a restore/withdrawal drill, and is accepted by the responsible program/platform roles.

Specification completion is not implementation completion. No frontend build, API server, database migration execution, identity service, acquired analytical result or production deployment is claimed by this package.