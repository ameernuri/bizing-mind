# Agent Lifecycle Testing Playbook (Schema Reality Check)

## Goal

Answer this question with evidence:

> "If we had a real API + UI, does the current schema support this end-to-end lifecycle?"

This playbook uses the lifecycle runner (`/api/v1/agent/lifecycle/run`) to test complete journeys, not just isolated CRUD calls.

---

## Core idea

- `scenarios/run` = single-step or loose batch tests.
- `lifecycle/run` = phase-based journey tests with:
  - expectations (`should pass`, `should fail`, `rowCount`)
  - captures (save IDs from earlier steps)
  - actor simulation (`scope.actorUserId`)
  - stateful execution in one transaction

Use lifecycle packs for real-world flow validation:
- onboarding
- publish
- discovery
- booking
- edge cases
- calendar verification
- cleanup

---

## Quick start

1. Start API server (`localhost:6129`).
2. Run the UC-1 lifecycle pack:

```bash
/Users/ameer/projects/bizing-mind/workspace/run-lifecycle-test.sh \
  /Users/ameer/projects/bizing-mind/workspace/agent-api-uc1-lifecycle-v0.json
```

3. Read:
- phase pass/fail
- issue classifications
- failed expectation message

---

## Lifecycle pack structure

Top-level:

- `defaults.dryRun`: run full flow then rollback (`true`) or persist (`false`)
- `defaults.scope`: base biz/user scope
- `variables`: reusable values
- `phases[]`: ordered lifecycle sections
- `options.rollbackOnFailure`: force rollback on failures when not dry-run

Step-level:

- `prompt` or `request` (canonical pseudo API request)
- `scope.actorUserId` to simulate owner/customer/staff behavior
- `expect`:
  - `success`
  - `rowCountEq` / `rowCountGte` / `rowCountLte`
  - `errorContains`
  - `asserts` path checks
- `captures` to save values into shared variables

---

## Template tokens

Inside prompts/requests/scopes:

- `{{id:biz}}` stable generated id for this run
- `{{nowIso}}`
- `{{nowPlusMinutes:30}}`
- `{{someVariable}}` from `variables` or captures

Important:
- Same token string returns same value within one run.
- Example: every `{{id:biz}}` is identical during that run.

---

## Failure classifications

The runner groups failures so feedback is actionable:

- `scenario_contract`: prompt/request drift, unknown columns, unresolved template values
- `schema_constraint`: FK/check/not-null/unique violations
- `expectation_mismatch`: query passed but behavior didn’t match intended product rule
- `execution_error`: everything else

Interpretation:

- lots of `scenario_contract` = test pack quality issue
- lots of `schema_constraint` = model or data-shape issue
- lots of `expectation_mismatch` = behavior gap (usually missing invariant)

---

## How to steer schema evolution

1. Encode the desired behavior as explicit expectations in lifecycle packs.
2. Run packs and classify failures.
3. For each failure decide:
   - wrong test assumption?
   - missing schema invariant?
   - missing orchestration layer rule?
4. Fix at the right layer.
5. Re-run until pack is green.

This keeps schema evolution grounded in real journey behavior instead of abstract table edits.

---

## What UC-1 currently proves

Current UC-1 lifecycle pack shows:

- setup/publish/booking path works
- overlap protection for host assignment is not enforced at DB level
- calendar verification catches the overlap leak (`2` assignments where `1` expected)

That is exactly the kind of lifecycle signal this runner is meant to surface.
