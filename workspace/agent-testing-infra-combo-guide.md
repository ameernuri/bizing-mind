# Bizing Combo Testing Infra Guide (Schema + API + Agents)

See also the operator-focused guide:
- `/Users/ameer/projects/bizing-mind/workspace/agent-testing-workflow-definitive-v0.md`

## Purpose

This infrastructure is designed to answer:

> "Does the current schema support real product lifecycles if API/UI were fully implemented?"

It combines:
- Schema-focused lifecycle tests
- Scenario coverage tests
- Real HTTP API journey tests
- Agent-friendly execution via Code Mode (MCP)

---

## Core Loop

1. Update use cases (`booking-use-cases-v3.md`) and/or lifecycle packs.
2. Run combined fitness loop.
3. Review classified failures:
   - `scenario_contract`
   - `schema_constraint`
   - `expectation_mismatch`
   - `execution_error`
4. Decide what to change:
   - test pack prompt/assumption,
   - schema invariant/constraint,
   - API orchestration behavior.
5. Apply change, re-run loop.
6. Repeat until target suites are green.

This makes schema and API evolution measurable, not subjective.

---

## Files Added

- Loop config:
  - `/Users/ameer/projects/bizing-mind/workspace/agent-fitness-loop-v0.json`
- Lifecycle pack:
  - `/Users/ameer/projects/bizing-mind/workspace/agent-api-uc1-lifecycle-v0.json`
- API journey pack:
  - `/Users/ameer/projects/bizing-mind/workspace/agent-api-api-journey-smoke-v0.json`
- Runner:
  - `/Users/ameer/projects/bizing-mind/workspace/run-agent-fitness-loop.sh`
- Code Mode UTCP config:
  - `/Users/ameer/projects/bizing/.utcp_config.bizing-testing.json`
- MCP client config example:
  - `/Users/ameer/projects/bizing-mind/workspace/code-mode-mcp-config-bizing-testing.json`
- Code Mode bridge launcher:
  - `/Users/ameer/projects/bizing/scripts/run-code-mode-mcp.sh`

---

## API Endpoints

- `GET /api/v1/agent/testing/catalog`
  - Lists available test packs from workspace.
- `POST /api/v1/agent/testing/run-loop`
  - Runs combined suites (lifecycle/scenario/api_journey) and returns one report.
- `POST /api/v1/agent/testing/run-default`
  - Runs `/Users/ameer/projects/bizing-mind/workspace/agent-fitness-loop-v0.json` directly.
- `GET /api/v1/agent/testing/openapi.json`
  - OpenAPI surface used by Code Mode UTCP HTTP manual discovery.

Existing endpoints also used:
- `POST /api/v1/agent/lifecycle/run`
- `POST /api/v1/agent/scenarios/run`
- `POST /api/v1/agent/translate`
- `POST /api/v1/agent/execute`

---

## Run It (Human)

```bash
/Users/ameer/projects/bizing-mind/workspace/run-agent-fitness-loop.sh \
  /Users/ameer/projects/bizing-mind/workspace/agent-fitness-loop-v0.json
```

The orchestrator writes:
- `/Users/ameer/projects/bizing-mind/workspace/reports/latest-agent-fitness.json`
- `/Users/ameer/projects/bizing-mind/workspace/reports/latest-agent-fitness.md`

---

## Run It (Agent via Code Mode MCP)

1. Start API server on `http://localhost:6129`.
2. Run Code Mode bridge:

```bash
/Users/ameer/projects/bizing/scripts/run-code-mode-mcp.sh
```

3. Point your MCP-capable agent client at:
   - `/Users/ameer/projects/bizing-mind/workspace/code-mode-mcp-config-bizing-testing.json`

4. In agent workflow:
   - discover tools (`search_tools`)
   - call `bizing_agent_testing.runAgentFitnessLoop` with loop config payload
   - inspect report, propose schema/API updates
   - rerun

---

## Interpreting Results

- `scenario_contract`:
  - Usually test payload drift, unknown fields, bad assumptions.
  - Fix test packs or translation contract first.

- `schema_constraint`:
  - Strong signal model can’t represent desired lifecycle.
  - Fix schema constraints/invariants or add missing relation.

- `expectation_mismatch`:
  - Flow executed but product behavior differs from expected UX/business rule.
  - Fix orchestration logic and/or missing first-class invariants.

- `execution_error`:
  - Operational failures, wiring issues, or uncategorized runtime errors.

---

## Recommended Governance

- Treat lifecycle packs as acceptance tests for major UCs.
- Require green loop before schema/API merges.
- Keep one "smoke" suite always fast and one "deep" suite for nightly runs.
- Add new UC packs before implementing feature changes, then evolve schema/API until green.
