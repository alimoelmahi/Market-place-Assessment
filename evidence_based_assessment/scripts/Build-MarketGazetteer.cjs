const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const assert = require('node:assert/strict');
const { createRequire } = require('node:module');

const assessmentRoot = path.resolve(__dirname, '..');
const workspaceRoot = path.dirname(assessmentRoot);
const outputRoot = path.join(assessmentRoot, 'market_inventory');
const toolingRoot = process.env.KHM_GAZETTEER_TOOLS || path.join(process.env.TEMP, 'khm-gazetteer-tools');
const tools = createRequire(path.join(toolingRoot, 'package.json'));
const { parse } = tools('csv-parse/sync');
const { stringify } = tools('csv-stringify/sync');
const { booleanPointInPolygon } = tools('@turf/boolean-point-in-polygon');
const { booleanWithin } = tools('@turf/boolean-within');
const { booleanIntersects } = tools('@turf/boolean-intersects');
const osmToGeojson = tools('osmtogeojson');
const usedAssets = new Map();
const readJson = file => JSON.parse(fs.readFileSync(file, 'utf8').replace(/^\uFEFF/, ''));
const csv = file => parse(fs.readFileSync(file, 'utf8'), { columns: true, bom: true });
const digest = file => crypto.createHash('sha256').update(fs.readFileSync(file)).digest('hex');
const manifest = readJson(path.join(assessmentRoot, 'acquisition/acquisition_manifest.json'));
const successful = manifest.filter(asset => asset.status === 'acquired_unreviewed');

function acquireRecord(assetId) {
  const asset = successful.filter(record => record.asset_id === assetId).at(-1);
  assert.ok(asset, `No successfully acquired resource for ${assetId}`);
  const fullPath = path.join(assessmentRoot, asset.local_path);
  assert.equal(digest(fullPath), asset.sha256, `Hash mismatch: ${asset.local_path}`);
  assert.equal(fs.statSync(fullPath).size, asset.bytes, `Size mismatch: ${asset.local_path}`);
  usedAssets.set(asset.local_path, asset);
  return { asset, fullPath };
}

function rawJson(assetId) {
  return readJson(acquireRecord(assetId).fullPath);
}

function writeJson(file, value) {
  fs.writeFileSync(path.join(outputRoot, file), `${JSON.stringify(value, null, 2)}\n`);
}

function writeCsv(file, rows) {
  assert.ok(rows.length, `No real records for ${file}`);
  fs.writeFileSync(path.join(outputRoot, file), stringify(rows, {
    header: true, bom: true, cast: { boolean: value => String(value) }
  }));
}

function positionSet(coordinates, result = new Set()) {
  if (typeof coordinates[0] === 'number') {
    result.add(JSON.stringify(coordinates));
  } else {
    coordinates.forEach(part => positionSet(part, result));
  }
  return [...result].sort();
}

function localityMatches(geometry, boundaries) {
  const feature = { type: 'Feature', properties: {}, geometry };
  return boundaries.features.filter(boundary => geometry.type === 'Point'
    ? booleanPointInPolygon(feature, boundary, { ignoreBoundary: true })
    : booleanWithin(feature, boundary));
}

const auditPath = path.join(workspaceRoot, 'deliverables/Concept_Note_Market_List_Audit.csv');
const audit = csv(auditPath);
const conceptNoteHash = digest(path.join(workspaceRoot, 'UNDP_Market_Assessment_Concept_Note_AR.docx'));
const decisionsPath = path.join(outputRoot, 'identity_decisions.json');
const review = readJson(decisionsPath);
const boundaryInput = acquireRecord('HDX_RESOURCE_018af991-4aa7-4043-a0d5-e429a55851fb');
const boundaries = readJson(path.join(assessmentRoot, 'processed/khartoum_cod_admin2.geojson'));
assert.equal(boundaries.type, 'FeatureCollection');
assert.ok(boundaries.features.every(feature => feature.properties.adm1_pcode === 'SD01'));
const nodesInput = acquireRecord('OSM_GAZETTEER_CANDIDATE_NODES');
const nodeObjects = readJson(nodesInput.fullPath).elements;
const tiles = rawJson('GOOGLE_OPEN_BUILDINGS_TILE_INDEX');
assert.equal(tiles.type, 'FeatureCollection');
acquireRecord('GOOGLE_OPEN_BUILDINGS_CATALOGUE');
acquireRecord('UNHABITAT_KHARTOUM_URBAN_SECTOR_STUDY');
acquireRecord('UNOSAT_KHARTOUM_PUBLISHED_MAP_20240910');
assert.equal(audit.length, 14);
assert.deepEqual(review.decisions.map(record => record.market_id).sort(), audit.map(record => record.market_id).sort());

