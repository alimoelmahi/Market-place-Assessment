# Khartoum Market Evidence MVP

Internal secondary-evidence workspace with locally persisted manual-location annotations. The source snapshot remains read-only. This is not an authoritative market assessment, a public release or a safety/engineering clearance system.

## Available Now

- Market explorer with search, geometry/locality filters, URL-linked selection, MapLibre/Deck.gl rendering, and an equivalent record list.
- All 14 original concept-note entries. Two actual sourced points and one sourced market polygon are mapped; the other 11 entries stay in the directory without invented locations. Twelve entries have no validated point, including the polygon-only record.
- Market profiles with Arabic names, transliterations, COD locality where established, confidence, original source links, edit dates and explicit operational/entrance/approval gaps.
- WFP monitoring market 2588 price charts and a table alternative: 1,127 actual source observations across 17 separate series, including a separately labelled unofficial exchange-rate series. Units and retail/wholesale distinctions are retained. Missing monthly observations are not joined in the chart.
- Evidence register with 42 indicator records, acquired-source URLs/checksums/dates, acquisition failures and the unresolved population-reference-year conflict.
- English-only interface, locally bundled Noto fonts, reduced-motion handling, keyboard-accessible record navigation and mobile map/list controls. Original Arabic market names are retained as source evidence, not translated interface text. Legacy `lang=ar` URLs still display English. No WCAG conformance certification is claimed.
- Recovery &amp; Resilience pillar dashboard shell inspired by the supplied overview reference: shared institutional-style masthead, horizontal section tabs, blue chapter band, overview KPIs and GIS/analytics/evidence sections. Project Tracker and Beneficiary Verification tabs are clearly marked unconnected because the reference dashboard's underlying datasets are not part of this workspace. The reference site's figures are not imported or merged with the market evidence snapshot.
- Manual coordinate entry and map placement for the 11 markets without retained source geometry. Entries require a source/reference and notes, are shown as amber unvalidated pins, and can be edited or removed. Sourced points and the sourced polygon cannot be replaced through this workflow.
- Goods-flow map and register with directed schematic links, commodity/market filters, source-referenced transfer entry, optional quantities, reporting periods, edit/remove controls and GeoJSON export. No transfer observations are prepopulated.
- CSV gazetteer export preserving blank coordinates and explicit boolean flags. Spreadsheet-formula-like text is escaped on export.

The initial indicator audit predates the gazetteer. The interface labels that snapshot explicitly rather than silently presenting its I01 status as the current identity result.

## Manual Locations

Select an unresolved market and choose **Add location**. Supply WGS84 latitude/longitude or choose **Pick on map**, then enter a source/reference and location notes. **Save location** persists the annotation; the draft pin is not saved until this command succeeds. The existing source-coordinate fields remain blank and source evidence counts do not change.

Saved annotations have `user_provided_unvalidated` status, a server timestamp and a revision. The source/reference field records the operator's statement; the application does not certify that source or turn a map click into independent location verification. A point must be covered by the acquired Khartoum State boundaries. This rejects swapped/out-of-area coordinates but does not establish a correct market identity, a precise entrance, survey accuracy, safety, operation or lawful permission. No locality is silently assigned to an unvalidated manual point.

Annotations are stored in `data/manual_locations.sqlite3`, independently of `data/evidence.json`, and survive server restarts and source-snapshot rebuilds. Edits and removal append revisions; removal hides the pin but retains its local history. Concurrent stale edits return a conflict rather than silently replacing a newer version. `KHM_MANUAL_LOCATION_DB` can point to another local database file. Back up this database separately if the annotations matter; no automated backup service is provided.

The gazetteer CSV export remains the original sourced inventory, not a merged authoritative dataset. Manual annotations are available separately from `GET /api/v1/manual-locations`. Inactive records represent removed annotations. Do not combine source and manual coordinates without retaining these statuses.

## Run Locally

Requirements: Node.js compatible with Vite 7 (20.19+ or 22.12+), npm, Python 3.12+, and the existing sibling evidence directory. Run from this `mvp` directory.

```powershell
npm ci
python -m pip install -r backend/requirements.txt
npm run data:build
```

Start the API in one terminal:

