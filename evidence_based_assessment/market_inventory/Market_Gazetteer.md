# Market Gazetteer

Internal working inventory. Source-verified does not mean custodian-approved, surveyed, currently operating or routing-ready. Arabic names are preserved from the concept note. Blank coordinates mean no validated point; polygon centres are not generated.

| ID | Arabic Name | English Transliteration | COD Locality | Latitude | Longitude | OSM Evidence | Location Confidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| KHM001 | سوق العربي الخرطوم | Suq al-Arabi al-Khartum | Unvalidated |  |  | No accepted feature; see review | Unresolved |
| KHM002 | السوق المركزي الخرطوم | Al-Suq al-Markazi al-Khartum | Unvalidated |  |  | No accepted feature; see review | Unresolved |
| KHM003 | السوق الشعبي الخرطوم | Al-Suq al-Shaabi al-Khartum | Unvalidated |  |  | No accepted feature; see review | Unresolved |
| KHM004 | سوق الكلاكلة اللفة الخرطوم | Suq al-Kalakla al-Laffa | Jebel Awlia | 15.4678125 | 32.4830627 | node/7066645104 | Moderate source match only |
| KHM005 | سوق المحالي الخرطوم | Suq al-Mahali al-Khartum literal rendering | Unvalidated |  |  | No accepted feature; see review | Unresolved |
| KHM006 | سوق الخيمة الخرطوم | Suq al-Khayma al-Khartum | Unvalidated |  |  | No accepted feature; see review | Unresolved |
| KHM007 | سوق أم درمان للمواشي أم درمان سوق الإبل (سوق المواشي) | Suq Umm Durman lil-Mawashi / Suq al-Ibil (Suq al-Mawashi) | Unvalidated |  |  | No accepted feature; see review | Unresolved |
| KHM008 | أم درمان سوق الموردة (سوق السمك) | Suq al-Mawrada (Suq al-Samak) Umm Durman | Unvalidated |  |  | No accepted feature; see review | Unresolved |
| KHM009 | أم درمان سوق ليبيا | Suq Libya Umm Durman | Um Bada | 15.6478994 | 32.4233257 | node/5320410421 | Moderate source match only |
| KHM010 | بحري سعد بحري (الخرطوم بحري) | Bahri Saad Bahri (al-Khartum Bahri) literal rendering | Unvalidated |  |  | No accepted feature; see review | Unresolved |
| KHM011 | السوق المركزي (الخرطوم بحري) | Al-Suq al-Markazi al-Khartum Bahri | Unvalidated |  |  | No accepted feature; see review | Unresolved |
| KHM012 | أم ضوابان (الخرطوم بحري) | Um Duwaban; working alias Um Dawwan Ban | Unvalidated |  |  | No accepted feature; see review | Unresolved |
| KHM013 | الحلة كوكو (الخرطوم بحري) | Al-Hilla Kuku; working alias Hilat Kuku | Sharg An Neel |  |  | way/1359632096 | Moderate source match only |
| KHM014 | سوق ستة (الخرطوم بحري) | Suq Sitta; working alias Soug 6 | Unvalidated |  |  | No accepted feature; see review | Unresolved |

All entries are scoped to Khartoum State, Sudan. Sublocality administrative units remain unvalidated. Formal localities are populated only by source-geometry containment in acquired COD boundaries; broad concept labels remain separately preserved.

## Record Decisions

- KHM001: No unambiguous market object returned. Hostel and taxi facility rejected. Published coarse Al Arabi reference coordinate is not adopted as a validated market point.
- KHM002: Named retail-area polygon way/108706657 is a candidate, not independently established market footprint. Viewpoint, apartment and greengrocer points rejected as market coordinates.
- KHM003: Named neighbourhood polygon way/178258112 retained as candidate context only. Neighbourhood centre and supermarket point do not validate the market location.
- KHM004: Exact distinctive market name and marketplace tag; actual OSM node coordinates checked against source API. Source-verified inventory point only, not a surveyed position, market entrance or current operation finding.
- KHM005: No result for the literal source spelling. Intended market remains unresolved; no spelling correction or substitute site adopted.
- KHM006: Same-name node/4548460093 exists but is tagged shop=department_store. It is not accepted as the concept-note market without corroboration of site and role.
- KHM007: No result from either documented livestock or camel lookup. Combined livestock/camel paragraph remains one source entry; distinct-site count and both locations unresolved.
- KHM008: Restaurants and differently named markets rejected. Dabanga supports El Morada neighbourhood market identity historically, not an exact fish-market point or footprint.
- KHM009: Arabic market name and English alias agree with concept entry; actual marketplace node coordinates checked against source API. Dabanga corroborates the market in western Omdurman, not the precise point. Not an entrance or current-status finding.
- KHM010: Returned post office, shops and educational institutions rejected. Malformed original name retained; no substitution of Saad Gishra or another Bahri market.
- KHM011: Same-name node/4617489993 is tagged tourism=hotel and rejected as a market coordinate. Keep separate from Khartoum central-market entry.
- KHM012: No market result for the documented lookup. Settlement positions are not market positions. Concept Bahri versus supplied assessment Sharg El Neel discrepancy unresolved.
- KHM013: Named marketplace polygon agrees with supplied assessment market alias; source OSM way/nodes checked against returned geometry. Retain polygon, not Nominatim centre. Locality derived only if entire polygon is contained in one adopted COD locality.
- KHM014: No result for the documented query. Nonunique numbered market and Bahri/Sharg El Neel discrepancy unresolved. East/west sections are not silently split into separate markets.

## Source Files

- [Full gazetteer and provenance](market_gazetteer.csv)
- [All concept entries, including null geometries](market_gazetteer.geojson)
- [Source-verified market geometries only](market_layer_source_verified.geojson)
- [Candidate decisions, including rejected facilities](osm_candidate_review.csv)
- [Actual acquired input URLs and checksums](input_source_assets.csv)
- [Open Buildings tile coverage, not footprint analysis](open_buildings_tile_coverage.csv)
- [Validation results](gazetteer_validation.json)
- [Acquisition and release limitations](README.md)
