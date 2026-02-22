---
date: 2026-02-21
tags:
  - schema
  - guide
  - definitive
  - healthcare
  - hipaa
  - compliance
  - v0
---

# Definitive Guide: Regulated Healthcare Setup (v0)

Source links:
- Base guide: [[booking-schema-definitive-guide-v0-eli5]]
- Use cases: [[booking-use-cases-v3]]
- Coverage: [[booking-schema-v0-coverage-report]]

---

## 0) Latest Schema Notes (2026-02-21)

- Coverage rerun remains complete (`257/257` UC lines mapped), with totals `#full = 144`, `#strong = 113`.
- Shared contact + endpoint identity (`crm_contacts`, `crm_contact_channels`) improves clinical communication and intake consistency while staying compatible with governance/audit controls.
- Quote acceptance actor normalization to contact/subject anchors improves legal traceability without hardcoding user/group shapes per regulated workflow.

---

## 1) Who This Is For

Use this setup for:
- clinics and regulated care operations,
- provider/room/equipment constraints,
- payer preauth/eligibility checks,
- HIPAA-grade access and disclosure controls.

ELI5:
Deliver care and prove that every sensitive action was safe and justified.

---

## 2) Core Backbone

1. Care selling + execution
- `services`, `service_products`, `offers`, `offer_versions`.
- `booking_orders`, `booking_order_lines`.
- `fulfillment_units`, `fulfillment_assignments`, `fulfillment_checkpoints`.

2. Clinical scheduling integrity
- `resources` + capability selectors.
- `calendars`, `calendar_bindings`, `availability_rules`, capacity/holds.

3. Payer/eligibility control
- `payer_authorizations`
- `eligibility_snapshots`

4. HIPAA/governance control plane
- `phi_access_policies`, `phi_access_events`
- `hipaa_authorizations`
- `phi_disclosure_events`
- `break_glass_reviews`
- `business_associate_agreements`
- `security_incidents`, `breach_notifications`

5. Policy and remediation
- `policy_templates`, `policy_rules`, `policy_bindings`
- `policy_breach_events`, `policy_consequence_events`

---

## 3) Setup Playbook

1. Publish care flows with constrained selectors
- define what roles/resources are required per service product.

2. Gate sensitive bookings with workflow
- pre-checks and review queues before irreversible steps.

3. Capture payer snapshots at decision moments
- do not overwrite old eligibility/preauth decisions.

4. Enforce minimum-necessary access
- evaluate policy, then log every PHI access event.

5. Handle emergency access explicitly
- break-glass reason + post-review row required.

6. Keep disclosure accounting complete
- every disclosure should be in `phi_disclosure_events` with purpose/legal context.

---

## 4) High-Value Patterns

- Provider + room + equipment coupling through requirement selectors.
- Consent and intake forms through interaction + signature artifacts.
- Incident/breach workflows with retained evidence and timelines.
- Policy violations tied to explicit consequence events.

---

## 5) Common Mistakes

- Using app logs instead of PHI access/disclosure ledgers.
- Replacing payer decisions instead of storing snapshots.
- Modeling emergency access without post-review record.
- Mixing compliance evidence with mutable business notes.

---

## 6) Health Checklist

- Every PHI access has policy and actor context.
- Every break-glass event has review outcome.
- Every payer-sensitive booking has snapshot lineage.
- Every breach or incident has lifecycle records.