```powershell
python -m uvicorn backend.app:app --host 127.0.0.1 --port 8000
```

Start the frontend in another terminal:

```powershell
npm run dev
```

Open **http://127.0.0.1:5173/**. The frontend proxies same-origin `/api` requests to the local API. Ports are strict: if either is occupied, choose a free port and change the matching proxy target in the Vite config. Do not terminate an unrelated existing server.

The already-running local development instance uses the terminal Python 3.12 interpreter whose FastAPI, Uvicorn and HTTPX imports were verified. This is not a claim about a different editor-selected interpreter. A dedicated virtual environment is recommended for a separate installation. The tested JavaScript dependency resolution is recorded in the npm lockfile.

For a single-process built local preview:

```powershell
npm run build
python -m uvicorn backend.app:app --host 127.0.0.1 --port 8000
```

Then open http://127.0.0.1:8000/. The API mounts only the built assets, not the workspace or original evidence directories. Restart the API after replacing its loaded snapshot or after creating a production build whose assets were not present at startup.

## Evidence Ingestion

`scripts/build-evidence.mjs` reads the existing gazetteer, source geometry, administrative boundaries, price outputs, indicator audit and acquisition manifest. It verifies acquired input SHA-256 values and lengths, checks market completeness and flags, and produces `data/evidence.json`. The generated file is not tracked by the local ignore rules; regenerate it from the real evidence inputs.

The snapshot records hashes for its actual inputs. No generated observation fixtures, geocoded town centres, synthetic trader counts, assumed operating status, population redistribution or market rankings are introduced. A fresh snapshot build is not a fresh source observation or automatic refresh from external providers.

WFP prices remain monitoring-location context with `selected_market_match=not_established`; no series is assigned to a selected KHM market. Acquired-source files are not independent datasets, and download completion is not analysis readiness. Nominatim and OSM object API records share OSM lineage. OSM edit dates are not site-observation dates. Source point precision is not survey accuracy.

The optional OSM raster basemap makes external tile requests with normal browser caching and attribution. No bulk download, offline prefetch or tile scraping is implemented. Basemap availability is not required for local source geometry or the record list. Public OSM tiles are a small local-development choice, not a production hosting commitment; use an approved/self-hosted basemap under the applicable usage policy for deployment. Turning off the basemap stops its display, but does not erase requests already made. Do not place sensitive locations on an external basemap without review.

## API

## Goods Flows

Open the **Goods flows** tab and use **Record transfer** for an existing, source-supported observation. Each record requires distinct inventory origin/destination markets, commodity, reporting period, source/reference and evidence notes. Mode can be not reported; quantity is optional, but a quantity and its unit must be supplied together. Future reporting periods and unknown inventory endpoint IDs are rejected.

All portal transfer records are **user-reported, unvalidated**, including records with a source citation. The application does not independently confirm the cited claim or assume that a historic flow continues today. Records are stored with revision history in the same local SQLite database as manual annotations; deletion hides a record while retaining history. Empty transfer storage reflects the current evidence gap, not an absence of actual trade. No quantities, frequencies, routes or links have been fabricated to populate this feature.

The map uses actual sourced market points or active manual points, retaining their different location statuses. A polygon alone is not converted into a point. Both endpoint points must be present before a link is drawn; otherwise the transfer remains available in the register with `missing_endpoint_point` status. Location changes/removals are resolved on the next transfer-data fetch. No township centroid, new market coordinate or road routing is inferred.

Straight lines and arrowheads show **schematic origin-to-destination direction**, not truck trajectories, accessible corridors, current passability or verified delivery routes. Direction glyph positions are display-only interpolations between existing endpoints, not market locations. Line width is fixed and is not proportional to quantities. Quantities with different units or reporting periods are not aggregated. The recorded mode is not used to invent a travelled path.

Market and commodity filters apply to the map and transfer register. Selecting a line or register record exposes its reporting dates, source, notes, quantity and endpoint confidence statuses. GeoJSON export includes filtered records and their statuses; records with missing endpoint points have null geometry. It is not a verified transport-route dataset.

The current snapshot has no acquired market-to-market transfer dataset. Until actual records are entered, the flow view shows market locations and an explicit empty transfer state. Existing WFP commodity-price observations do not establish where goods moved and are not converted into trade links.

