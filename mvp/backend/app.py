import csv
import io
import json
import os
from contextlib import asynccontextmanager
from datetime import date
from pathlib import Path
from typing import Any, Literal

from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import FileResponse, Response
from pydantic import BaseModel, ConfigDict, Field, model_validator
from shapely.geometry import Point, shape
from starlette.middleware.trustedhost import TrustedHostMiddleware
from starlette.staticfiles import StaticFiles

try:
    from .manual_locations import ManualLocationStore
    from .goods_flows import GoodsFlowStore
except ImportError:
    from manual_locations import ManualLocationStore
    from goods_flows import GoodsFlowStore

ROOT = Path(__file__).resolve().parents[1]
SNAPSHOT = ROOT / "data" / "evidence.json"


@asynccontextmanager
async def lifespan(application: FastAPI):
    with SNAPSHOT.open(encoding="utf-8") as source:
        evidence: dict[str, Any] = json.load(source)
    if evidence["release"]["ranking_enabled"] or evidence["release"]["authoritative_release_approved"]:
        raise RuntimeError("This MVP may not publish rankings or authoritative approval.")
    application.state.evidence = evidence
    application.state.manual_locations = ManualLocationStore(Path(os.environ.get(
        "KHM_MANUAL_LOCATION_DB", str(ROOT / "data" / "manual_locations.sqlite3"))))
    application.state.boundaries = [shape(feature["geometry"]) for feature in evidence["boundaries"]["features"]]
    application.state.goods_flows = GoodsFlowStore(application.state.manual_locations)
    yield


app = FastAPI(title="Khartoum Market Evidence - Internal MVP", version="0.1.0", lifespan=lifespan)
app.add_middleware(TrustedHostMiddleware, allowed_hosts=["127.0.0.1", "localhost", "testserver"])


class ManualLocationInput(BaseModel):
    model_config = ConfigDict(extra="forbid", str_strip_whitespace=True)
    latitude: float = Field(ge=-90, le=90, allow_inf_nan=False, strict=True)
    longitude: float = Field(ge=-180, le=180, allow_inf_nan=False, strict=True)
    source_reference: str = Field(min_length=5, max_length=1000)
    notes: str = Field(min_length=5, max_length=2000)
    entry_method: Literal["coordinate_entry", "map_click"]
    expected_revision: int = Field(ge=0, strict=True)


class RemoveLocationInput(BaseModel):
    model_config = ConfigDict(extra="forbid")
    expected_revision: int = Field(ge=1, strict=True)


class GoodsFlowInput(BaseModel):
    model_config = ConfigDict(extra="forbid", str_strip_whitespace=True)
    source_market_id: str = Field(min_length=1, max_length=40)
    target_market_id: str = Field(min_length=1, max_length=40)
    commodity: str = Field(min_length=2, max_length=150)
    period_start: date
    period_end: date
    transport_mode: Literal["not_reported", "road", "rail", "river", "mixed", "other"]
    quantity: float | None = Field(default=None, gt=0, allow_inf_nan=False, strict=True)
    quantity_unit: str = Field(default="", max_length=60)
    source_reference: str = Field(min_length=5, max_length=1000)
    notes: str = Field(min_length=5, max_length=2000)
    expected_revision: int = Field(default=0, ge=0, strict=True)

    @model_validator(mode="after")
    def consistent_transfer(self):
        if self.source_market_id == self.target_market_id:
            raise ValueError("Origin and destination must be different markets.")
        if self.period_start > self.period_end:
            raise ValueError("The reporting period end must not precede its start.")
        if self.period_end > date.today():
            raise ValueError("Reported transfers cannot have a future reporting period.")
        if (self.quantity is not None) != bool(self.quantity_unit):
            raise ValueError("A reported quantity and its unit must be supplied together, or both left unknown.")
        return self


def require_local_editor(request: Request):
    if request.headers.get("X-Evidence-Editor") != "local-portal":
        raise HTTPException(status_code=403, detail="Manual edits require the local portal request header.")
    allowed_origins = {f"http://{host}:{port}" for host in ("127.0.0.1", "localhost")
                       for port in (5173, 4173, 8000)}
    origin = request.headers.get("origin")
    if origin and origin not in allowed_origins:
        raise HTTPException(status_code=403, detail="Cross-origin manual edits are not permitted.")


def unresolved_market(market_id: str, request: Request):
    record = next((record for record in request.app.state.evidence["markets"]
                   if record["market_id"] == market_id), None)
    if record is None:
        raise HTTPException(status_code=404, detail="Market is not in this evidence snapshot.")
    if record["geometry_status"] != "unresolved":
        raise HTTPException(status_code=409, detail="This market already has a sourced geometry; manual replacement is disabled.")
    return record


@app.middleware("http")
async def evidence_headers(request: Request, call_next):
    response = await call_next(request)
    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["Referrer-Policy"] = "strict-origin-when-cross-origin"
    response.headers["X-Frame-Options"] = "DENY"
    if request.url.path.startswith("/api/"):
        response.headers["Cache-Control"] = "no-store"
    return response


@app.get("/api/v1/health")
def health(request: Request):
    evidence = request.app.state.evidence
    return {"status": "ok", "release_id": evidence["release"]["id"], "ranking_enabled": False,
            "audience": "internal_local_only", "database": "file_snapshot_not_postgis"}


