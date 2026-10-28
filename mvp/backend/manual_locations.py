import sqlite3
from contextlib import contextmanager
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from fastapi import HTTPException


class ManualLocationStore:
    def __init__(self, path: Path):
        self.path = path
        path.parent.mkdir(parents=True, exist_ok=True)
        with self.connect() as connection:
            connection.execute("""CREATE TABLE IF NOT EXISTS location_events (
                market_id TEXT NOT NULL, revision INTEGER NOT NULL,
                latitude REAL NOT NULL, longitude REAL NOT NULL,
                source_reference TEXT NOT NULL, notes TEXT NOT NULL,
                entry_method TEXT NOT NULL, updated_at TEXT NOT NULL,
                active INTEGER NOT NULL, PRIMARY KEY (market_id, revision)
            )""")

    @contextmanager
    def connect(self):
        connection = sqlite3.connect(self.path, timeout=5)
        connection.row_factory = sqlite3.Row
        try:
            with connection:
                yield connection
        finally:
            connection.close()

    def list_current(self) -> list[dict[str, Any]]:
        with self.connect() as connection:
            rows = connection.execute("""SELECT current.* FROM location_events current
                WHERE current.revision = (SELECT MAX(history.revision) FROM location_events history
                    WHERE history.market_id = current.market_id) ORDER BY current.market_id""").fetchall()
        return [self.serialize(dict(row)) for row in rows]

    @staticmethod
    def serialize(row: dict[str, Any]) -> dict[str, Any]:
        return {**row, "active": bool(row["active"]), "validation_status": "user_provided_unvalidated",
                "independent_positional_validation": False, "authoritative_release_approved": False,
                "routing_eligible": False}

    def save(self, market_id: str, values: dict[str, Any], expected_revision: int, active: bool = True):
        with self.connect() as connection:
            connection.execute("BEGIN IMMEDIATE")
            current = connection.execute("SELECT * FROM location_events WHERE market_id = ? ORDER BY revision DESC LIMIT 1",
                                         (market_id,)).fetchone()
            revision = current["revision"] if current else 0
            if revision != expected_revision:
                raise HTTPException(status_code=409, detail="Location changed. Reload the record before saving.")
            if not active:
                if current is None or not current["active"]:
                    raise HTTPException(status_code=404, detail="No active manual location to remove.")
                values = dict(current)
            row = {"market_id": market_id, "revision": revision + 1,
                   "latitude": values["latitude"], "longitude": values["longitude"],
                   "source_reference": values["source_reference"], "notes": values["notes"],
                   "entry_method": values["entry_method"], "updated_at": datetime.now(timezone.utc).isoformat(),
                   "active": int(active)}
            connection.execute("""INSERT INTO location_events
                (market_id, revision, latitude, longitude, source_reference, notes, entry_method, updated_at, active)
                VALUES (:market_id, :revision, :latitude, :longitude, :source_reference, :notes, :entry_method, :updated_at, :active)""", row)
        return self.serialize(row)