const rows = [];
const candidateRows = [];
const candidateFeatures = [];
const verifiedFeatures = [];
const allFeatures = [];
const buildingCoverage = [];

for (const entry of audit) {
  const decision = review.decisions.find(record => record.market_id === entry.market_id);
  const candidates = [];
  for (const query of decision.queries) {
    const lookup = acquireRecord(`OSM_NOMINATIM_${query}`);
    const places = readJson(lookup.fullPath);
    assert.ok(Array.isArray(places), `Not a result array: ${lookup.asset.local_path}`);
    for (const place of places) {
      assert.ok(place.osm_type && place.osm_id && place.geojson, 'Incomplete discovery object');
      const sourceId = `${place.osm_type}/${place.osm_id}`;
      const retained = sourceId === decision.retained_osm_id;
      const candidate = {
        market_id: entry.market_id, query, osm_object: sourceId,
        source_name: place.name, source_category: place.category, source_type: place.type,
        geometry_type: place.geojson.type, retained_market_geometry: retained,
        decision: decision.decision, source_url: `https://www.openstreetmap.org/${sourceId}`,
        input_file: lookup.asset.local_path, input_sha256: lookup.asset.sha256
      };
      candidateRows.push(candidate);
      candidateFeatures.push({ type: 'Feature', geometry: place.geojson, properties: candidate });
      candidates.push({ place, sourceId, lookup });
    }
  }
  const retained = candidates.filter(candidate => candidate.sourceId === decision.retained_osm_id);
  assert.ok(retained.length <= 1, 'Multiple retained source geometries for one concept entry');
  if (decision.retained_osm_id) assert.equal(retained.length, 1);
  let geometry = null;
  let sourceObject = null;
  let geometryAsset = null;
  if (retained.length) {
    const selected = retained[0];
    assert.equal(selected.place.category, 'amenity');
    assert.equal(selected.place.type, 'marketplace');
    if (selected.place.osm_type === 'node') {
      sourceObject = nodeObjects.find(object => object.type === 'node' && object.id === selected.place.osm_id);
      assert.ok(sourceObject, 'Retained OSM node is missing from source API response');
      assert.equal(sourceObject.tags.amenity, 'marketplace');
      assert.equal(sourceObject.tags.name, selected.place.name);
      assert.equal(Number(selected.place.lat), sourceObject.lat);
      assert.equal(Number(selected.place.lon), sourceObject.lon);
      assert.deepEqual(selected.place.geojson.coordinates, [sourceObject.lon, sourceObject.lat]);
      geometry = { type: 'Point', coordinates: [sourceObject.lon, sourceObject.lat] };
      geometryAsset = nodesInput.asset;
    } else {
      const source = acquireRecord(`OSM_GAZETTEER_WAY_${selected.place.osm_id}`);
      const body = readJson(source.fullPath);
      sourceObject = body.elements.find(object => object.type === 'way' && object.id === selected.place.osm_id);
      assert.ok(sourceObject, 'Retained OSM way is missing from source API response');
      assert.equal(sourceObject.tags.amenity, 'marketplace');
      assert.equal(sourceObject.tags.name, selected.place.name);
      const converted = osmToGeojson(body);
      const sourceFeature = converted.features.find(feature => feature.id === selected.sourceId);
      assert.ok(sourceFeature && sourceFeature.geometry.type === 'Polygon', 'Source way does not produce a valid area');
      assert.deepEqual(positionSet(sourceFeature.geometry.coordinates), positionSet(selected.place.geojson.coordinates));
      geometry = sourceFeature.geometry;
      geometryAsset = source.asset;
    }
  }
  const localities = geometry ? localityMatches(geometry, boundaries) : [];
  const locality = localities.length === 1 ? localities[0].properties : null;
  const sourcePoint = geometry?.type === 'Point';
  const corroboration = decision.corroboration_asset_ids.map(assetId => acquireRecord(assetId).asset.requested_url);
  const row = {
    market_id: entry.market_id, arabic_name: entry.market_name_ar,
    english_transliteration: entry.english_transliteration,
    concept_note_paragraph: entry.source_paragraph,
    concept_note_source_file: 'UNDP_Market_Assessment_Concept_Note_AR.docx',
    concept_note_sha256: conceptNoteHash,
    source_locality_label: entry.locality,
    locality: locality ? locality.adm2_name : '',
    locality_pcode: locality ? locality.adm2_pcode : '',
    locality_method: locality ? 'Full source geometry contained in one acquired COD v03 locality; not a legal determination' : 'Not validated',
    administrative_area: 'Khartoum State', country: 'Sudan',
    sublocality_administrative_unit: '', sublocality_status: 'Not established in reviewed evidence',
    latitude: sourcePoint ? geometry.coordinates[1] : '',
    longitude: sourcePoint ? geometry.coordinates[0] : '', crs: 'EPSG:4326; longitude,latitude in GeoJSON',
    coordinate_status: sourcePoint ? 'source_verified_osm_node_not_independently_position_verified'
      : geometry ? 'market_polygon_available_no_validated_point_or_entrance' : 'unvalidated_no_coordinates_supplied',
    coordinates_unvalidated_flag: !sourcePoint,
    independent_positional_validation: 'not_established',
    geometry_status: geometry ? 'source_verified_market_' + geometry.type.toLowerCase() : 'unresolved',
    osm_availability: geometry ? 'named_market_feature_source_verified'
      : candidates.length ? 'search_candidates_only_no_accepted_market_geometry' : 'no_match_in_recorded_query_not_proof_of_osm_absence',
    osm_object: decision.retained_osm_id || '', osm_candidate_objects: [...new Set(candidates.map(candidate => candidate.sourceId))].join(';'),
    osm_name: sourceObject?.tags.name || '', osm_version: sourceObject?.version || '',
    osm_last_edit: sourceObject?.timestamp || '', osm_edit_date_is_observation_date: false,
    location_observation_date: 'Not established; edit and retrieval times are not site-observation dates',
    data_source: 'Original Arabic concept note; source paragraph and prior XML audit; recorded OSM discovery responses' + (geometry ? '; actual OSM object API' : ''),
    coordinate_source_url: geometryAsset ? geometryAsset.requested_url : '',
    coordinate_source_sha256: geometryAsset ? geometryAsset.sha256 : '',
    osm_url: decision.retained_osm_id ? `https://www.openstreetmap.org/${decision.retained_osm_id}` : '',
    corroborating_publication_urls: corroboration.join(';'),
    supplied_assessment_context: !!decision.supplied_assessment_context,
    confidence_level: geometry ? 'Moderate for matched source feature only; independent positional confidence unassessed' : 'Unresolved location; no positional confidence assigned',
    source_name_interpretation_confidence: entry.confidence_level,
    coordinate_precision: sourcePoint ? 'Exact source digits retained; no survey accuracy inferred' : 'No point supplied',
    entrance_verified: false, routing_eligible: false, current_operation_verified: false,
    authoritative_release_approved: false, publication_clearance: 'Internal working inventory; confidential concept-note scope requires clearance',
    ambiguity_notes: entry.ambiguity_notes, validation_notes: decision.decision,
    review_date: review.review_date
  };
  if (sourcePoint) {
    assert.ok(Number.isFinite(row.latitude) && Number.isFinite(row.longitude));
    assert.equal(localities.length, 1, 'Source point not uniquely contained in one adopted locality');
  } else {
    assert.equal(row.latitude, '');
    assert.equal(row.longitude, '');
  }
  rows.push(row);
  const feature = { type: 'Feature', id: entry.market_id, geometry, properties: row };
  allFeatures.push(feature);
  if (geometry) {
    verifiedFeatures.push(feature);
    const coveringTiles = tiles.features.filter(tile => geometry.type === 'Point'
      ? booleanPointInPolygon(feature, tile) : booleanIntersects(feature, tile));
    for (const tile of coveringTiles) {
      buildingCoverage.push({
        market_id: entry.market_id, market_source_object: row.osm_object,
        open_buildings_tile: tile.properties.tile_id, tile_url: tile.properties.tile_url,
        published_tile_size_mb: tile.properties.size_mb,
        coverage_method: 'Source-geometry intersection with acquired official v3 tile index only',
        footprint_data_acquired: false, market_identity_provided_by_buildings: false,
        imagery_observation_date: 'Not established per building; v3 inference May 2023 is not per-building observation date'
      });
    }
  }
}

