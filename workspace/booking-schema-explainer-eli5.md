---
date: 2026-02-18
tags:
  - schema
  - explainer
  - eli5
  - bookings
  - stripe
---

# Bizing Booking Schema Explainer (Like You're 5, But Complete)

## Tiny Summary First
Think of the database like a big, super-organized city.

- `organizations` is each city.
- `users` and `households` are people and families/teams living in the city.
- `services`, `assets`, `venues`, and `bookables` are things you can book.
- `calendars` and availability tables are the city clocks and opening hours.
- `bookings` is the actual promise: "we will do this service at this time for this person."
- `pricing_rules` and `fee_policies` decide how much it costs.
- `orders`, `payment_*`, and `stripe_*` make money movement real and traceable.
- `operations` tables keep things safe, auditable, and retryable.

This structure supports very simple bookings and very complex workflows without changing the core model.

---

## The Big Story (Simple Words)
Imagine a parent booking a plumber.

1. We know which business this belongs to (`organizations`).
2. We know who requested it (`users` or `households`).
3. We know what was requested (`services`).
4. We know when/where it can happen (`calendars`, availability, location).
5. We apply pricing and special fees (like call-out arrival fee) (`pricing_rules`, `fee_policies`).
6. We create the booking contract (`bookings`).
7. We create bill/payment records (`orders`, `payment_intents`, `payment_transactions`).
8. Stripe records are mirrored (`stripe_*`) so webhooks and reconciliation are easy.
9. Every important event is tracked (`audit_events`, `booking_events`, `outbox_events`).

That is the whole engine.

---

## Main Neighborhoods in the Schema

## 1) Identity + Tenant Boundary
These tables answer: "Who owns this data?" and "Who is acting?"

- `organizations`: one tenant/business root. Almost every row in the system points to an `org_id`.
- `users`: people profiles in booking domain. Linked to Better Auth via `better_auth_user_id`.
- `org_memberships`: role/scope inside each org (owner/admin/staff/provider/customer).
- `org_membership_locations`: optional per-location scope.
- `households`: shared identity container (family or company team).
- `household_members`: delegation model (book for child, team manager books for employee, etc).

Why this matters:
- Clean multi-tenant isolation.
- Better Auth can evolve separately while booking domain stays stable.
- Family/group/team flows are first-class, not hacked in later.

---

## 2) What Can Be Booked (Catalog + Resources)
These tables define the "things" and "offerings".

- `services`: core service templates (duration rules, policy JSON, base price anchor).
- `products`: add-ons / non-service sellables.
- `assets`: equipment/inventory resources.
- `asset_categories`, `asset_tags`: taxonomy + operational labels.
- `venues`: spaces/rooms/halls.
- `bookables`: polymorphic booking resource record that can point to:
  - provider user
  - company provider household
  - asset
  - venue
- `provider_profiles` and `company_provider_profiles`: specialized provider metadata.

Why `bookables` exists:
- One assignment model regardless of resource type.
- Same scheduling and conflict logic can work for people, spaces, and equipment.

---

## 3) Time and Availability
These tables decide if a booking can happen.

- `calendars`: schedule containers.
- `availability_rules`: repeating weekly patterns.
- `availability_exceptions`: one-off date exceptions.
- `blocked_times`: precise hard blocks.

Flow:
- Start with weekly rule.
- Apply exceptions.
- Apply blocked windows.
- Return valid slots.

This allows easy setup and still supports advanced operational controls.

---

## 4) Pricing, Fees, and Holidays
These tables decide price and extra fees.

- `pricing_rules`: manual pricing logic by day/time/date/holiday with priority and stacking behavior.
- `fee_policies`: fee definitions (call fee, after-hours, emergency, no-show, late cancel, etc).
- `holiday_calendars`: holiday knowledge consumed by pricing and scheduling.

Important concept:
- Rules are definitions.
- Applied results are materialized on the booking (`booking_fees`) and booking money columns.

Call fee example:
- Policy says: if technician arrives, charge an on-site call-out fee.
- Booking event records arrival.
- Fee is materialized into `booking_fees`.
- Order/payment includes it even if main service is declined.

---

## 5) The Core Contract: `bookings`
`bookings` is the center of everything.

It stores:
- who (`customer_id`, `household_id`, `booked_by_user_id`)
- what (`service_id`, optional direct asset/venue)
- when (`start_time`, `end_time`, timezone)
- state (`status`, `payment_status`)
- money snapshots (subtotal, fees, discounts, tax, total, paid/refunded/balance)
- lifecycle timestamps (arrived, checked-in, completed, canceled, no-show)

Attached booking sub-ledgers:
- `booking_participants`: group attendees.
- `booking_assignments`: provider/resource assignments.
- `booking_segments`: multi-leg bookings (virtual + in-person).
- `booking_notes`: timeline notes.
- `booking_fees`: applied fee records.
- `booking_events`: booking-specific domain event log.
- `booking_transfers`: transfer ownership flow.
- `booking_followups`: linked downstream required sessions.

