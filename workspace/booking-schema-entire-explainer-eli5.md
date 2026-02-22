---
date: 2026-02-20
tags:
  - schema
  - explainer
  - eli5
  - exhaustive
  - bookings
  - bizing
  - v0
---

# Bizing Schema Master Explainer (ELI5 + Consolidated v0)

Source files reviewed:
- `/Users/ameer/projects/bizing/packages/db/src/index.ts`
- `/Users/ameer/projects/bizing/packages/db/src/schema/canonical.ts`
- `/Users/ameer/projects/bizing/packages/db/src/schema/*.ts`
- `[[booking-use-cases-v3]]`

## 0) Read This First

This explainer now reflects the **single consolidated v0 schema**.

In plain words:
- There is one active Drizzle registry in `/Users/ameer/projects/bizing/packages/db/src/index.ts`.
- It combines:
1. Shared core tables from `/Users/ameer/projects/bizing/packages/db/src/schema/*`
2. Canonical booking domains from `/Users/ameer/projects/bizing/packages/db/src/schema/*`

There are no active legacy schema modules anymore.

## 1) ELI5 Mental Model

Imagine one big city:
- A `biz` is one city.
- `users` are people.
- `resources` are workers/rooms/tools/vehicles.
- `services` are what a biz can do.
- `service_products` and `offers` are what the biz packages and sells.
- `calendars` + `availability_rules` decide when things can happen.
- `booking_orders` + `fulfillment_units` are the plan and the real execution steps.
- `payment_*` tables record money movement.
- `audit_*` tables keep a permanent history trail.

Core question this schema answers:
**"Can this exact offering be fulfilled at this exact time, with these exact resources, and can we prove what happened and what was charged?"**

## 2) Global Design Rules (Why It Stays Scalable)

### 2.1 Tenant isolation is first-class
Most domain tables include `biz_id`.
- This keeps each business isolated.
- It prevents accidental cross-biz data leaks.

### 2.2 Composite foreign keys enforce same-biz relationships
Many domain FKs are `(biz_id, child_ref_id) -> (biz_id, parent.id)`.
- A row can reference only records from the same biz.
- This protects integrity at the database level, not just API logic.

### 2.3 Polymorphic tables use strict shape checks
When one row can point to multiple target kinds, `check(...)` constraints enforce exact valid shapes.
- No ambiguous partial rows.
- Deterministic read behavior.

### 2.4 Ledger/event style where history matters
Money, queue transitions, and audits are modeled append-first.
- Better traceability.
- Better forensic/debug capability.

### 2.5 Shared column helpers keep schema consistent
`/Users/ameer/projects/bizing/packages/db/src/schema/_common.ts` provides reusable helpers for:
- timestamps
- audit fields
- soft-deletes (where needed)
- tagged ULID IDs via `generateId(...)`

## 3) Active Schema Layout (What Is Actually Wired)

The active Drizzle `schema` object is composed in `/Users/ameer/projects/bizing/packages/db/src/index.ts` as:
1. `schemaCore` (shared core)
2. canonical domain modules from `/Users/ameer/projects/bizing/packages/db/src/schema/canonical.ts`

That means this is one merged runtime model, not two competing models.

## 4) Shared Core Layer (Identity + Catalog Foundations)

These are active foundation tables used by many higher domains.

### 4.1 Tenant and identity
- `bizes`
- `users`
- Better Auth tables in `auth.ts`: `sessions`, `accounts`, `verifications`, `members`, `invitations`

Why this exists:
- identity and org membership are reused everywhere
- auth concerns stay centralized in db schema

### 4.2 Org scope and shared-account identity
- `org_memberships`, `org_membership_locations`
- `group_accounts`, `group_account_members`

Why this exists:
- supports individual, team, family, and company-style booking identities
- lets one person act in multiple scopes

### 4.3 Physical/people resources and metadata templates
- Assets: `asset_categories`, `asset_status_definitions`, `assets`, `asset_tag_templates`, `asset_tag_assignments`, `asset_status_definition_tag_scopes`
- Venues: `venue_categories`, `venue_status_definitions`, `venues`, `venue_tag_templates`, `venue_tag_assignments`, `venue_amenity_templates`, `venue_amenity_assignments`
- Unified resources: `resource_status_definitions`, `resources`, `host_users`, `host_groups`, `host_group_members`, `resource_service_capabilities`, `resource_capability_templates`, `resource_capability_assignments`

Why this exists:
- gives one normalized supply graph
- supports selecting by individual resource, category, or template/tag

### 4.4 Service and sellable product foundations
- Services: `service_groups`, `services`
- Service products: `service_products`, `service_product_requirement_groups`, `service_product_services`, `service_product_requirement_selectors`, `service_product_seat_types`, `service_product_seat_type_requirements`
- Generic rollout map (shared across many domains): `subject_location_bindings`
- Non-time sellables: `products`

