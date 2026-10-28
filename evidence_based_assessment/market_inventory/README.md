# Khartoum Market Inventory

Status: evidence-constrained working gazetteer, reviewed 27 October 2026. **Not yet an authoritative approved market layer.** No new field observations, inferred coordinates or generated market centres are included.

## Outputs

- [Readable market gazetteer](Market_Gazetteer.md): all 14 Arabic names, transliterations, locality results, point coordinates where available and record-level decisions.
- [Complete CSV gazetteer](market_gazetteer.csv): requested fields plus identity, geometry, source, confidence, missingness and release controls.
- [Complete GeoJSON inventory](market_gazetteer.geojson): all 14 source entries, including null geometries. Some GIS software hides null-geometry records; the CSV remains the complete inventory.
- [Source-verified geometry layer](market_layer_source_verified.geojson): two actual OSM nodes and one actual OSM marketplace polygon. Mixed geometry types, WGS84 longitude/latitude. No generated polygon centres.
- [Candidate review](osm_candidate_review.csv) and [candidate geometries](osm_candidates_not_authoritative.geojson): all returned objects, including rejected hotels, restaurants, shops, transport facilities and neighbourhood areas. Not an authoritative market layer and not an additional market inventory.
- [Identity decisions](identity_decisions.json): explicit review decisions and exact discovery queries.
- [Source asset register](input_source_assets.csv): actual URLs, download timestamps, local paths and checksums for the inputs used by the build.
- [Open Buildings tile coverage](open_buildings_tile_coverage.csv): real official-index intersections, not downloaded building footprints.
- [Validation record](gazetteer_validation.json): source checks, original-document hash, entry counts, gaps and release status.

## Inventory Scope

The original Arabic DOCX was rechecked through its document XML. Paragraph 18 states a target of 15 markets, but the selected list has only 14 populated entries at paragraphs 20-30 and 36-38. The livestock/camel paragraph may contain aliases or distinct sites. It remains one source entry until existing records establish otherwise. No missing fifteenth name is invented. These are source entries, not a certified count of distinct physical sites.

Arabic wording is preserved, including `المحالي` and the malformed Bahri entry. Transliterations are working Latin-script renderings, not official names or proof of a name correction. The concept note's broad location labels are kept separately from formal locality assignments. The supplied assessment's Hilat Kuku/Um Duwaban/Souq Sitta aliases are contextual evidence, not permission to move all three sites into one locality.

All 14 entries are scoped to Khartoum State, Sudan. Sublocality administrative units are not established in the reviewed sources and remain blank with an explicit status. A settlement, municipality or neighbourhood centre is not substituted for a market point.

## Location Results

| Entry | Retained Geometry | Actual Source | Spatially Assigned COD Locality | Confidence Boundary |
| --- | --- | --- | --- | --- |
| KHM004, Al Kalakla Al Laffa | Point: latitude 15.4678125, longitude 32.4830627 | OSM node 7066645104, version 1, edited 18 December 2019 | Jebel Awlia, SD01001 | Moderate exact source-feature match; independent positional accuracy and entrance not established |
| KHM009, Souq Libya | Point: latitude 15.6478994, longitude 32.4233257 | OSM node 5320410421, version 2, edited 1 November 2019 | Um Bada, SD01002 | Moderate source-feature match; published report corroborates market identity in western Omdurman, not the precise point |
| KHM013, Hilat Kuku | Actual marketplace polygon; point fields blank | OSM way 1359632096, version 1, edited 13 February 2025 | Sharg An Neel, SD01004 | Moderate source-feature/assessment-alias agreement; no validated representative point or entrance |

The remaining 11 entries have no retained geometry. Twelve entries lack a validated point, including Hilat Kuku, which has a polygon only. The point coordinates above are copied from actual OSM nodes and checked against both discovery and source-object responses. They are not newly estimated or rounded by this assessment. **Neither point has been independently position-verified, surveyed or approved by a custodian.** OSM edit times and retrieval dates are not site-observation dates or evidence that a market is currently operating.

`coordinates_unvalidated_flag` indicates absence of a retained source-verified point. `independent_positional_validation` is separately `not_established` for every entry, including the two source points. Do not interpret a false missing-point flag as independent positional certification. All entrances remain unverified, all records are ineligible for routing, and no market is marked currently operating from its mapped presence.

## Source Use and Limitations

### OpenStreetMap

Sixteen targeted name queries were saved, covering all 14 entries, an alternative Al Arabi name, and the separate camel-market wording. Queries were made sequentially; no autocomplete or systematic global POI download is implemented. Responses are retained locally and should be reused rather than repeatedly querying the public geocoder. Failed broad Overpass attempts remain in the acquisition log.

Twenty-three returned candidate objects were reviewed. Relevant nodes were retrieved from the OSM object API; discovered candidate ways were downloaded with their actual nodes. Source-coordinate consistency, marketplace tags, names and polygon vertex identity were checked. Nominatim and the object API share OSM lineage: agreement is **not independent corroboration**. A successful empty query is not proof that a market is absent from OSM. No result or source tag establishes present trading, safety, tenure, trader numbers or rehabilitation feasibility.

Same-name or nearby results were deliberately not accepted when the source class described a hotel, department store, supermarket, viewpoint, restaurant or transport facility. The Khartoum central-market retail polygon and Al Shaabi neighbourhood polygon remain candidate context, not accepted market footprints. Generic names and source spelling problems remain visible.

### Administrative Areas

The previously acquired COD v03 Khartoum ADM2 polygons are the adopted reference. Point locality assignments require strict point-in-polygon containment in exactly one locality. Hilat Kuku requires containment of its full source polygon, not an invented centre or a mere overlap. Turf spatial predicates and actual source geometry are used. This yields Um Bada for Souq Libya despite the concept note's broader Omdurman label, and Sharg An Neel for Hilat Kuku despite its Bahri label.

