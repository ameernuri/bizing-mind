---
date: 2026-02-21
tags:
  - schema
  - guide
  - definitive
  - marketplace
  - gig
  - staffing
  - v0
---

# Definitive Guide: Marketplace + Gig Network Setup (v0)

Source links:
- Base guide: [[booking-schema-definitive-guide-v0-eli5]]
- Use cases: [[booking-use-cases-v3]]
- Coverage: [[booking-schema-v0-coverage-report]]

---

## 0) Latest Schema Notes (2026-02-21)

- Coverage rerun remains complete (`257/257` UC lines mapped), with totals `#full = 144`, `#strong = 113`.
- Marketplace participants and customer/worker profiles now align better with the shared contact backbone (`crm_contacts`, `crm_contact_channels`) for cross-domain identity reuse.
- Anchor-based uniqueness hardening for conversation/audience models improves duplicate-prevention when members are represented by mixed contact/subject identities.

---

## 1) Who This Is For

Use this setup for:
- open shifts and replacement staffing,
- claim/invite/bid assignment models,
- worker portability across bizes,
- fair ranking and payout traceability.

ELI5:
Post work, find qualified people, pick fairly, pay transparently.

---

## 2) Core Backbone

1. Demand + responses
- `staffing_demands`, `staffing_demand_selectors`.
- `staffing_responses`, `staffing_assignments`.

2. Cross-domain assignment board
- `operational_demands`, `operational_assignments`.

3. Marketplace commerce
- `marketplace_listings`, `auctions`, `bids`.
- `cross_biz_contracts`, `cross_biz_orders`.

4. Trust + qualification
- `resource_capability_templates`, `resource_capability_assignments`.
- user-owned credential wallet + sharing (`user_credential_*`, `biz_credential_share_*`).

5. Fairness + intelligence
- `staffing_fairness_counters`.
- `ranking_profiles`, `ranking_scores`, `ranking_events`.

6. Money closure
- `payment_*`, settlements/payouts, `compensation_*`.

---

## 3) Setup Playbook

1. Model demand type clearly
- replacement, open shift, auctioned task, invited candidate, etc.

2. Use selector constraints
- required capabilities, location, time windows, credentials.

3. Keep decisions explainable
- store score/rule context in metadata and workflow decisions.

4. Tie assignment to execution
- assignment should map to fulfillment/work timeline.

5. Tie execution to payout
- work evidence -> compensation/payment ledgers.

---

## 4) High-Value Patterns

- External candidate can prove credentials once and share selectively with many bizes.
- Biz can post internal openings and external openings through same demand primitive.
- FCFS and auction models can coexist if demand types and policies are explicit.
- Per-biz visibility/privacy is enforceable with share grants + selectors.

---

## 5) Common Mistakes

- Duplicating "replacement" tables instead of demand types.
- Ignoring fairness counters in repeated assignments.
- Paying without assignment/work evidence linkage.
- Using freeform eligibility JSON instead of selector rows.

---

## 6) Health Checklist

- Every demand has explicit selector rows.
- Every accepted response becomes an assignment.
- Every assignment links to execution and payout trails.
- Every credential disclosure is event-logged.
