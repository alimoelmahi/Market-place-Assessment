# Khartoum Markets Intelligence Platform

**Evidence-only update, 27 October 2026:** [the real-evidence protocol](../evidence_based_assessment/README.md) supersedes conflicting historical examples and assumptions in these design documents. Do not implement invented inputs, demonstration observations, assumed travel values or uncalibrated ranks as assessment findings. The earlier generated calculation fixtures are withdrawn and real-market ranking remains disabled.

Open-source implementation specification | 27 October 2026

This package replaces ArcGIS as the proposed application runtime. It is a product and engineering handover, not a deployed application or a completed assessment. Existing assessment documents remain unchanged. No current market coordinates, field-survey observations, rankings, image rights, organizational credentials or production URLs are invented.

## Delivery Index

The completed package is organized around ten requested deliverables:

| Deliverable | Specification |
|---|---|
| A | [A_PRD.md](A_PRD.md): product requirements, personas, journeys, scope and acceptance. |
| B | [B_Technical_Architecture.md](B_Technical_Architecture.md): React/FastAPI/PostGIS architecture, security and deployment. |
| C | [C_UX_UI_Blueprint.md](C_UX_UI_Blueprint.md): brand-aligned tokens, responsive layout, accessibility and narrative. |
| D | [D_Page_Wireframes.md](D_Page_Wireframes.md): desktop/mobile wireframes and state behavior for every route. |
| E | [E_Component_Inventory.md](E_Component_Inventory.md): component contracts, ownership and accessibility. |
| F | [F_Database_Schema.md](F_Database_Schema.md) and [database/schema.sql](database/schema.sql): logical and implementation database design. |
| G | [G_API_Specification.md](G_API_Specification.md) and [api/openapi.json](api/openapi.json): endpoints, contracts, auth and errors. |
| H | [H_GIS_Data_Workflow.md](H_GIS_Data_Workflow.md) and [data/indicator_contracts.csv](data/indicator_contracts.csv): secondary-evidence GIS processing and all 42 indicators. |
| I | [I_D3_Visualisation_Specifications.md](I_D3_Visualisation_Specifications.md): ten visualization contracts and interactions. |
| J | [J_Development_Roadmap.md](J_Development_Roadmap.md): sequenced backlog, gates, testing and operations. |

These are specification artifacts. The database DDL and OpenAPI document are implementation contracts; they do not prove a running database, FastAPI service, frontend, tiles, or identity provider exists.

## Non-Negotiable Rules

- Secondary data only. Remote interviews or a new online market-status form would be primary collection and are out of scope.
- Unverified geometry remains null. The concept note has 14 populated entries with a possible merged livestock/camel entry; no fictitious fifteenth market is created.
- Open-source software is not synonymous with open data. ACLED, GSMA, commercial imagery, confidential references and institutional records require separate use/publication decisions.
- Official scores use the existing six weights, approved anchors, missing-leaf bounds and independent gates. Exploratory weights are never the published official model.
- Public readers receive only cleared release snapshots. Raw restricted records are not sent to browsers, tiles, downloads or telemetry.
- Potential reachable residents are not actual customers or unique beneficiaries. Recorded exposure is not safe access. Visible damage is not structural/ordnance certification.

## Baseline References

The existing assessment methodology, data inventory, market-name audit, GIS workflow and scoring configuration remain the source of analytical requirements. This platform specification adapts their implementation to open-source software rather than reproducing the ArcGIS item architecture.

Public design references consulted: [UNDP design system](https://design.undp.org/) and [official MIT-licensed repository](https://github.com/undp/design-system). Individual foundation tokens, trademarks, fonts and final identity must be checked with the authorized UNDP communications owner before release. A separate attempted brand-page retrieval was unsuccessful and is not treated as reviewed guidance.