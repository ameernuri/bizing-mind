---
date: 2026-02-22
tags:
  - api
  - agent
  - mock-api
  - schema
  - testing
  - playbook
  - eli5
---

# Agent API Playbook (ELI5)

Related notes:
- [[booking-use-cases-v3]]
- [[booking-schema-v0-coverage-report]]
- Implementation guide: `/Users/ameer/projects/bizing/apps/api/src/agent-contract/README.md`

---

## 0) What this is

Think of this as a **robot-friendly fake API** that talks to your real database schema.

You give it plain English like:
- "list booking orders where status = confirmed"

It does this:
1. Translate sentence into strict command JSON.
2. Run command against real schema.
3. Return result + SQL trace.
4. Roll back writes if `dryRun=true`.

This lets us stress-test schema behavior before final REST API design.

---

## 1) Start it

From `/Users/ameer/projects/bizing/apps/api`:

```bash
PORT=6131 bun run dev
```

Health check:

```bash
curl http://localhost:6131/health
```

---

## 2) The 5 routes you need

1. `GET /api/v1/agent/schema`
- See all tables/columns in runtime catalog.

2. `POST /api/v1/agent/translate`
- Natural language -> canonical pseudo request.

3. `POST /api/v1/agent/execute`
- Run canonical pseudo request.

4. `POST /api/v1/agent/simulate`
- Natural language -> execute in safe dry-run mode.

5. `POST /api/v1/agent/scenarios/run`
- Run many test scenarios in one shot.

---

## 3) Copy-paste cookbook

### A) Discover schema

```bash
curl http://localhost:6131/api/v1/agent/schema
```

One table only:

```bash
curl "http://localhost:6131/api/v1/agent/schema?table=booking orders"
```

### B) Translate plain English

```bash
curl -X POST http://localhost:6131/api/v1/agent/translate \
  -H "content-type: application/json" \
  -d '{
    "input": "list booking orders where status = confirmed limit 5",
    "scope": { "bizId": "biz_123" },
    "dryRun": true
  }'
```

### C) Simulate from plain English (recommended default)

```bash
curl -X POST http://localhost:6131/api/v1/agent/simulate \
  -H "content-type: application/json" \
  -d '{
    "input": "update booking orders set status = confirmed where id = bo_123",
    "scope": { "bizId": "biz_123" }
  }'
```

### D) Execute direct canonical request

```bash
curl -X POST http://localhost:6131/api/v1/agent/execute \
  -H "content-type: application/json" \
  -d '{
    "requestId": "req_1",
    "dryRun": true,
    "scope": { "bizId": "biz_123" },
    "command": {
      "kind": "query",
      "table": "booking_orders",
      "filters": [
        { "column": "status", "op": "eq", "value": "confirmed" }
      ],
      "sort": [
        { "column": "created_at", "direction": "desc" }
      ],
      "limit": 3
    }
  }'
```

### E) Run a scenario batch

```bash
curl -X POST http://localhost:6131/api/v1/agent/scenarios/run \
  -H "content-type: application/json" \
  -d '{
    "defaults": {
      "dryRun": true,
      "scope": { "bizId": "biz_123" }
    },
    "scenarios": [
      {
        "name": "List recent bookings",
        "prompt": "list booking orders limit 3"
      },
      {
        "name": "Mark one booking confirmed",
        "prompt": "update booking orders set status = confirmed where id = bo_123"
      }
    ]
  }'
```

---

## 4) Golden rule for testing

Use this order:
1. `translate`
2. `simulate`
3. `execute` with `dryRun=false` only when you intentionally want to persist data.

This keeps failures easy to debug and prevents accidental writes.

---

## 5) Payload shapes (short version)

### Natural language request

```json
{
  "input": "list booking orders limit 5",
  "dryRun": true,
  "scope": { "bizId": "biz_123" }
}
```

### Canonical request

```json
{
  "dryRun": true,
  "scope": { "bizId": "biz_123" },
  "command": {
    "kind": "query | mutate | batch",
    "...": "see agent-contract types"
  }
}
```

---

## 6) Common errors and fixes

1. Error: `tenant-scoped table requires scope.bizId`
- Fix: Add `"scope": { "bizId": "biz_123" }`.

2. Error: `unknown table` or `unknown column`
- Fix: Call `/api/v1/agent/schema` first and use exact names.

3. Update/Delete blocked as unsafe
- Fix: Add a `where` filter with identifier (usually `id` + `bizId` scope).

4. You expected writes but data did not change
- Fix: You ran with `dryRun=true` (it rolls back by design).

---

## 7) How to use with local LLM agents

Loop template:
1. Local LLM generates scenario prompts from [[booking-use-cases-v3]].
2. Send in batches to `/api/v1/agent/scenarios/run`.
3. Collect failures.
4. Classify failures:
- translator gap
- command contract gap
- schema model gap
- data fixture gap
5. Fix and rerun.

This is the fastest path to hardening schema + API design before committing to REST endpoints.

---

## 8) Example high-value stress suite ideas

1. Availability and lead-time conflicts.
2. Split tender and payment allocation traces.
3. Service product selector constraints.
4. Queue + slot coexistence flows.
5. Gift purchase, transfer, redemption, expiration.
6. Enterprise delegation and scoped policy resolution.
7. CRM pipeline + marketing attribution joins.

---

## 9) One-line mental model

This layer is your **flight simulator** for the final API: same schema, safer controls, faster iteration.
