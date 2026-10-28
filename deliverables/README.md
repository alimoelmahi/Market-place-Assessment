# Khartoum State Market Assessment Design Package

**Superseding evidence rule, 27 October 2026:** use [the evidence-only assessment workspace](../evidence_based_assessment/README.md). Historical design examples, assumed speeds/scenarios and uncalibrated value functions are not assessment evidence. Fictional fixtures have been withdrawn from active use and ranking is suspended pending real eligible inputs. The following index records design history, not completed empirical results.

Secondary evidence, GIS analysis, conditional prioritization, and ArcGIS StoryMap implementation

Prepared: 27 October 2026 | Status: methodology and preliminary documentary assessment, not completed GIS results

## Start Here

Read [02_Assessment_Report_and_Methodology.md](02_Assessment_Report_and_Methodology.md) for the assessment design and preliminary documentary findings. It covers the full market-system, livelihoods, accessibility, infrastructure, population, conflict, environmental, and investment questions, with a six-week implementation sequence.

All three supplied references were reviewed. The Arabic concept note is translated in full, with its market list and assumptions preserved. The StoryMap benchmark was reviewed for narrative, maps, profiles, and visual structure; the underlying live application and source datasets were not supplied.

**Two scope issues matter immediately:** the concept note describes 15 markets but lists only 14 identifiable entries; several names and Bahri/Sharg El Neel assignments need resolution. The reference StoryMap contains `NOT YET CLASSIFIED` material requiring owner clearance before external reuse.

**Evidence limitation:** a secondary-only study can match a field study's transparency and analytical rigor, but cannot recreate unobserved trader behavior, structural safety, protection conditions, sales, preferences, or participation rates. The package makes these gaps visible rather than creating false completeness.

## Deliverable Index

| Requested output | File | Contents |
|---|---|---|
| A. Detailed assessment methodology and report design | [02_Assessment_Report_and_Methodology.md](02_Assessment_Report_and_Methodology.md) | Evidence rules, framework crosswalk, all assessment themes, preliminary findings, intervention packages, implementation and donor acceptance. |
| B. GIS workflow and data schemas | [03_GIS_Workflow_and_Data_Schema.md](03_GIS_Workflow_and_Data_Schema.md) | Ten processing steps, analytical equations, CRS/resolution, routing/catchment/remote-sensing workflows, relational schemas, publication and QA. |
| C. StoryMap structure and storyboard | [05_StoryMap_Storyboard_and_Visual_Products.md](05_StoryMap_Storyboard_and_Visual_Products.md) | All nine requested sections, draft narrative, media/map behavior, evidence requirements, fallback rules, publication sequence. |
| D. Source inventory | [source_catalogue.csv](source_catalogue.csv) | 47 records: three supplied references and 44 external source candidates/guides/reports; URLs, dates, methods, rights, limitations, confidence expectations, review and acquisition status. |
| D. Indicator-level collection strategy | [indicator_catalogue.csv](indicator_catalogue.csv) | 42 indicators with source joins, units, collection/calculation, survey substitution, limitations, expected confidence, and MCDA role. |
| E. Market prioritization | [04_Market_Prioritization_Framework.md](04_Market_Prioritization_Framework.md) | Exact requested weights, normalization, missing-data bounds, investment gates, need/readiness distinction, sensitivity and synthetic example. |
| E. Scoring configuration | [scoring_model.json](scoring_model.json) | Machine-readable proposed weights, subweights, anchors, thresholds, scenario parameters, and tested synthetic cases; no real market scores. |
| F. Maps, dashboards, infographics | [05_StoryMap_Storyboard_and_Visual_Products.md](05_StoryMap_Storyboard_and_Visual_Products.md) | Specifications for 13 maps, five dashboard views, and four infographic/scorecard designs. |
| G. ArcGIS implementation | [03_GIS_Workflow_and_Data_Schema.md](03_GIS_Workflow_and_Data_Schema.md) | ArcGIS Pro and Online processing/publishing, Experience Builder configuration, licenses/credits, permissions, refresh and QA. StoryMaps authoring is in the storyboard. |
| Reference review and Arabic translation | [01_Reference_Review_and_Concept_Note_Translation.md](01_Reference_Review_and_Concept_Note_Translation.md) | Full working English translation, original Arabic market names, benchmark review, attributed claims, scope/assumption issues. |
| Provisional market universe | [market_register.csv](market_register.csv) | 14 source-derived stable IDs; all coordinates and locality codes intentionally blank pending verification. |
| Verification and handover | [06_Quality_Assurance_and_Handover.md](06_Quality_Assurance_and_Handover.md) | Checks performed, evidence limits, outstanding implementation gates, and recommended next decisions. |

