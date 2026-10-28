import csv
import io
import json
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from fastapi.testclient import TestClient

from app import app, ROOT
from manual_locations import ManualLocationStore
from goods_flows import GoodsFlowStore
from app import GoodsFlowInput
from pydantic import ValidationError


class EvidenceApiTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.storage = tempfile.TemporaryDirectory()
        cls.database_path = Path(cls.storage.name) / "locations.sqlite3"
        cls.environment = patch.dict("os.environ", {"KHM_MANUAL_LOCATION_DB": str(cls.database_path)})
        cls.environment.start()
        cls.client_context = TestClient(app)
        cls.client = cls.client_context.__enter__()

    @classmethod
    def tearDownClass(cls):
        cls.client_context.__exit__(None, None, None)
        cls.environment.stop()
        cls.storage.cleanup()

    def test_real_snapshot_and_null_coordinates(self):
        response = self.client.get("/api/v1/snapshot")
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertEqual(len(data["markets"]), data["summary"]["markets"])
        self.assertFalse(data["release"]["ranking_enabled"])
        self.assertEqual(sum(market["latitude"] is None for market in data["markets"]), 12)
        self.assertTrue(all(not market["routing_eligible"] for market in data["markets"]))
        self.assertEqual(response.headers["cache-control"], "no-store")

    def test_market_source_point_and_polygon_are_not_conflated(self):
        point = self.client.get("/api/v1/markets/KHM004").json()
        polygon = self.client.get("/api/v1/markets/KHM013").json()
        self.assertEqual(point["geometry"]["geometry"]["type"], "Point")
        self.assertEqual(polygon["geometry"]["geometry"]["type"], "Polygon")
        self.assertIsNone(polygon["market"]["latitude"])

    def test_csv_export_preserves_original_entries_and_explicit_false(self):
        response = self.client.get("/api/v1/export/markets.csv")
        rows = list(csv.DictReader(io.StringIO(response.content.decode("utf-8-sig"))))
        source = self.client.get("/api/v1/snapshot").json()["markets"]
        self.assertEqual([row["arabic_name"] for row in rows], [row["arabic_name"] for row in source])
        self.assertTrue(all(row["authoritative_release_approved"] == "false" for row in rows))
        self.assertEqual(sum(row["latitude"] == "" for row in rows), 12)

    def test_no_write_route_or_raw_file_access(self):
        self.assertEqual(self.client.post("/api/v1/snapshot").status_code, 405)
        self.assertEqual(self.client.get("/raw/UNDP_Market_Assessment_Concept_Note_AR.docx").status_code, 404)
        self.assertEqual(self.client.get("/api/v1/rankings").status_code, 404)
        self.assertEqual(self.client.get("/api/v1/health", headers={"host": "untrusted.invalid"}).status_code, 400)

    def test_manual_location_persists_separately_and_can_be_removed(self):
        source = json.loads((ROOT.parent / "evidence_based_assessment/raw/osm_gazetteer_candidate_nodes.json").read_text(encoding="utf-8-sig"))
        candidate = next(record for record in source["elements"] if record["id"] == 4548460093)
        payload = {"latitude": candidate["lat"], "longitude": candidate["lon"],
                   "source_reference": "https://www.openstreetmap.org/node/4548460093",
                   "notes": "Actual same-name department-store candidate; market identity remains unvalidated.",
                   "entry_method": "coordinate_entry", "expected_revision": 0}
        headers = {"X-Evidence-Editor": "local-portal", "origin": "http://127.0.0.1:5173"}
        response = self.client.put("/api/v1/markets/KHM006/manual-location", json=payload, headers=headers)
        self.assertEqual(response.status_code, 200, response.text)
        record = response.json()
        self.assertEqual(record["validation_status"], "user_provided_unvalidated")
        self.assertFalse(record["authoritative_release_approved"])
        self.assertEqual(ManualLocationStore(self.database_path).list_current()[0]["latitude"], candidate["lat"])
        self.assertIsNone(self.client.get("/api/v1/markets/KHM006").json()["market"]["latitude"])
        self.assertEqual(self.client.put("/api/v1/markets/KHM006/manual-location", json=payload, headers=headers).status_code, 409)
        removed = self.client.request("DELETE", "/api/v1/markets/KHM006/manual-location", json={"expected_revision": record["revision"]}, headers=headers)
        self.assertEqual(removed.status_code, 200)
        self.assertFalse(removed.json()["active"])
        self.assertEqual(ManualLocationStore(self.database_path).list_current()[0]["revision"], 2)

    def test_manual_edits_require_origin_header_contract(self):
        response = self.client.request("DELETE", "/api/v1/markets/KHM006/manual-location", json={"expected_revision": 1})
        self.assertEqual(response.status_code, 403)
        response = self.client.request("DELETE", "/api/v1/markets/KHM006/manual-location", json={"expected_revision": 1},
                                       headers={"X-Evidence-Editor": "local-portal", "origin": "https://untrusted.invalid"})
        self.assertEqual(response.status_code, 403)

    def test_manual_location_rejects_sourced_geometry_replacement(self):
        response = self.client.request("DELETE", "/api/v1/markets/KHM009/manual-location", json={"expected_revision": 1},
                                       headers={"X-Evidence-Editor": "local-portal"})
        self.assertEqual(response.status_code, 409)

    def test_manual_location_rejects_swapped_coordinates(self):
        source = json.loads((ROOT.parent / "evidence_based_assessment/raw/osm_gazetteer_candidate_nodes.json").read_text(encoding="utf-8-sig"))
        candidate = next(record for record in source["elements"] if record["id"] == 4548460093)
        response = self.client.put("/api/v1/markets/KHM006/manual-location", json={
            "latitude": candidate["lon"], "longitude": candidate["lat"],
            "source_reference": "https://www.openstreetmap.org/node/4548460093",
            "notes": "Source-coordinate order validation; not a new observation.",
            "entry_method": "coordinate_entry", "expected_revision": 0}, headers={"X-Evidence-Editor": "local-portal"})
        self.assertEqual(response.status_code, 422)

    def test_goods_flows_start_empty_without_fabricated_links(self):
        response = self.client.get("/api/v1/goods-flows")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json()["flows"], [])
        self.assertIn("No acquired", response.json()["source_dataset_status"])

    def test_goods_flow_rejects_incomplete_unsupported_observation(self):
        response = self.client.post("/api/v1/goods-flows", json={}, headers={"X-Evidence-Editor": "local-portal"})
        self.assertEqual(response.status_code, 422)
        with self.assertRaises(ValidationError):
            GoodsFlowInput(source_market_id="KHM004", target_market_id="KHM004")

    def test_goods_flow_mutations_require_local_editor_contract(self):
        response = self.client.request("DELETE", "/api/v1/goods-flows/not-a-record", json={"expected_revision": 1})
        self.assertEqual(response.status_code, 403)
        store = GoodsFlowStore(app.state.manual_locations)
        self.assertEqual(store.list_current(), [])


if __name__ == "__main__":
    unittest.main()