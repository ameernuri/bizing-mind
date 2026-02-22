---
date: 2026-02-21
tags:
  - schema
  - guide
  - definitive
  - field-service
  - dispatch
  - maintenance
  - v0
---

# Definitive Guide: Field Service + Dispatch Setup (v0)

Source links:
- Base guide: [[booking-schema-definitive-guide-v0-eli5]]
- Use cases: [[booking-use-cases-v3]]
- Coverage: [[booking-schema-v0-coverage-report]]

---

## 0) Latest Schema Notes (2026-02-21)

- Coverage rerun remains complete (`257/257` UC lines mapped), with totals `#full = 144`, `#strong = 113`.
- Customer/contact handling is now more reusable through `crm_contacts` + `crm_contact_channels`, which helps field-service intake and communication stay consistent with CRM and quote flows.
- Active anchor uniqueness for participant/membership models is now null-safe via split partial unique indexes (contact vs subject paths).

---

## 1) Who This Is For

Use this setup for:
- mobile operations (plumbing, HVAC, inspections),
- routing + ETA + on-site evidence,
- mandatory callout/arrival fees,
- parts + inventory + post-visit settlement.

ELI5:
Get the right person, with the right equipment, to the right place, with full money trace.

---

## 2) Core Backbone

1. Commercial contract
- `booking_orders`, `booking_order_lines`, `booking_order_line_sellables`.

2. Executable work
- `fulfillment_units`, `fulfillment_assignments`, `fulfillment_checkpoints`.

3. Dispatch + transport
- `transport_routes`, `transport_trips`, `transport_route_stops`.
- `dispatch_tasks`, `eta_events`, `fleet_vehicles`, `trip_manifests`.

4. Resource readiness
- `resources` (status/capacity/buffers as source of operational truth).
- `resource_maintenance_policies`, `resource_maintenance_work_orders`, `resource_condition_reports`.

5. Parts + physical delivery
- `inventory_items`, `inventory_reservations`, `inventory_movements`.
- `physical_fulfillments`, `physical_fulfillment_items`.

---

## 3) Setup Playbook

1. Publish services/offers
- define service intent in `services` + `service_products` + `offers`.

2. Bind availability
- use `calendars` + `calendar_bindings` + `availability_rules`.
- add buffers and dependency rules for realistic travel/turnover.

3. Dispatch with checkpoints
- assign fulfillment to resource(s).
- emit checkpoints for depart/arrive/start/complete.

4. Apply call fees cleanly
- represent callout/arrival fees as explicit order lines.
- settle via split-tender payment model (`payment_intent_tenders`, `payment_transactions`).

5. Close with evidence
- attach photos/signatures/notes via work + interaction domains.
- reconcile inventory movements to final commercial lines.

---

## 4) High-Value Patterns

- Host availability depends on front desk/support: model with availability dependency rules.
- Emergency hours pricing: use pricing overrides + fee lines.
- Maintenance lockouts: set resource status and let scheduling enforce availability impact.
- Queue + slot together: both can exist on same offer path using shared capacity and calendar state.

---

## 5) Common Mistakes

- Treating dispatch as UI-only state.
- Hiding fees in metadata instead of order lines.
- Scheduling assets/hosts without checking resource maintenance state.
- Skipping checkpoint evidence for field compliance.

---

## 6) Health Checklist

- Every visit has a fulfillment assignment timeline.
- Every fee is visible as a line and linked to payment flow.
- Every part consumed has inventory movement history.
- Every on-site outcome has evidence artifacts.