Why this exists:
- separates raw capability (`services`) from packaged commercial products (`service_products` / `offers`)
- supports variants, seat types, and requirement composition

### 4.5 Stripe integration anchors
- `stripe_accounts`, `stripe_customers`, `stripe_payment_methods`, `stripe_setup_intents`, `stripe_checkout_sessions`, `stripe_invoices`, `stripe_webhook_events`, `stripe_payouts`, `stripe_transfers`

Why this exists:
- stable integration bridge to Stripe entities and sync lifecycle
- commercial linkage now points to canonical entities (`booking_order_id` / `cross_biz_order_id`)

## 5) Canonical Domain Modules (Business Engine)

## 5.1 Offers domain (`offers.ts`)
Main tables:
- `offers`
- `offer_versions`
- `subject_location_bindings` (`subject_type='offer_version'`)
- `offer_components`
- `offer_component_selectors`
- `offer_component_seat_types`

Purpose:
- publishable, versioned commercial definition
- explicit component requirements and seat/class behavior

ELI5:
- `offer` = product name card
- `offer_version` = frozen recipe at a point in time
- components/selectors = what resources can satisfy each part

## 5.2 Supply operations domain (`supply.ts`)
Main tables:
- `resource_capability_templates`
- `resource_capability_assignments`
- `resource_usage_counters`
- `resource_maintenance_policies`
- `resource_maintenance_work_orders`
- `resource_condition_reports`

Purpose:
- capability matching + maintenance lifecycle + condition evidence

## 5.3 Time and availability domain (`time_availability.ts`)
Main tables:
- `calendars`
- `calendar_bindings`
- `calendar_overlays`
- `availability_rules`
- `capacity_pools`
- `capacity_pool_members`
- `availability_resolution_runs`

Purpose:
- one calendar engine for resources/services/offers/queues/trips
- layered overrides and explainable resolution logs

ELI5:
- calendar = notebook of time
- overlays = extra transparent sheets on top
- rules = open/close/special behavior
- resolution runs = "show me exactly why this slot is or is not available"

## 5.4 Fulfillment domain (`fulfillment.ts`)
Main tables:
- `booking_orders`
- `booking_order_lines`
- `fulfillment_units`
- `fulfillment_dependencies`
- `fulfillment_assignments`
- `fulfillment_checkpoints`

Purpose:
- separates commercial contract from execution graph
- supports single-step and multi-step jobs equally well

## 5.5 Payments domain (`payments.ts`)
Main tables:
- `payment_methods`
- `payment_intents`
- `payment_intent_tenders`
- `payment_transactions`
- `payment_disputes`
- `settlement_batches`
- `settlement_entries`
- `payouts`
- `payout_ledger_entries`

Purpose:
- split tender, disputes, settlement, payout ledgers, auditability

## 5.6 Entitlements domain (`entitlements.ts`)
Main tables:
- `membership_plans`
- `memberships`
- `entitlement_wallets`
- `entitlement_grants`
- `entitlement_transfers`
- `entitlement_ledger_entries`
- `rollover_runs`

Purpose:
- memberships, credits/passes, rollover/expiry/transfer primitives

## 5.7 Channel integration domain (`channels.ts`)
Main tables:
- `channel_accounts`
- `channel_sync_states`
- `channel_entity_links`
- `channel_sync_jobs`
- `channel_sync_items`
- `channel_webhook_events`

Purpose:
- connectors + sync state + external ID mapping + ingestion jobs/events

## 5.8 Operational intelligence domain (`intelligence.ts`)
Main tables:
- `ranking_profiles`, `ranking_scores`, `ranking_events`
- `overtime_policies`, `overtime_forecasts`
- `substitution_pools`, `substitution_pool_members`, `substitution_requests`, `substitution_offers`, `substitution_fairness_counters`

Purpose:
- ranking/favorability, overtime prediction, substitution fairness

## 5.9 Education/program domain (`education.ts`)
Main tables:
- `programs`
- `program_cohorts`
- `program_cohort_sessions`
- `cohort_enrollments`
- `session_attendance_records`
- `certification_templates`
- `certification_awards`

Purpose:
- cohorts, attendance, completion/certification outcomes

## 5.10 Immutable audit domain (`audit.ts`)
Main tables:
- `audit_streams`
- `audit_events`
- `audit_integrity_runs`

Purpose:
- durable event history beyond row-level audit columns
- integrity verification runs for tamper detection workflows

## 5.11 Notes and annotation domain (`notes.ts`)
Main tables:
- `notes`
- `note_revisions`
- `note_access_overrides`

Purpose:
- flexible notes with visibility classes (public/private/AI/system)
- revision history + override access controls