@app.get("/api/v1/snapshot")
def snapshot(request: Request):
    return request.app.state.evidence


@app.get("/api/v1/manual-locations")
def manual_locations(request: Request):
    return {"locations": request.app.state.manual_locations.list_current()}


def flow_payload(submission: GoodsFlowInput, request: Request):
    known_ids = {record["market_id"] for record in request.app.state.evidence["markets"]}
    if submission.source_market_id not in known_ids or submission.target_market_id not in known_ids:
        raise HTTPException(status_code=422, detail="Both endpoints must be actual entries in the market inventory.")
    return submission.model_dump(mode="json", exclude={"expected_revision"})


@app.get("/api/v1/goods-flows")
def goods_flows(request: Request):
    evidence = request.app.state.evidence
    positions = {record["market_id"]: {"coordinates": [record["longitude"], record["latitude"]],
                 "status": "source_verified_point"} for record in evidence["markets"]
                 if record["latitude"] is not None and record["longitude"] is not None}
    for location in request.app.state.manual_locations.list_current():
        if location["active"] and location["market_id"] not in positions:
            positions[location["market_id"]] = {"coordinates": [location["longitude"], location["latitude"]],
                                              "status": "manual_unvalidated_point"}
    records = []
    for flow in request.app.state.goods_flows.list_current():
        source = positions.get(flow["source_market_id"])
        target = positions.get(flow["target_market_id"])
        records.append({**flow, "source_position": source["coordinates"] if source else None,
                        "target_position": target["coordinates"] if target else None,
                        "source_location_status": source["status"] if source else "point_unresolved",
                        "target_location_status": target["status"] if target else "point_unresolved",
                        "mapping_status": "drawable" if source and target else "missing_endpoint_point"})
    return {"flows": records, "evidence_status": "user_reported_unvalidated",
            "source_dataset_status": "No acquired market-to-market transfer dataset in the current snapshot."}


@app.post("/api/v1/goods-flows", status_code=201)
def add_goods_flow(submission: GoodsFlowInput, request: Request):
    require_local_editor(request)
    if submission.expected_revision != 0:
        raise HTTPException(status_code=422, detail="New transfer records must start at revision zero.")
    return request.app.state.goods_flows.save(flow_payload(submission, request))


@app.put("/api/v1/goods-flows/{flow_id}")
def edit_goods_flow(flow_id: str, submission: GoodsFlowInput, request: Request):
    require_local_editor(request)
    return request.app.state.goods_flows.save(flow_payload(submission, request), submission.expected_revision, flow_id)


@app.delete("/api/v1/goods-flows/{flow_id}")
def remove_goods_flow(flow_id: str, submission: RemoveLocationInput, request: Request):
    require_local_editor(request)
    return request.app.state.goods_flows.save({}, submission.expected_revision, flow_id, active=False)


@app.put("/api/v1/markets/{market_id}/manual-location")
def save_manual_location(market_id: str, submission: ManualLocationInput, request: Request):
    require_local_editor(request)
    unresolved_market(market_id, request)
    point = Point(submission.longitude, submission.latitude)
    if not any(boundary.covers(point) for boundary in request.app.state.boundaries):
        raise HTTPException(status_code=422, detail="Coordinates must fall inside the acquired Khartoum State boundaries. Check latitude/longitude order.")
    return request.app.state.manual_locations.save(market_id, submission.model_dump(), submission.expected_revision)


@app.delete("/api/v1/markets/{market_id}/manual-location")
def remove_manual_location(market_id: str, submission: RemoveLocationInput, request: Request):
    require_local_editor(request)
    unresolved_market(market_id, request)
    return request.app.state.manual_locations.save(market_id, {}, submission.expected_revision, active=False)


@app.get("/api/v1/markets/{market_id}")
def market(market_id: str, request: Request):
    evidence = request.app.state.evidence
    record = next((record for record in evidence["markets"] if record["market_id"] == market_id), None)
    if record is None:
        raise HTTPException(status_code=404, detail="Market is not in this evidence snapshot.")
    geometry = next((feature for feature in evidence["marketGeometry"]["features"]
                     if feature["id"] == market_id), None)
    return {"market": record, "geometry": geometry}


@app.get("/api/v1/export/markets.csv")
def export_markets(request: Request):
    records = request.app.state.evidence["markets"]
    output = io.StringIO(newline="")
    writer = csv.DictWriter(output, fieldnames=list(records[0]))
    writer.writeheader()
    for record in records:
        sanitized = {}
        for key, value in record.items():
            if isinstance(value, bool):
                sanitized[key] = str(value).lower()
            elif isinstance(value, str) and value.startswith(("=", "+", "-", "@", "\t", "\r")):
                sanitized[key] = "'" + value
            else:
                sanitized[key] = value
        writer.writerow(sanitized)
    return Response(content="\ufeff" + output.getvalue(), media_type="text/csv; charset=utf-8",
                    headers={"Content-Disposition": 'attachment; filename="khartoum-market-gazetteer.csv"'})


if (ROOT / "dist" / "assets").is_dir():
    app.mount("/assets", StaticFiles(directory=ROOT / "dist" / "assets"), name="assets")


@app.get("/")
def index():
    index_path = ROOT / "dist" / "index.html"
    if not index_path.is_file():
        raise HTTPException(status_code=503, detail="Build frontend or use the local Vite development server.")
    return FileResponse(index_path)