Why this is strong:
- Simple booking needs only a small subset of columns.
- Complex scenarios can be layered without changing the core table contract.

---

## 6) Booking Flow Control (Before Confirmation)
These tables manage concurrency and advanced slot behavior.

- `reservations`: temporary holds while checkout is in progress.
- `waitlist_entries`: queue or race waitlist behaviors.
- `recurring_booking_rules`: recurrence templates.
- `recurring_booking_occurrences`: materialized instances.

Why this matters:
- Prevents race conditions around popular slots.
- Supports waitlist offer windows and automatic conversion.
- Supports repeating schedules without duplicating logic everywhere.

---

## 7) Programs, Packages, Memberships
These tables support advanced business models.

Programs:
- `programs`, `program_sessions`, `program_enrollments`, `program_attendance`

Packages:
- `packages`, `package_items`, `package_wallets`, `package_ledger_entries`

Memberships:
- `memberships`, `membership_subscriptions`, `membership_usage_entries`

Why this matters:
- Same booking engine can power classes, prepaid bundles, and recurring plans.
- Entitlement usage remains auditable and linked to bookings.

---

## 8) Commerce and Money (Provider-Agnostic Core)
Money model is layered and explicit.

- `orders`: commercial root record.
- `order_items`: line items (service/product/fee/etc).
- `payment_intents`: payment orchestration state.
- `payment_transactions`: auth/capture/refund events.
- `payment_allocations`: split-tender and component allocation.
- `payment_disputes`: chargeback/dispute lifecycle.

Why this separation is useful:
- Booking status and payment status can evolve independently.
- Easy reconciliation and reporting.
- Future provider changes are possible without rewriting business logic.

---

## 9) Stripe Layer (Provider Mirror)
The `stripe_*` tables mirror key Stripe entities for local reliability.

- `stripe_accounts`: Connect account state.
- `stripe_customers`: local identity -> Stripe customer mapping.
- `stripe_payment_methods`: safe PM metadata cache.
- `stripe_setup_intents`: save-payment flow tracking.
- `stripe_checkout_sessions`: hosted checkout tracking.
- `stripe_invoices`: invoice mirrors.
- `stripe_webhook_events`: idempotent webhook intake + processing status.
- `stripe_payouts`: payout tracking.
- `stripe_transfers`: split transfer tracking.

Why mirror at all:
- Fast API reads.
- Better webhook dedupe/replay safety.
- Easier operations/debugging/reconciliation.

---

## 10) Reliability, Compliance, and Integrations
These tables keep system behavior deterministic and auditable.

- `idempotency_keys`: safe retries for create/update commands.
- `audit_events`: immutable compliance timeline.
- `outbox_events`: reliable async event delivery.
- `consent_records`: legal/e-sign proof.
- `incident_batches`, `incident_booking_actions`: mass rescheduling workflows.
- `external_channels`, `external_sync_events`: partner/channel sync logs.

This is what makes production systems trustworthy under failures and retries.

---

## How a Simple Booking Works (Minimal Path)
If a business only wants simple booking UI, this path is enough:

1. Create org and user.
2. Create service.
3. Create calendar and basic availability rule.
4. Customer chooses slot.
5. Create booking.
6. Create order/payment intent if payment required.

No need to use:
- waitlist
- recurring
- memberships
- packages
- complex assignment

So simple UX is truly possible.

---

## How a Complex Booking Works (Advanced Path)
A fully advanced path can include:

1. Household-based booking for a dependent.
2. Company-provider dispatch assignment.
3. Reservation hold + waitlist race offer.
4. Day/time holiday pricing and manual call fee policy.
5. Multi-segment booking and follow-up requirements.
6. Split payment allocations and dispute handling.
7. Stripe webhook-driven state reconciliation.
8. Outbox events to notify partner systems.

Same schema, no redesign required.

---

## Why This Schema Is Maintainable

- Clear domain boundaries by file and table grouping.
- `org_id` everywhere for safe multi-tenant operations.
- Central enums prevent state drift.
- Core payment model is provider-agnostic, Stripe is layered on top.
- JSON fields exist where flexibility is needed, but core joins are normalized.
- Rich comments at table/column level explain intent, not just structure.

---

## Quick "Where Do I Edit?" Guide

- New booking status/state machine changes: `schema/enums.ts`, `schema/bookings.ts`
- New pricing/fee behavior: `schema/pricing.ts`, then materialization to `booking_fees`
- New payment provider metadata: `schema/payments.ts` and/or provider mirror file
- Better Auth relationship changes: `schema/users.ts`, `schema/organizations.ts`, `schema/memberships.ts`
- Slot/availability logic: `schema/scheduling.ts`, `schema/booking_flows.ts`
- Stripe webhook behavior/persistence: `schema/stripe.ts`, `schema/operations.ts`

---

## Mental Model to Remember
`organizations` owns everything.

`bookings` is the center contract.

`orders` and `payments` settle money.

`stripe_*` mirrors provider truth.

`operations` guarantees reliability.

If you remember those five lines, the whole schema stays understandable.