## What Is Completed

- Review of the supplied framework, benchmark PDF, and Arabic concept note; working translation and reference critique.
- Comprehensive methodology, GIS/data model, secondary-source and indicator strategy, MCDA specification, visual-product inventory, and ArcGIS authoring instructions.
- Targeted review of accessible official source/method/report pages, with inaccessible and unreviewed sources explicitly labeled.
- Structural and arithmetic checks on the catalogues, register, scoring configuration, and storyboard.

## What Is Not Claimed

No new interviews, field visits, photography, survey results, geocoded market coordinates, downloaded/processed population or satellite stack, measured damage rates, real market scores, final ranking, tender costs, or published ArcGIS services/apps. The design is implementation-ready as a specification; results still require acquisition, processing, review, permissions, and the necessary safeguards.

External datasets are all marked `not_acquired`. A page reviewed online is not a downloaded country dataset. `candidate_not_reviewed`, `fetch_failed`, `not_obtained_reference_only`, and successful page-review statuses are intentionally distinct. Expected indicator confidence is conditional, not a result-level quality rating assigned in advance.

The intended six-criterion weights are population 20%, accessibility 15%, functionality 20%, lower recorded conflict exposure 15%, economic significance 15%, and rehabilitation feasibility 15%. High need remains separate from readiness. Unknowns generate bounds and evidence gaps; they are not zero performance and never create a fabricated investment rank.

## Immediate Decisions

1. Confirm the market universe, correct ambiguous names, identify the intended fifteenth entry, and verify localities and geometry from existing records.
2. Obtain reference-content clearance and the actual SAMRA report cited in the benchmark; request existing supporting market/engineering/tenure records.
3. Assign the GIS/market lead, freeze the analysis period, approve data access and resource-level licensing, and select population/network scenarios.
4. Approve scoring assumptions before results are visible; preserve a no-primary-data boundary throughout analysis.
5. Execute the GIS/evidence pipeline and independent desk review. Keep unresolved safety, tenure, engineering, and protection checks as conditions for any future implementation.

## Selected Public Sources Reviewed

- [IOM DTM Sudan](https://dtm.iom.int/sudan): repeated mobility/return reporting and methodology context.
- [FEWS NET Sudan](https://fews.net/east-africa/sudan) and [September 2026 update](https://fews.net/east-africa/sudan/key-message-update/september-2026): market, food-security, and economic context with geographic/temporal qualifications.
- [WFP Market Functionality Index](https://www.wfp.org/publications/market-functionality-index-mfi): nine assessment dimensions; not a secondary-proxy certification.
- [WorldPop](https://www.worldpop.org/): population-model selection and limitations.
- [Copernicus Sentinel-2](https://dataspace.copernicus.eu/explore-data/data-collections/sentinel-data/sentinel-2): imagery products and resolution.
- [NASA Black Marble](https://www.earthdata.nasa.gov/data/projects/black-marble): corrected nightlight products and sensor-continuity considerations.
- [JRC flood collection](https://data.jrc.ec.europa.eu/collection/id-0054): modeled river hazard; use global products, not Europe-only event data.
- [ACLED methodology](https://acleddata.com/methodology): event definitions, precision, and reporting limitations.

The full source catalogue is authoritative for review/acquisition status and candidate sources. This package is an internal working design until organizational clearance; no classification marking on supplied content is removed or overridden.