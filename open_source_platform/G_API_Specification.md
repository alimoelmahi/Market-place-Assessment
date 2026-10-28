# G. API Specification

## 1. Contract and Versioning

[api/openapi.json](api/openapi.json) is the OpenAPI 3.0.3 implementation contract. Serve `/v1` through the same-origin gateway; frontend route fallback must not intercept API/tile errors. Generate TypeScript types and contract tests from the spec; implement FastAPI response models and domain validation rather than returning unvalidated database JSON.

After resolving current release once, every analytical request uses its explicit release UUID. Scenarios must belong to the release's approved model/eligible set. Missing or withdrawn releases return safe unavailable responses; unauthorized private identifiers must not disclose draft existence through different payload details.

## 2. Endpoint Families

| Family | Behavior |
|---|---|
| Health | Liveness is process status; readiness includes database and a valid approved application state without leaking internals. |
| Releases | List/get only authorized releases; current is resolved by server policy for the session/audience. |
| Markets/profiles | Stable market IDs, Arabic/English search, pagination, permitted filters and explicit null geometry. |
| Observations/sources | Released sanitized evidence with dates, support, D/R/M/A/U, nullable reliability and gaps. |
| Scenarios/layers/tiles | Approved scenario metadata and curated MVT descriptors; no arbitrary schema/function/object URLs. |
| Official scores | Server-published scores, bounds, coverage, need and gates; no query-string weight override. |
| Visualization data | V01-V10 reviewed tabular/flow aggregates with product-specific columns, unit, source references, availability and limitations. |
| Recommendations | Conditional response records with alternatives/prerequisites, not awards. |
| Experiments | Analyst-only asynchronous weight evaluation using released inputs; official snapshots immutable. |
| Jobs/results/exports | Creator-owned private jobs and scoped results; no subject supplied by browser. |
| Review/publish/withdraw | Separate reviewer/publisher permissions, audit and valid state transitions. |

## 3. Authentication and Mutation Security

Public GETs support anonymous access to cleared public releases only. OIDC/session authentication is described in B. Protected operations require a valid Secure HttpOnly session cookie, CSRF header validation for cookie-authenticated mutations, approved role and object-level scope. Idempotency keys prevent duplicated jobs/promotion attempts; the stored key is scoped to authenticated owner and operation.

The OpenAPI cookie declaration is a transport contract, not authorization implementation. RBAC checks, validated identity claims, database scope, proxy trust, CORS, SameSite/CSRF policy and session expiry need actual integration/security tests. Do not send tokens in tile URLs or persist them in localStorage.

## 4. Data Semantics

Every profile/score result identifies release/scenario/model and actual observation periods. Observations carry `value_num`/`value_text`, unit, nullable denominator, reliability 0-100 only when appraised, evidence type, confidence class, eligibility and missing reason. Bounds are typed by meaning; a range is not a statistical confidence interval by default.

Scores contain lower/upper, nullable point score, covered weight, complete/provisional/insufficient class, nullable analytical/investment ranks, need and independent gates. `point_score=null` never means zero and must remain null in CSV/export/visual components. A complete analytical score can exist while investment rank is null because a gate is unknown.

Small GeoJSON uses WGS84 and null geometry for unresolved location records. Tile endpoints use z/x/y and registered layers, not a path to any database table. Server validates tile coordinate bounds and layer/scenario association. Empty valid tiles and denied/unknown layers have distinct appropriate responses; denied data are not hidden in transparent rendering.

## 5. Experimental Weight and Sensitivity Behavior

An experiment request includes release, approved input scenario, selected market IDs and all six weights. Each weight is 0-1; sum must be 1 within 1e-6; all keys required, no extras; rate/payload/candidate limits enforced. UI can proportionally normalize inputs for preview but must show resulting weights and never silently accept an invalid vector.

The server validates input data and twenty-leaf eligibility, computes contributions/bounds under the requested weight vector, leaves gate/need/source confidence unchanged, and returns a fingerprint of canonical model/input/weight parameters. The response is always exploratory. Missing components are not reweighted away; complete-point rules remain explicit under the experimental model definition.

An asynchronous sensitivity job uses a predefined reviewed parameter set. Upstream population/network changes require actual coherent scenario outputs; a weight-only endpoint cannot simulate a bridge closure by subtracting points. Monte Carlo is allowed only with approved distributions/dependencies, bounded draws and a stored seed. Results are robustness frequencies, not probabilities of livelihood success.

Client preview must pass identical fixtures to the backend and is labeled provisional until server confirmation. A user cannot set a request field to `official`, `published`, `gate_pass` or another user's subject to gain authority.

## 6. Errors, Pagination and Limits

Use the Error schema with stable code, safe message and request ID. Define domain codes such as `RELEASE_UNAVAILABLE`, `SCENARIO_MISMATCH`, `INVALID_WEIGHTS`, `INSUFFICIENT_EVIDENCE`, `JOB_NOT_READY`, `ACCESS_DENIED` and `RATE_LIMITED`. 401 is expired/missing required session, 403 is permitted-resource/action denial where disclosure is acceptable, 404 hides unknown or unauthorized private objects, 409 is conflicting state/context, 422 invalid input, 429 bounded-rate rejection, and 503 dependency/unready service.

Cursor pagination is stable within a release and sort definition; changing query invalidates the cursor. Bound q length, IDs per experiment, bbox extent/geometry size, page size, tile zoom and asynchronous work. Parameterize SQL and escape/normalize names for search; never accept arbitrary ORDER BY or SQL fragments. Return `next_cursor=null` at the end, not a fabricated complete total when a service limit truncated the result.

## 7. Implementation and Tests

Repositories resolve snapshots and rights before query/serialization. Review routes use a separate authorized database pathway; public repositories never read raw analysis tables. Object storage uses approved IDs and prefixes, not arbitrary submitted URLs. Exports repeat scope checks at job completion/download, include version/evidence definitions and do not expose hidden fields or personal data.

Test OpenAPI validation, generated client compatibility, nullable values, unit/date serialization, cursor stability, Arabic search, cross-release scenario rejection, guessed private IDs, CSRF, expired sessions, role escalation, owner-job authorization, public cache separation, tile scope, idempotency, job failure and publication readiness. OpenAPI syntax validation is not proof of an implemented or secure server.