assert.equal(rows.length, 14);
assert.equal(new Set(rows.map(row => row.market_id)).size, rows.length);
assert.equal(new Set(rows.filter(row => row.osm_object).map(row => row.osm_object)).size, verifiedFeatures.length);
assert.ok(rows.every(row => !row.routing_eligible && !row.authoritative_release_approved));
assert.ok(rows.filter(row => row.coordinates_unvalidated_flag).every(row => row.latitude === '' && row.longitude === ''));
writeCsv('market_gazetteer.csv', rows);
writeCsv('osm_candidate_review.csv', candidateRows);
writeCsv('open_buildings_tile_coverage.csv', buildingCoverage);
writeCsv('input_source_assets.csv', [...usedAssets.values()].map(asset => ({
  asset_id: asset.asset_id, source_url: asset.requested_url, local_path: asset.local_path,
  retrieved_at: asset.retrieved_at_utc, bytes: asset.bytes, sha256: asset.sha256
})));
writeJson('market_gazetteer.geojson', { type: 'FeatureCollection', features: allFeatures });
writeJson('market_layer_source_verified.geojson', { type: 'FeatureCollection', features: verifiedFeatures });
writeJson('osm_candidates_not_authoritative.geojson', { type: 'FeatureCollection', features: candidateFeatures });
const summary = {
  generated_at: new Date().toISOString(), concept_note_populated_entries: audit.length,
  stated_scope_target: 15, distinct_fifteenth_market_identified: false,
  original_docx_sha256: conceptNoteHash,
  audit_csv_sha256: digest(auditPath), identity_decisions_sha256: digest(decisionsPath),
  adopted_boundary_archive_sha256: boundaryInput.asset.sha256,
  adopted_boundary_subset_sha256: digest(path.join(assessmentRoot, 'processed/khartoum_cod_admin2.geojson')),
  source_verified_market_points: rows.filter(row => row.geometry_status === 'source_verified_market_point').length,
  source_verified_market_polygons: rows.filter(row => row.geometry_status === 'source_verified_market_polygon').length,
  entries_without_validated_point: rows.filter(row => row.coordinates_unvalidated_flag).length,
  entries_without_retained_geometry: rows.filter(row => row.geometry_status === 'unresolved').length,
  independently_position_verified_entries: 0, verified_entrances: 0,
  authoritative_release_approved: false, ranking_enabled: false,
  osm_result_candidates_reviewed: candidateRows.length, acquired_input_files_verified: usedAssets.size,
  google_building_footprints_acquired: false,
  boundary_warning: 'COD source vintages do not certify current legal or positional validity.',
  source_warning: 'Nominatim and OSM object API share OSM lineage; object consistency is not independent positional validation.',
  validation: 'Input hashes/sizes, concept-entry completeness, source tags, actual node coordinates, polygon vertex identity, unique locality containment, null point fields and exclusion of invented centres checked.'
};
writeJson('gazetteer_validation.json', summary);
const table = [
  '# Market Gazetteer', '',
  'Internal working inventory. Source-verified does not mean custodian-approved, surveyed, currently operating or routing-ready. Arabic names are preserved from the concept note. Blank coordinates mean no validated point; polygon centres are not generated.', '',
  '| ID | Arabic Name | English Transliteration | COD Locality | Latitude | Longitude | OSM Evidence | Location Confidence |',
  '| --- | --- | --- | --- | --- | --- | --- | --- |',
  ...rows.map(row => `| ${row.market_id} | ${row.arabic_name} | ${row.english_transliteration} | ${row.locality || 'Unvalidated'} | ${row.latitude} | ${row.longitude} | ${row.osm_object || 'No accepted feature; see review'} | ${row.geometry_status === 'unresolved' ? 'Unresolved' : 'Moderate source match only'} |`), '',
  'All entries are scoped to Khartoum State, Sudan. Sublocality administrative units remain unvalidated. Formal localities are populated only by source-geometry containment in acquired COD boundaries; broad concept labels remain separately preserved.', '',
  '## Record Decisions', '',
  ...rows.map(row => `- ${row.market_id}: ${row.validation_notes}`), '',
  '## Source Files', '',
  '- [Full gazetteer and provenance](market_gazetteer.csv)',
  '- [All concept entries, including null geometries](market_gazetteer.geojson)',
  '- [Source-verified market geometries only](market_layer_source_verified.geojson)',
  '- [Candidate decisions, including rejected facilities](osm_candidate_review.csv)',
  '- [Actual acquired input URLs and checksums](input_source_assets.csv)',
  '- [Open Buildings tile coverage, not footprint analysis](open_buildings_tile_coverage.csv)',
  '- [Validation results](gazetteer_validation.json)',
  '- [Acquisition and release limitations](README.md)', ''
];
fs.writeFileSync(path.join(outputRoot, 'Market_Gazetteer.md'), table.join('\n'));
console.log(JSON.stringify(summary, null, 2));