This is a spatial assignment to a stated reference version, not a legal determination or independent boundary verification. COD metadata distinguishes original 2013 editing, validity from 31 August 2020, review in October 2025 and later resource-modification dates. No current legal or survey accuracy is inferred from a recent download.

### Google Open Buildings and Satellite References

The official [Open Buildings catalogue](https://sites.research.google/open-buildings/) and its linked [v3 tile index](https://openbuildings-public-dot-gweb-research.uw.r.appspot.com/public/tiles.geojson) were downloaded. Intersecting the three retained market geometries identifies actual tile `169`, with the provider's published compressed size of 1025.3 MB. Its URL is recorded in the coverage table.

The building-footprint tile itself was **not downloaded**. Only catalogue/index coverage was analysed. The catalogue explicitly states that its buildings have no building-type or street-address information. Even downloading this tile would not identify a building as a market, provide a verified entrance, or establish that a site is operating. Its v3 inference run in May 2023 does not establish a per-building image acquisition date. No building centroid is adopted and no building counts or current damage conclusions are claimed.

An original UNITAR/UNOSAT published map was downloaded and visually reviewed: [satellite-detected water extent, Khartoum/White Nile/Aj Jazirah/Sennar](https://unosat.org/static/unosat_filesystem/3960/UNOSAT_A3_Natural_Landscape_FL20240826SDN_Khartoum_10September2024_3.jpg), published 10 September 2024, using Sentinel-2 imagery from 8 September 2024 at 08:06 UTC, nominal 10 m. It is regional flood/imagery context, not a labelled market map or positional validation of these markets. The map describes its analysis as preliminary and not field-validated. No market coordinate or market flood-exposure result is inferred from it.

### Humanitarian, UN and Market Publications

- The supplied Arabic UNDP concept note is the inventory scope source; its confidentiality marking still applies.
- The supplied *Livelihood Recovery Through Market Rehabilitation* assessment supports contextual aliases and the three Sharg El Neel profiles. Its displayed publication date does not establish field observation dates, verified market coordinates or independent certification of current conditions. The source StoryMap identifier is `cab577d8931649ac96419b1af433536d` on `geosmart.undp.org`; the supplied PDF is the reviewed evidence, not proof of access to an underlying feature service.
- The acquired [UN-Habitat *Urban Sector Studies and Capacity Building for Khartoum State*](https://unhabitat.org/sites/default/files/download-manager-files/Urban%20Sector%20Studies%20and%20Capacity%20Building%20for%20Khartoum%20State.pdf), copyright 2009, was screened for title/date and relevant names. It is historical urban context; no selected-market coordinate was established from that review. It is not cited as direct site corroboration in individual rows.
- The acquired [Dabanga report dated 11 May 2023](https://www.dabangasudan.org/en/all-news/article/libya-market-plundered-police-remain-absent-in-sudan-capital) identifies Libya Market in western Omdurman and a neighbourhood market in El Morada. This supports historical name/area context only, not a point, fish-market extent or current operation.
- The acquired [published Al Arabi reference](https://en.wikipedia.org/wiki/Souq_Al_Arabi) describes the market south of the Great Mosque and gives a coarse coordinate. Its coordinate is not adopted as a validated market point. The page and sources it cites are not independent survey control, and secondary source copying must not be counted as triangulation.

## Authoritative Release Blockers

1. Establish the missing/distinct fifteenth site, or formally reconcile the scope to the documented source entries. Clarify the livestock/camel relationship.
2. Resolve `المحالي`, the malformed Bahri name, the Al Khayma department-store ambiguity and the nonunique central/numbered market names through already existing registry, assessment or labelled map evidence.
3. Obtain applicable dated, independently corroborated market-site geometries for unresolved entries. Do not use town centroids, nearby POIs, image guesses or generated representative points.
4. Verify entrances and relevant network connections before access/catchment analysis; a market-area node or polygon is not a routable entrance.
5. Reconcile locality discrepancies against the approved administrative reference; review source rights, concept-note confidentiality and intended publication scope.
6. Have the responsible market/GIS custodian review identity decisions, positional evidence and scope. No approval is implied by this desk build. A certified authoritative release cannot be completed from the evidence currently available.

## Reproduce and Check

The source downloader has separate modes for targeted queries, OSM nodes, OSM ways, official building index and publication references. Every request is logged with the actual response status. Failed attempts are not reclassified as missing real-world markets.

Install the JavaScript processing tools outside the workspace, then run the builder from the workspace root:

```powershell
npm install --prefix "$env:TEMP/khm-gazetteer-tools" --no-audit --no-fund @turf/boolean-point-in-polygon @turf/boolean-intersects @turf/boolean-within csv-parse csv-stringify osmtogeojson
node './evidence_based_assessment/scripts/Build-MarketGazetteer.cjs'
```

The builder hashes all used acquired assets, checks byte lengths, requires exact concept-entry coverage and retains only explicitly reviewed source objects. It tests OSM marketplace tags and node-coordinate consistency, polygon source vertices, unique point locality containment, blank point fields where appropriate, and disabled routing/authoritative approval. CSV booleans are explicit `true`/`false`; blanks in numeric coordinate fields mean missing, not zero. No synthetic fixtures are generated.

OSM outputs require attribution and applicable ODbL obligations. Open Buildings has its own licence options and attribution requirements; its index does not grant rights to republish unrelated imagery. UN publications and supplied internal sources retain their respective rights. Keep raw source files for audit; do not assume public redistribution permission from successful downloading.