## API Routes

| Route | Purpose |
| --- | --- |
| `GET /api/v1/health` | Local service status and file-snapshot persistence declaration; not analytical readiness |
| `GET /api/v1/snapshot` | Read-only internal evidence snapshot |
| `GET /api/v1/markets/{market_id}` | Actual inventory record and retained source geometry, if any |
| `GET /api/v1/export/markets.csv` | UTF-8 gazetteer export with preserved missingness |
| `GET /api/v1/manual-locations` | Latest revision per market, including inactive removal records |
| `PUT /api/v1/markets/{market_id}/manual-location` | Save an unresolved-market annotation with source/reference, notes and expected revision |
| `DELETE /api/v1/markets/{market_id}/manual-location` | Remove the active manual pin while retaining history |
| `GET /api/v1/goods-flows` | Latest transfer revisions, with actual endpoint coordinates or missing-point statuses |
| `POST /api/v1/goods-flows` | Record a source-referenced, user-reported transfer |
| `PUT /api/v1/goods-flows/{flow_id}` | Revise a transfer with optimistic revision checking |
| `DELETE /api/v1/goods-flows/{flow_id}` | Remove a transfer while retaining history |

Manual writes require the portal's custom request header and reject unapproved browser origins. These are local request-forgery controls, not user authentication or institutional authorization. The source snapshot, scoring and ranking remain non-writable. There is no source-file browsing, raw-document download or arbitrary URL-fetch endpoint. Host validation and no-store API responses are implemented. Original confidential PDFs/DOCX, raw reports and the SQLite database are not exposed through a static workspace mount.

## Verification

```powershell
npm test
python -m unittest discover -s backend -v
npm run test:e2e
npm run build
```

The browser tests require both local servers running. They use the actual snapshot, not mocked evidence, and launch installed Microsoft Edge through Playwright at 1440x900 and 390x844. If Edge is absent, install a supported Playwright browser and change the `channel` setting; no browser executable is bundled.

Verification includes four real-data integrity tests, eleven backend tests, four browser workflow tests and TypeScript compilation. Backend location-persistence tests use an actual acquired same-name candidate in an isolated temporary database, explicitly as an unvalidated candidate, then remove it; they do not add a location to the live inventory. Goods-flow tests cover empty storage, incomplete input rejection and write guards; no fictional transfer is inserted for testing. Browser checks cover English navigation, market/source/price views, mobile reflow, manual drafts, goods-flow empty state and blank transfer form. No browser test saves a location or transfer into the live store. The successful persistence and rendering of a real transfer remains unexercised because no eligible real transfer has been supplied. Screenshots are saved under `test-results/`. These are not full accessibility, security, independent positional or production performance certifications.

## Deliberate MVP Boundaries

- Source persistence is a **checksum-verified file snapshot**; manual annotations use local SQLite. Neither is PostgreSQL/PostGIS. The larger database/API specifications remain a deployment target, not implemented infrastructure.
- No SSO, multi-user roles, reviewer approval workflow, authenticated user audit log, durable job worker, Docker deployment, TLS gateway, automated backups or Azure deployment is implemented. Manual annotation revision history does not identify an authenticated author or certify a review.
- The blue UNDP logo SVG bundled under `public/undp-logo-blue.svg` was taken from the user-provided dashboard reference at `https://undp-sudan-rr-overview.netlify.app/undp-logo-blue.svg`. Its presence is for this local prototype and is not evidence of trademark/communications approval for external or production use. Confirm the current official asset and brand permission before a shared deployment.
- Source-derived damage/accessibility analysis and decision-support rankings can be added when inputs and declared methods support them. This version does not fabricate those outputs, claim markets are operating/safe, or infer actual customers from residents.
- The selected market scope still contains unresolved identities and the missing fifteenth entry. All entrances, routing eligibility and authoritative approval remain unverified/false.

**Do not bind this MVP to `0.0.0.0`, expose it through a public tunnel or publish it as-is.** Loopback binding is an operating constraint, not user authentication. The local user can view and export internal market names and evidence metadata. Before any shared deployment, review confidentiality/rights, approve cleared snapshots, add institutional authentication/authorization, harden the gateway and storage, and implement deployment/backup controls.