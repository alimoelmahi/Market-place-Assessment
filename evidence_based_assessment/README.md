# Khartoum Markets: Evidence-Only Assessment

## Governing Rule

Effective 27 October 2026, assessment observations, maps, comparisons, rankings and findings must use traceable real-world secondary evidence only. No fictional observations, invented coordinates, assumed operating status, fabricated imagery interpretation, unobserved trader counts or unsupported estimates are permitted.

A source catalogue is not an acquired dataset. An acquired dataset is not automatically suitable for a market indicator. A reproducible calculation requires the exact input resource, its observation dates/geography/units, the processing method and actual output. Missing information remains a gap, never numeric zero or an invented substitute.

## Existing Artifacts

The earlier A-G and open-source platform documents are design history, not completed empirical assessment results. Their proposed speeds, redistribution cases, thresholds, normalization anchors and worked examples are not observational evidence. Any conflicting design instruction is superseded by this evidence-only rule. No historical illustrative value may enter an active assessment table, map, API, database or ranking.

The separately generated fictional fixture file has been withdrawn; its path is retained only to avoid broken historical references. The six weights previously requested by the user are a declared decision preference, not measured evidence. Rankings remain suspended until inputs, scoring value functions and independent prerequisites are supported and approved. Do not reinterpret a weight or an ordinal rubric as a market measurement.

The supplied PDFs and Arabic Word document remain unchanged. Internal/confidential markings and third-party rights still apply. The 14 populated concept-note entries and possible combined livestock/camel entry remain unresolved; no fifteenth market or location is inferred.

## Required Evidence Record

Every observation must retain: indicator ID; actual source and resource URL; publisher; date coverage; geographic support; unit/denominator; extraction or derivation method; input asset hash; output/run reference; limitations; appraisal and confidence; licence/sensitivity; and whether a defensible current market-level value exists.

Unknown, stale, geographically coarse, inaccessible, conflicting or unsuitable evidence is explicitly recorded. An alternative proxy is only a proposed option until a real eligible resource has been acquired and processed. It may measure a different concept and must not silently replace the original indicator.

## Verification Boundary

No live market ranking or completed field-equivalent assessment is claimed here. Acquisition logs, checksums and actual observed-source coverage will document precisely what can be assessed. Public metadata and contextual national figures must not be assigned to individual markets as if locally measured.

## Active Evidence Outputs

- [Local web MVP](../mvp/README.md): read-only market explorer, regional price monitor and source/gap register using these actual evidence files. Local loopback use only; no authoritative release or public deployment implied.
- [Market inventory and gazetteer](market_inventory/README.md): all 14 concept-note entries, source-verified OSM points/polygon, candidate review, locality assignments and explicit authoritative-release blockers. This later inventory supersedes the initial identity/acquisition snapshot below; it does not enable rankings or claim independent positional validation.
- [Evidence findings and limitations](Evidence_Findings_and_Gaps.md): acquired coverage, defensible findings and remaining provider/data gaps.
- [Indicator evidence matrix](indicator_evidence_matrix.csv): all 42 indicators, including actual versus candidate sources, methods, dates, limitations, confidence and alternative evidence routes.
- [Verified input assets](processed/verified_input_assets.csv): exact acquisition URLs, retrieval timestamps, sizes and SHA-256 checksums.
- [Coverage summary](processed/coverage_summary.json): actual processing counts and disabled-ranking status.
- [WFP source observations](processed/wfp_khartoum_source_observations.csv): original fields and values for the source-labelled Khartoum monitoring location, without a selected-market assignment.
- [WFP series and derived changes](processed/wfp_khartoum_series_coverage_and_changes.csv): separate units/price types, matched nominal monthly changes and eligible monthly log-change variability.
- [World Bank national context](processed/worldbank_national_context.csv): published values and explicitly retained source-null years.
- [Khartoum locality boundaries](processed/khartoum_cod_admin2.geojson): an actual COD boundary subset, not market locations or catchments.
- [Population date conflict](processed/population_reference_date_conflict.csv): reasons the acquired population totals are not currently eligible for use.

Reproduce the outputs in PowerShell with `& './evidence_based_assessment/scripts/Build-EvidenceAudit.ps1'` from the workspace root. The processor fails on an input checksum/size mismatch or an incomplete indicator matrix. It uses no generated observation fixtures, imputation or assumed market values. Acquisition attempts remain in the original manifest; successful acquisition status does not mean full analytical suitability or exhaustive document review.