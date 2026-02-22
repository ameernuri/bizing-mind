---
date: 2026-02-20
tags:
  - schema
  - plan
  - unified-commerce
  - booking
  - v0
---

# Unified Commerce Schema Evolution Plan (v0)

Source context:
- Use cases: [[booking-use-cases-v3]]
- Coverage baseline: [[booking-schema-v0-coverage-report]]

## Goal

Evolve the schema so Bizing is one coherent system for:
- selling time-based services,
- selling SKU/digital products,
- selling resource time (hosts/assets/venues),
- and managing fulfillment, money, and operations in one interoperable model.

In plain terms: no alien sub-systems for similar business actions.

---

## Design Principles

1. One commercial language across domains
- Every sellable thing should map to one canonical sellable identity.
- Every sale should become a normalized order line with consistent money semantics.

2. One fulfillment language across domains
- Time execution, rental windows, shipments, and async deliverables should all map to fulfillment units.

3. One financial truth
- Revenue, fees, refunds, commissions, disputes, payouts, and credits must be queryable from one normalized ledger/event spine.

4. One reporting dimension model
- “Top selling product/service” and “how much did we make” must use the same fact source.

5. Extend by adding typed modules, not by branching behavior
- New verticals should add normalized side tables, not duplicate order/booking systems.

---

## Current Strengths (Keep)

- Strong order + fulfillment backbone (`booking_orders`, `booking_order_lines`, `fulfillment_units`).
- Strong typed attribution across sellables (`booking_order_line_sellables`).
- Strong scheduling/availability core (`calendars`, `calendar_bindings`, `availability_rules`).
- Strong payment/dispute/settlement/payout primitives.
- Strong resource abstraction and domain modules.

---

## Top Gaps to Close Next

From coverage and latest UC additions:
- UC-115 gift voucher lifecycle (code issuance/redemption)
- UC-116 consent/waiver template + signed artifact model
- UC-117 participant-level split-payment obligations
- UC-118 B2B PO/net-terms AR primitives
- UC-119 SLA breach + auto-credit primitives
- UC-120 FX/tax normalized calculation artifacts
- UC-122 escrow + milestone release primitives
- UC-124 communication consent + quiet-hours policy primitives

---

## Evolution Roadmap

## Phase 1: Canonical Sellable Backbone (P0)

Objective:
- enforce one consistent sellable identity for services/products/offers/resource-time.

Changes:
- Introduce `sellables` root table (or enforce `products` as canonical sellable root) with:
  - `id`, `biz_id`, `kind`, `status`, `display_name`, `currency`, `metadata`.
- Require typed mapping tables:
  - `sellable_products` -> `products`
  - `sellable_service_products` -> `service_products`
  - `sellable_offer_versions` -> `offer_versions`
  - `sellable_resource_rates` -> resource-time/rental rate cards
- Keep `booking_order_line_sellables` as the commercial attribution bridge but point to `sellable_id` as primary foreign key.

Acceptance criteria:
- Every monetizable line can be resolved to exactly one `sellable_id`.
- Top-seller queries no longer depend on type-specific unions.

---

## Phase 2: Unified Money + Reporting Facts (P0)

Objective:
- make finance and analytics cross-domain by default.

Changes:
- Add normalized financial event/fact layer:
  - `financial_events` (typed immutable postings for charge/refund/fee/commission/credit/dispute impact)
  - `financial_event_allocations` (allocate to order line, sellable, resource, location, host, channel).
- Add reporting views/materialized views:
  - `fact_revenue_daily_by_sellable`
  - `fact_margin_daily_by_sellable`
  - `fact_revenue_monthly_by_location`
  - `fact_resource_utilization_daily`
- Include timezone-safe business date columns for aggregation consistency.

Acceptance criteria:
- “How much did we make last month?” and “Top-selling product/service?” use one fact source.
- No domain-specific revenue query needed for each module.

---

## Phase 3: Coverage Gap Modules (P1)

### 3A. Gift + Credit Instruments (UC-115)
- `gift_instruments`
- `gift_redemptions`
- `gift_transfers`
- `gift_expiration_events`

### 3B. Consent + Waiver (UC-116)
- `consent_templates` (versioned)
- `consent_requirements` (attached to sellable/service/location)
- `signed_consents` (signer, timestamp, evidence ref)

### 3C. Group Payment Obligations (UC-117)
- `booking_participant_obligations`
- `participant_payment_events`
- `obligation_states` (pending/partial/paid/defaulted)

### 3D. B2B AR / PO Terms (UC-118)
- `billing_accounts`
- `purchase_orders`
- `accounts_receivable_invoices`
- `invoice_events` (issued/partially_paid/overdue/written_off)

### 3E. SLA + Compensation (UC-119)
- `sla_policies`
- `sla_breach_events`
- `sla_compensation_rules`
- `sla_compensation_events`

### 3F. FX + Tax (UC-120)
- `fx_rate_snapshots`
- `tax_profiles`
- `tax_calculations`
- `tax_jurisdiction_rules`

### 3G. Escrow + Milestones (UC-122)
- `escrow_accounts`
- `escrow_movements`
- `milestone_contracts`
- `milestone_releases`

### 3H. Communication Consent (UC-124)
- `communication_consents`
- `quiet_hour_policies`
- `delivery_policy_overrides`

Acceptance criteria:
- UC-115..124 move from mostly `Partial` to `Strong/Full`.

---

## Phase 4: Interoperability Hardening (P1)

Objective:
- ensure common operations behave uniformly across all sellable kinds.

Changes:
- Introduce one normalized adjustment contract:
  - `commercial_adjustments` for refund/credit/penalty/waiver with typed reason codes.
- Introduce one normalized cancellation contract:
  - `cancellation_events` linked to orders, lines, fulfillment units, and financial adjustments.
- Introduce one normalized return/claim contract:
  - unify rental damage + physical return + service dispute linkage where possible.

Acceptance criteria:
- Cancellation/refund/credit behavior becomes consistent for service, rental, and product lines.

---

## Phase 5: Governance + Operational Reliability (P2)

Changes:
- Offline operation journal + reconciliation conflicts.
- Cross-domain idempotency registry (`idempotency_keys`, deterministic response hashes).
- Policy snapshot versioning for all critical booking/commerce decisions.
- Event outbox consistency checks for integration reliability.

Acceptance criteria:
- Deterministic retries and safer outage recovery in all channels.

---

## Query Outcomes This Plan Guarantees

After Phase 1 + 2:
- Revenue last month by biz/location/channel/sellable.
- Top-selling sellables across services + products in one list.
- Gross margin and contribution by sellable.
- Utilization and yield by resource and schedule window.

After Phase 3:
- Accurate gift, consent, PO/invoice, SLA, tax/FX, escrow, and consent-compliant communication reporting.

---

## Implementation Order (Recommended)

1. Phase 1 (sellable backbone)
2. Phase 2 (financial/reporting facts)
3. Phase 3C + 3D (participant obligations + B2B AR) for immediate business impact
4. Phase 3A + 3E + 3F (gift + SLA + FX/tax)
5. Phase 3B + 3H (consent and communications compliance)
6. Phase 3G (escrow milestones)
7. Phase 4 + 5 hardening

---

## Non-Goals for This Plan

- UI design specifics (wizard vs advanced builder UX details)
- Algorithmic optimization internals (pricing, ranking, routing engines)
- Provider-specific connector implementation details

Those should consume these schema primitives, not replace them.
