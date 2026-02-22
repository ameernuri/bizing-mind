# Bizing Agent Testing Workflow (Definitive v0)

## 1) What this setup is for

This setup answers one question:

> If we had the final API/UI, would the current schema support full real-world lifecycles?

It does this by combining:
- schema-validated pseudo API execution,
- lifecycle journey packs (multi-step end-to-end),
- scenario smoke packs (fast contract checks),
- HTTP API journey packs (surface-level route checks),
- one consolidated fitness report.

---

## 2) One-time setup

1. Start Postgres and set DB URL in:
   - `/Users/ameer/projects/bizing/apps/api/.env`
   - `/Users/ameer/projects/bizing/packages/db/.env`
2. Apply migrations:
```bash
cd /Users/ameer/projects/bizing/packages/db
bun run db:migrate
```
3. Start API:
```bash
cd /Users/ameer/projects/bizing/apps/api
bun run dev
```
4. Health check:
```bash
curl -s http://localhost:6129/health
```

---

## 3) Daily workflow (human + agent)

1. Update/add use case(s) in:
   - `/Users/ameer/projects/bizing-mind/workspace/booking-use-cases-v3.md`
2. Encode lifecycle expectations in JSON packs:
   - `/Users/ameer/projects/bizing-mind/workspace/agent-api-*.json`
3. Run combined loop:
```bash
/Users/ameer/projects/bizing-mind/workspace/run-agent-fitness-loop.sh \
  /Users/ameer/projects/bizing-mind/workspace/agent-fitness-loop-v0.json
```
4. Read report outputs:
   - `/Users/ameer/projects/bizing-mind/workspace/reports/latest-agent-fitness.json`
   - `/Users/ameer/projects/bizing-mind/workspace/reports/latest-agent-fitness.md`
5. Classify failures, fix schema/API/test assumptions, rerun.
6. Repeat until green.

---

## 4) Pack types and when to use each

- `lifecycle`:
  - Use for full UC journey validation (setup -> publish -> booking -> edge cases -> verify).
  - Best for proving schema fitness.
- `scenario`:
  - Use for fast translation/execution contract smoke tests.
  - Best for catching table/column/enum drift quickly.
- `api_journey`:
  - Use for HTTP route-level regression checks.
  - Best for request/response envelope stability.

Rule: important UCs should always have a lifecycle pack.

---

## 5) Canonical endpoints

- `GET /api/v1/agent/testing/catalog`
- `POST /api/v1/agent/testing/run-loop`
- `POST /api/v1/agent/testing/run-default`
- `GET /api/v1/agent/testing/openapi.json`
- `POST /api/v1/agent/lifecycle/run`
- `POST /api/v1/agent/scenarios/run`
- `POST /api/v1/agent/translate`
- `POST /api/v1/agent/execute`

Base URL: `http://localhost:6129`

---

## 6) How lifecycle packs should be written

Required habits:
- Always set `scope.bizId` for tenant tables.
- Use template tokens (`{{id:*}}`) for deterministic linking.
- Add explicit expectations (`success`, `rowCountEq`, `errorContains`) per step.
- Capture IDs once and reuse via `captures`.
- Prefer realistic lifecycle behavior over raw CRUD.

Important runtime behavior:
- Lifecycle runner executes in one transaction.
- Each executed request now uses a SQL savepoint.
- Expected failing steps (for example overlap guards) no longer poison later steps.

---

## 7) Failure interpretation (decision table)

- `scenario_contract`:
  - Usually pack misuse (wrong table/column/enum assumptions).
  - Fix pack or translator contract first.
- `schema_constraint`:
  - Usually real model invariant conflict or missing relationship.
  - Fix schema design or constraints.
- `expectation_mismatch`:
  - Flow ran, but behavior differs from intended product rule.
  - Fix API orchestration rules, policy linkage, or test expectation.
- `execution_error`:
  - Infrastructure/runtime failure.
  - Fix server/runtime/tooling first.

---

## 8) Current important invariants to know

- `fulfillment_assignments` has DB-level overlap blocking when:
  - `conflict_policy = enforce_no_overlap`,
  - `status in (reserved, confirmed, in_progress)`,
  - same `biz_id + resource_id`,
  - time windows overlap.
- This is enforced by exclusion constraint:
  - `fulfillment_assignments_no_overlap_excl`
- Constraint naming intentionally includes `overlap` for stable lifecycle assertions.

---

## 9) Agent operating playbook (copy/paste)

Use this instruction block for testing agents:

1. Read the target UC in `/Users/ameer/projects/bizing-mind/workspace/booking-use-cases-v3.md`.
2. Encode/adjust lifecycle pack under `/Users/ameer/projects/bizing-mind/workspace/agent-api-*.json`.
3. Run `/api/v1/agent/testing/run-loop`.
4. For each failed step, label as:
   - pack assumption issue,
   - API orchestration issue,
   - schema capability gap.
5. Propose smallest canonical fix.
6. Rerun until green.
7. Summarize:
   - what passed,
   - what failed,
   - what changed,
   - what remains risky.

---

## 10) Anti-patterns to avoid

- Treating outdated/legacy table names as canonical.
- Testing only CRUD without lifecycle assertions.
- Using hard delete where the model expects lifecycle/soft-delete behavior.
- Interpreting one failed step as full-suite schema failure without classification.
- Adding schema columns to satisfy one test instead of fixing pack misuse.

---

## 11) Code Mode / MCP usage

Configs:
- UTCP: `/Users/ameer/projects/bizing/.utcp_config.bizing-testing.json`
- MCP client example: `/Users/ameer/projects/bizing-mind/workspace/code-mode-mcp-config-bizing-testing.json`
- Launcher: `/Users/ameer/projects/bizing/scripts/run-code-mode-mcp.sh`

Suggested sequence:
1. Launch API.
2. Launch MCP bridge.
3. Discover tools.
4. Call `run-loop`.
5. Submit schema/API patch proposals based on classified failures.