## 5.12 Queue domain (`queue.ts`)
Main tables:
- `queues`
- `queue_entries`
- `queue_tickets`
- `queue_events`
- `service_time_observations`
- `wait_time_predictions`

Purpose:
- waitlist/queue operations + observed/predicted wait-time intelligence

## 5.13 Transportation domain (`transportation.ts`)
Main tables:
- `fleet_vehicles`
- `transport_routes`
- `transport_route_stops`
- `transport_trips`
- `trip_stop_inventory`
- `trip_manifests`
- `dispatch_tasks`
- `eta_events`

Purpose:
- routes/trips/dispatch/ETA and stop-level inventory handling

## 5.14 Marketplace + cross-biz domain (`marketplace.ts`)
Main tables:
- `marketplace_listings`
- `auctions`
- `bids`
- `cross_biz_contracts`
- `cross_biz_orders`
- `revenue_share_rules`
- `referral_programs`
- `referral_events`
- `reward_grants`

Purpose:
- multi-biz supply exchange, contracting, revenue share, referrals

## 5.15 Compliance/privacy/residency domain (`governance.ts`)
Main tables:
- `tenant_compliance_profiles`
- `data_residency_policies`
- `retention_policies`
- `legal_holds`
- `privacy_identity_modes`
- `data_subject_requests`
- `redaction_jobs`

Purpose (ELI5):
- defines legal rules for where data can live, how long it stays, and when deletion must pause
- tracks privacy requests (like "show my data" / "delete my data")
- orchestrates redaction operations safely

## 5.16 Async/jobs/review workflows (`workflows.ts`)
Main tables:
- `review_queues`
- `review_queue_items`
- `workflow_instances`
- `workflow_steps`
- `workflow_decisions`
- `async_deliverables`

Purpose:
- human review gates and asynchronous operational workflows

## 6) How Booking Decisions Flow End-to-End

Typical path:
1. Biz defines supply (resources, categories, tags, capabilities).
2. Biz defines services and sellable packaging (service products/offers/versions).
3. Time domain resolves availability (calendars + overlays + rules + capacity pools).
4. Customer selects an offer.
5. System creates `booking_orders` + `booking_order_lines`.
6. Execution graph is built as `fulfillment_units` + dependencies.
7. Assignments link actual resources.
8. Payments run through intents/tenders/transactions/settlements.
9. Audit, notes, and workflow domains capture explanation, exceptions, and review.

## 7) What This Consolidated Model Is Strong At

- Supports both simple bookings and highly composable multi-resource offers.
- Keeps time resolution explainable (not black-box).
- Handles split payments, disputes, payouts, and ledgers natively.
- Handles memberships/credits/rollovers as first-class primitives.
- Supports connectors and external synchronization lifecycle.
- Provides governance/privacy/legal-hold foundations in schema, not as ad-hoc code.

## 8) Relationship Between Use Cases and Schema

Primary source:
- `[[booking-use-cases-v3]]`

High-level mapping:
- Offer design + productization use cases -> `offers`, `service_products`, `services`
- Resource matching and constraints -> `resources`, `supply`, selector tables
- Availability/holiday/surge/manual overrides -> `time_availability`
- Booking execution and multi-step flows -> `fulfillment`
- Payment complexity (split/dispute/settlement) -> `payments`
- Membership/credits passes -> `entitlements`
- Queue/waitlist behavior -> `queue`
- Dispatch/transport operations -> `transportation`
- Cross-biz marketplace scenarios -> `marketplace`
- Compliance/privacy/residency/legal hold -> `governance`
- Async/manual review workflows -> `workflows`

## 9) Practical Clarification

Canonical v0 design is now the only schema model in active use.

Legacy modules were removed from `packages/db/src/schema`:
- `bookings.ts`
- `booking_flows.ts`
- `commerce.ts`
- `offerings.ts`
- `operations.ts`
- `pricing.ts`
- `scheduling.ts`

For API design and implementation, build against:
- `index.ts` exports from `/Users/ameer/projects/bizing/packages/db/src/index.ts`
- canonical domain barrel `/Users/ameer/projects/bizing/packages/db/src/schema/canonical.ts`

## 10) Glossary (ELI5)

- `resource`: A thing that can do work or be reserved (person/place/asset/group).
- `service`: A capability or business activity.
- `service_product`: A packaged sellable form of service composition.
- `offer`: A publishable commercial definition with version snapshots.
- `calendar`: Time container with rules for availability behavior.
- `fulfillment_unit`: One executable step in delivering what was sold.
- `entitlement_wallet`: A balance container for credits/uses.
- `audit_event`: Immutable record proving an action happened.

---

If you want, next I can generate a second file that is purely visual (Mermaid-only), with one diagram per domain plus one cross-domain sequence diagram.
