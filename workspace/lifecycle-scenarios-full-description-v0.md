# Full Lifecycle Scenario Kit (v0)

This document gives you runnable end-to-end lifecycle examples, not just CRUD snippets.

Each scenario tests a full journey:
- setup
- catalog/publish or readiness
- customer/operational flow
- edge behavior
- verification

Use this kit to answer: "Does the schema support real lifecycle behavior?"

---

## Included Scenarios

1. **Slot Booking Lifecycle**
- File: `/Users/ameer/projects/bizing-mind/workspace/agent-api-lifecycle-example-01-slot-booking-v0.json`
- What it covers:
  - host/resource setup
  - calendar + availability binding
  - offer publishing
  - booking + fulfillment assignment
  - overlap rejection invariant
  - final state verification

2. **Queue Walk-in Lifecycle**
- File: `/Users/ameer/projects/bizing-mind/workspace/agent-api-lifecycle-example-02-queue-walkin-v0.json`
- What it covers:
  - queue setup
  - customer join + ticket issue
  - offer/claim/serve progression
  - queue event timeline rows
  - final served-state verification

3. **Gift Transfer Lifecycle**
- File: `/Users/ameer/projects/bizing-mind/workspace/agent-api-lifecycle-example-03-gift-transfer-v0.json`
- What it covers:
  - gift issuance
  - transfer intent row
  - completion + ownership transfer
  - transfer traceability checks

---

## How To Run

### Run all three scenarios together

Use loop config:
- `/Users/ameer/projects/bizing-mind/workspace/agent-fitness-loop-lifecycle-examples-v0.json`

Command:

```bash
/Users/ameer/projects/bizing-mind/workspace/run-agent-fitness-loop.sh \
  /Users/ameer/projects/bizing-mind/workspace/agent-fitness-loop-lifecycle-examples-v0.json
```

Output reports:
- `/Users/ameer/projects/bizing-mind/workspace/reports/lifecycle-examples-agent-fitness.json`
- `/Users/ameer/projects/bizing-mind/workspace/reports/lifecycle-examples-agent-fitness.md`

### Run one scenario directly (optional)

```bash
curl -sS -X POST http://localhost:6129/api/v1/agent/lifecycle/run \
  -H 'content-type: application/json' \
  -d @/Users/ameer/projects/bizing-mind/workspace/agent-api-lifecycle-example-01-slot-booking-v0.json
```

Replace the file path with any of the other two examples.

---

## Phase-by-Phase Intent (What "full lifecycle" means)

### Scenario 1: Slot Booking

1. **Setup Supply + Calendar**
- creates owner/customer identities
- creates biz/location/resource
- creates calendar and binds it to the resource
- adds weekly availability rule

2. **Publish Offer**
- creates offer shell
- creates immutable published offer version

3. **Book + Assign**
- customer booking order is created
- fulfillment unit is created
- assignment is created to connect resource to execution window

4. **Edge Case: Double Booking Guard**
- creates overlapping second booking/unit
- attempts second overlapping assignment for same resource
- expects DB-level overlap rejection (`errorContains: overlap`)

5. **Verify State**
- confirms only one confirmed assignment exists
- confirms resource calendar binding is present

### Scenario 2: Queue Walk-in

1. **Setup Queue**
- creates operator/customer identities
- creates biz/location/queue

2. **Customer Joins Queue**
- inserts queue entry (waiting)
- appends joined event
- issues queue ticket

3. **Offer, Claim, Serve**
- entry status: waiting -> offered -> claimed -> served
- ticket status: issued -> completed with timeline timestamps
- appends served event

4. **Verify Queue Outcome**
- no waiting entries remain
- one served entry exists
- ticket is completed

### Scenario 3: Gift Transfer

1. **Setup Identities + Biz**
- creates issuer and recipient users
- creates biz

2. **Issue Gift Instrument**
- creates active gift instrument with owner = issuer
- verifies ownership row

3. **Transfer Gift Ownership**
- creates pending transfer row
- marks transfer completed with timestamp
- updates instrument owner to recipient

4. **Verify Traceability**
- verifies new owner
- verifies completed transfer row

---

## What to look for in failures

- `scenario_contract`
  - usually bad prompt/table/column assumptions
- `schema_constraint`
  - usually true model/invariant conflict
- `expectation_mismatch`
  - flow runs but expected lifecycle behavior differs
- `execution_error`
  - infrastructure/runtime/wiring issue

---

## Why these are good baseline lifecycle tests

They are intentionally complementary:
- **slot** tests scheduling + assignment invariants,
- **queue** tests non-slot operational flow,
- **gift** tests financial ownership/traceability flow.

Together they exercise:
- setup and configuration,
- lifecycle transitions,
- strict invariants,
- audit-friendly verification.

---

## Next expansions you can add

- add payment-intent + split-tender lifecycle under slot booking,
- add waitlist auto-offer timeout flow under queue,
- add gift redemption + reversal flow tied to booking/payment anchors.

