import json
from datetime import datetime, timezone
from uuid import uuid4

from fastapi import HTTPException


class GoodsFlowStore:
    def __init__(self, storage):
        self.storage = storage
        with storage.connect() as connection:
            connection.execute("""CREATE TABLE IF NOT EXISTS goods_flow_events (
                flow_id TEXT NOT NULL, revision INTEGER NOT NULL,
                payload TEXT NOT NULL, active INTEGER NOT NULL,
                updated_at TEXT NOT NULL, PRIMARY KEY (flow_id, revision)
            )""")

    @staticmethod
    def serialize(row):
        return {**json.loads(row["payload"]), "flow_id": row["flow_id"], "revision": row["revision"],
                "active": bool(row["active"]), "updated_at": row["updated_at"],
                "evidence_status": "user_reported_unvalidated", "route_geometry": "schematic_not_transport_route"}

    def list_current(self):
        with self.storage.connect() as connection:
            rows = connection.execute("""SELECT current.* FROM goods_flow_events current
                WHERE current.revision = (SELECT MAX(history.revision) FROM goods_flow_events history
                    WHERE history.flow_id = current.flow_id) ORDER BY current.updated_at DESC""").fetchall()
        return [self.serialize(dict(row)) for row in rows]

    def save(self, payload, expected_revision=0, flow_id=None, active=True):
        with self.storage.connect() as connection:
            connection.execute("BEGIN IMMEDIATE")
            current = None if flow_id is None else connection.execute(
                "SELECT * FROM goods_flow_events WHERE flow_id = ? ORDER BY revision DESC LIMIT 1", (flow_id,)).fetchone()
            if flow_id is not None and current is None:
                raise HTTPException(status_code=404, detail="Transfer record not found.")
            revision = current["revision"] if current else 0
            if revision != expected_revision:
                raise HTTPException(status_code=409, detail="Transfer changed. Reload before saving.")
            if not active:
                if not current["active"]:
                    raise HTTPException(status_code=404, detail="Transfer already removed.")
                payload = json.loads(current["payload"])
            row = {"flow_id": flow_id or str(uuid4()), "revision": revision + 1,
                   "payload": json.dumps(payload), "active": int(active),
                   "updated_at": datetime.now(timezone.utc).isoformat()}
            connection.execute("""INSERT INTO goods_flow_events
                (flow_id, revision, payload, active, updated_at)
                VALUES (:flow_id, :revision, :payload, :active, :updated_at)""", row)
        return self.serialize(row)