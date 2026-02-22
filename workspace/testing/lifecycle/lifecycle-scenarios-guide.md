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
- File: `/Users/ameer/projects/bizing-mind/workspace/testing/lifecycle/lifecycle-01-slot-booking.json`
- What it covers:
  - host/resource setup
  - calendar + availability binding
  - offer publishing
  - booking + fulfillment assignment
  - overlap rejection invariant
  - final state verification

2. **Queue Walk-in Lifecycle**
- File: `/Users/ameer/projects/bizing-mind/workspace/testing/lifecycle/lifecycle-02-queue-walkin.json`
- What it covers:
  - queue setup
  - customer join + ticket issue
  - offer/claim/serve progression
  - queue event timeline rows
  - final served-state verification

3. **Gift Transfer Lifecycle**
- File: `/Users/ameer/projects/bizing-mind/workspace/testing/lifecycle/lifecycle-03-gift-transfer.json`
- What it covers:
  - gift issuance
  - transfer intent row
  - completion + ownership transfer
  - transfer traceability checks

4. **Class Group Booking Lifecycle (NEW)**
- File: `/Users/ameer/projects/bizing-mind/workspace/testing/lifecycle/lifecycle-04-class-group-waitlist.json`
- What it covers:
  - class schedule + occurrence setup
  - multiple student registrations (capacity limit)
  - waitlist when capacity full
  - cancellation opens spot
  - auto-promotion from waitlist
  - attendance tracking
  - final state verification

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

### Scenario 4: Class Group Booking

1. **Setup Class Infrastructure**
- creates instructor and multiple student identities
- creates biz/location/instructor resource
- creates class schedule with capacity limit (2 students)
- schedules class occurrence

2. **Publish Class Offer**
- creates offer shell for class
- creates immutable published offer version with max_participants

3. **Students Register (Fill Capacity)**
- first student registers and gets attendance record
- second student registers (fills capacity to 2/2)
- both have "registered" status

4. **Waitlist When Full**
- third student attempts to register
- booking created with "waitlisted" status
- queue entry created for class waitlist

5. **Edge Case: Cancellation Opens Spot**
- first student cancels registration
- attendance marked cancelled
- waitlisted student auto-promoted to "offered"
- student accepts spot, booking confirmed
- new attendance record created

6. **Verify Class State**
- confirms exactly 2 registered students (at capacity)
- confirms 1 cancelled registration
- confirms class occurrence still scheduled

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
- **gift** tests financial ownership/traceability flow,
- **class** tests capacity-limited group events + waitlist promotion.

Together they exercise:
- setup and configuration,
- lifecycle transitions,
- strict invariants,
- audit-friendly verification,
- capacity management,
- waitlist auto-promotion.

---

## Next expansions you can add

- add payment-intent + split-tender lifecycle under slot booking,
- add waitlist auto-offer timeout flow under queue,
- add gift redemption + reversal flow tied to booking/payment anchors.

