---
date: 2026-02-20
tags:
  - schema
  - hardening
  - plan
  - v0
  - architecture
---

# Schema Hardening Plan (v0 -> 10/10)

Source context:
- [[booking-use-cases-v3]]
- [[booking-schema-v0-coverage-report]]
- Canonical schema in `packages/db/src/schema/*.ts`

Goal:
- Push the current schema from ~8.6/10 to ~9.7-10/10 for:
  - correctness
  - scalability
  - extensibility
  - maintainability
  - fungibility across future use cases

Principles:
- Additive changes only.
- Preserve simple write paths for simple scenarios.
- Keep strict invariants at DB level where possible.
- Keep plugin/extensibility paths explicit and auditable.

---

## Phase 1 (P0): Integrity + Query Backbone

### 1) Introduce a canonical `subject_registry` for extensible polymorphic refs
What:
- Add `subject_registry` keyed by `(biz_id, subject_type, subject_id)`.
- Link extensible refs (`custom_subject` owner/member refs) to this table.

Why:
- Keeps plugin extensibility while restoring FK-like integrity for custom references.

Expected impact:
- Better referential safety and cleanup behavior.
- Lower risk of dangling `owner_ref_id` / `member_ref_id`.

---

### 2) Add exclusion constraints for no-overlap where overlap is disallowed
What:
- Introduce `time_window` range columns (`tstzrange`) on scheduling/assignment rows.
- Add GiST exclusion constraints for resources with `allow_simultaneous_bookings=false`.

Why:
- Moves critical “no double-booking” invariant into the database.

Expected impact:
- Stronger correctness under concurrency.
- Fewer race-condition bugs in API workers.

---

### 3) Standardize monetary precision + quantity precision contracts
What:
- Keep money as minor-unit integers everywhere.
- Replace non-money floating quantities that need exactness with `numeric(p,s)` where required.
- Add consistency checks for currency and amount semantics.

Why:
- Reduces subtle rounding drift in billing, payroll, and analytics.

Expected impact:
- Safer finance math and reconciliation.

---

### 4) Add targeted composite indexes for top query paths
What:
- Add/adjust indexes for:
  - availability slot search by `(biz_id, calendar_id, window_start/window_end, status)`
  - fulfillment dispatch board by `(biz_id, status, due_at, priority)`
  - revenue/top-sellables by `(biz_id, booked_at, sellable_id)`

Why:
- Align schema to hot operational and reporting paths.

Expected impact:
- Faster booking search, dispatch UI, and monthly KPI queries.

---

## Phase 2 (P1): Close Highest-Value Partial UC Gaps

### 5) Add gift instrument primitives
What:
- `gift_instruments`, `gift_redemptions`, `gift_transfers`, `gift_expiration_events`.

Why:
- Converts UC-115 from Partial to Strong/Full.

Expected impact:
- First-class gift voucher lifecycle and auditability.

---

### 6) Add participant payment obligation primitives
What:
- `booking_participant_obligations`, `participant_obligation_events`.

Why:
- Converts UC-117 from Partial to Strong/Full.

Expected impact:
- Native split-payment accountability per participant.

---

### 7) Add B2B AR / PO / net-terms primitives
What:
- `billing_accounts`, `purchase_orders`, `ar_invoices`, `invoice_events`.

Why:
- Converts UC-118 from Partial to Strong/Full.

Expected impact:
- Enterprise billing readiness without overloading payment tables.

---

### 8) Add SLA breach + compensation primitives
What:
- `sla_policies`, `sla_breach_events`, `sla_compensation_events`.

Why:
- Converts UC-119 from Partial to Strong/Full.

Expected impact:
- Explicit service-guarantee credits and dispute defensibility.

---

### 9) Add FX/tax calculation artifacts
What:
- `fx_rate_snapshots`, `tax_profiles`, `tax_calculations`, `tax_rule_refs`.

Why:
- Converts UC-120 from Partial to Strong/Full.

Expected impact:
- Deterministic, replayable checkout totals across currencies/jurisdictions.

---

### 10) Add workforce leave/PTO primitives
What:
- `leave_policies`, `leave_balances`, `leave_requests`, `leave_events`.

Why:
- Closes remaining workforce gap after `work_time_segments`.

Expected impact:
- Payroll-grade workforce scheduling + entitlement coherence.

---

## Phase 3 (P2): Operational Reliability + Analytics Maturity

### 11) Add offline operation journal + conflict primitives
What:
- `offline_ops_journal`, `offline_merge_conflicts`, `offline_resolution_events`.

Why:
- Converts UC-66 from Partial to Strong/Full.

Expected impact:
- Cleaner offline-first behavior and deterministic reconciliation.

---

### 12) Add fact tables/materialized views for unified reporting
What:
- Daily/monthly facts for revenue, margin, utilization, and top-sellables.

Why:
- Makes analytics fast and simple without repeated heavy joins.

Expected impact:
- Reliable “how much we made” and “top seller” answers at scale.

---

## Execution Order

1. Phase 1.1: `subject_registry` + custom ref hardening.
2. Phase 1.2: overlap exclusion constraints + range columns.
3. Phase 1.3: money/quantity precision audit + fixes.
4. Phase 2.1: gift + participant obligations + B2B AR.
5. Phase 2.2: SLA + FX/tax + PTO/leave.
6. Phase 3: offline journal + reporting fact layer.

Status (current workspace):
- Phase 1.1: complete
- Phase 1.2: complete
- Phase 1.3: complete
- Phase 2.1: complete
- Phase 2.2: complete
- Phase 3: complete

---

## Acceptance Criteria

1. No dangling polymorphic custom refs in calendar/capacity domains.
2. DB rejects invalid overlapping bookings for non-overlap resources.
3. Finance math is deterministic and replayable from stored artifacts.
4. Partial UC set shrinks materially:
   - UC-115, 117, 118, 119, 120, 66 -> Strong/Full.
5. Core KPI queries run from first-class indexed tables/views with predictable latency.

---

## Expected Rating After Plan

- Current: ~8.6/10
- After Phase 1: ~9.1/10
- After Phase 2: ~9.5/10
- After Phase 3: ~9.7-10/10
