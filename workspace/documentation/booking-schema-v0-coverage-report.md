---
date: 2026-02-21
tags:
  - schema
  - v0
  - coverage
  - use-cases
  - booking
  - report
---

# Booking Schema v0 Coverage Report (UC-1 .. UC-257)

Source: [[booking-use-cases-v3]]
Schema baseline: current `packages/db/src/schema/*.ts` + canonical export barrel in `/Users/ameer/projects/bizing/packages/db/src/schema/canonical.ts` (including enterprise scope normalization via `enterprise_scopes`, plus `work_management`, `gifts`, `participant_obligations`, `ar`, `sla`, `tax_fx`, `leave`, `offline`, `reporting`, `hipaa`, and `credential_exchange` domains)

## Legend
- #full: first-class schema support exists.
- #strong: schema support is strong; final behavior mainly depends on app/policy execution.
- #partial: core is workable, but one or more schema primitives are still missing or too generic.
- #gap: not realistically implementable without major schema additions.

## Regeneration Snapshot (2026-02-21)
- Re-ran coverage mapping against current canonical schema after composability/identity hardening changes.
- Re-validated UC line coverage: `257/257` use cases mapped.
- Recomputed totals from UC lines: `#full = 144`, `#strong = 113`, `#partial = 0`, `#gap = 0`.
- Net score impact: newly added CRM/quotes/receivables/wishlist/marketing/gift-delivery modules closed all previously-partial UC coverage items.

## Focused Rerun Delta (2026-02-21)
- Location-rollout consolidation: domain-specific joins (`offer_version_locations`, `service_group_locations`, `service_locations`, `service_product_locations`) were replaced by `subject_location_bindings` for a single reusable rollout backbone.
- Capability consolidation: host-only specialty tables (`host_specialty_templates`, `host_user_specialties`) were removed in favor of shared `resource_capability_templates` + `resource_capability_assignments`.
- Selector contract consolidation: offer and service-product selectors now share one selector shape primitive and shared selector enums.
- Resource-wrapper streamlining: `asset_status_definitions` and `venue_status_definitions` were removed, with operational status/capacity/overlap semantics centralized in `resources` and new generic buffer fields (`buffer_before_minutes`, `buffer_after_minutes`).
- Enterprise scope streamlining: repeated `scope_type/scope_key/target_*` payload columns in core enterprise tables were normalized behind `enterprise_scopes` and referenced through `scope_id`.
- Matrix hygiene pass: transport/checklist/dependency references were normalized to live table names (`transport_routes`, `transport_trips`, `transport_route_stops`, `requirement_list_templates`, `requirement_list_assignments`, `availability_dependency_rule_targets`, etc.).
- CRM contact backbone hardening: `crm_contacts` + `crm_contact_channels` are now the reusable identity + endpoint layer across CRM, commerce preference, quote, and audience membership domains.
- Actor-anchor normalization: quote acceptance decision actors now use `crm_contact`/`subject` anchors instead of duplicated user/group column pairs, improving extensibility and cross-domain reuse.
- Null-safe uniqueness hardening: conversation participant and audience membership uniqueness now use split partial indexes per anchor type (contact vs subject), preventing duplicate active rows under PostgreSQL null semantics.
- Coverage impact: no score regression; use-case ratings remain `#full/#strong` with improved schema fungibility and reduced duplication risk.

## Extensive Rerun Validation (2026-02-21)
- Re-validated all UC references: 257/257 UC lines still present and mapped.
- Re-validated rating totals from UC lines: `#full = 144`, `#strong = 113`, `#partial = 0`, `#gap = 0`.
- Reconciled compact matrix table references against live schema table inventory.
- Matrix explicitly distinguishes:
  - live enabling tables already present in schema,
  - where coverage is #strong because policy/runtime logic still matters more than schema shape,
  - deeper insurance mediation normalization still tracked for future expansion.

## Coverage by Use Case

### Part 1 (UC-1 .. UC-9)
- [[booking-use-cases-v3#UC-1: The Solo Consultant (Fixed Duration)|UC-1]] #full - offers + calendars + booking orders + fulfillment directly model this.
- [[booking-use-cases-v3#UC-2: The Solo Consultant (Variable Duration)|UC-2]] #full - duration mode + range fields support variable sessions.
- [[booking-use-cases-v3#UC-3: The Hair Salon with Commission Tracking|UC-3]] #strong - role templates + versioned compensation plans/rules + compensation ledger + pay-run items provide first-class commission/payroll primitives; final pay-stub rendering is app-side.
- [[booking-use-cases-v3#UC-4: The Salon with Provider Favorability/Ranking|UC-4]] #strong - ranking profiles/scores/events are modeled; slot-allocation algorithm remains app logic.
- [[booking-use-cases-v3#UC-5: The Medical Clinic with Room Pairing|UC-5]] #full - resource selectors + assignment constraints cover provider-room pairing.
- [[booking-use-cases-v3#UC-6: The Medical Clinic with Approval Workflow|UC-6]] #full - review queues + workflow instances/decisions cover approval flows.
- [[booking-use-cases-v3#UC-7: The Fitness Class Studio|UC-7]] #strong - seats/capacity/queues are covered; some studio-specific penalty policies are app-side.
- [[booking-use-cases-v3#UC-8: The Tutoring Center with Packages|UC-8]] #strong - entitlements + education + staffing/replacement primitives cover most needs; recurring cohort policy details are app-side.
- [[booking-use-cases-v3#UC-9: The Front Desk Receptionist Calendar|UC-9]] #strong - calendar ownership/bindings are strong; field-level privacy in UI/API is policy-layer.

### Part 2 (UC-10 .. UC-15)
- [[booking-use-cases-v3#UC-10: The Multi-Location Chain|UC-10]] #full - location-scoped offers/resources/services are first-class.
- [[booking-use-cases-v3#UC-11: The Multi-Provider Appointment with Commission Split|UC-11]] #strong - multi-assignment now pairs with normalized compensation role mappings, formula rules, and ledger/pay-run traceability.
- [[booking-use-cases-v3#UC-12: The Equipment-Required Service with Auto-Maintenance|UC-12]] #full - maintenance policies/work orders/counters are first-class.
- [[booking-use-cases-v3#UC-13: The Multi-Day Rental with Gap Management|UC-13]] #strong - duration + dependencies + availability rules cover this well.
- [[booking-use-cases-v3#UC-14: The Corporate Training with Attendance Tracking|UC-14]] #strong - education domain covers cohorts/attendance/certifications; some B2B billing policies are app-side.
- [[booking-use-cases-v3#UC-15: The Mobile Service with Route Optimization|UC-15]] #strong - transport/dispatch/ETA tables exist; optimization engine is app-side.

### Part 3 (UC-16 .. UC-22)
- [[booking-use-cases-v3#UC-16: The Package Deal with Expiration|UC-16]] #strong - wallets/grants/transfers/rollover support package behavior.
- [[booking-use-cases-v3#UC-17: The Dynamic/Surge Pricing|UC-17]] #strong - demand signal definitions/observations plus automated policy, tier, evaluation, and application ledgers are now first-class; real-time optimizer tuning remains app logic.
- [[booking-use-cases-v3#UC-18: The Seat Selection Venue|UC-18]] #full - `seat_maps`, `seat_map_seats`, `seat_holds`, and `seat_reservations` now provide first-class seat geometry, hold windows, and committed allocations.
- [[booking-use-cases-v3#UC-19: The Waitlist with Auto-Offer and Pricing|UC-19]] #strong - queue/event/prediction and payment primitives cover most requirements.
- [[booking-use-cases-v3#UC-20: The First-Confirm-First-Booked Waitlist|UC-20]] #full - queue ticket/entry/event model supports race-style claims.
- [[booking-use-cases-v3#UC-21: The Recurring Subscription with Pause|UC-21]] #strong - memberships + entitlement ledgers support pause/rollover patterns.
- [[booking-use-cases-v3#UC-22: The Tour/Experience with Minimum Viable|UC-22]] #strong - capacity + fulfillment + workflow support this pattern.

### Part 4 (UC-23 .. UC-29)
- [[booking-use-cases-v3#UC-23: The Franchise Chain with Royalty|UC-23]] #full - marketplace cross-biz contracts/orders + revenue share are first-class.
- [[booking-use-cases-v3#UC-24: The Multi-Step Medical Procedure|UC-24]] #full - fulfillment DAG is purpose-built for this.
- [[booking-use-cases-v3#UC-25: The Multi-Resource Event|UC-25]] #full - offer components + fulfillment assignments/dependencies cover this.
- [[booking-use-cases-v3#UC-26: The Union Production with Complex Rules|UC-26]] #full - generic policy templates/rules/bindings plus breach and consequence ledgers now provide first-class normalized rulebook and penalty primitives without union-specific hardcoding.
- [[booking-use-cases-v3#UC-27: The Equipment Sharing Pool|UC-27]] #full - capacity pools + usage/maintenance are first-class.
- [[booking-use-cases-v3#UC-28: The Airline-Style Overbooking|UC-28]] #strong - capacity and forecasting hooks exist; no-show probability model is app-side.
- [[booking-use-cases-v3#UC-29: The Conditional/Rule-Based Booking|UC-29]] #strong - governance/workflow/policy snapshots are strong; domain-specific rule DSL is app-side.

### Part 5 (UC-30 .. UC-35)
- [[booking-use-cases-v3#UC-30: The Standing Reservation|UC-30]] #full - dedicated standing reservation contracts, exceptions, and occurrences are first-class, including pause/resume and generation-window controls.
- [[booking-use-cases-v3#UC-31: The Floating Appointment|UC-31]] #strong - request/assignment flow is well supported.
- [[booking-use-cases-v3#UC-32: The Reverse Auction Marketplace|UC-32]] #strong - listings/auctions/bids are modeled; buyer-intent post templates are app-side.
- [[booking-use-cases-v3#UC-33: The Cascading Appointment|UC-33]] #full - dependency graph directly supports cascades.
- [[booking-use-cases-v3#UC-34: The Multi-Timezone Coordination|UC-34]] #strong - timezone-aware calendars are modeled; fairness scheduling is app logic.
- [[booking-use-cases-v3#UC-35: The Disaster Recovery Mass Reschedule|UC-35]] #strong - workflow + fulfillment graph supports bulk reschedule orchestration.

### Part 6 (UC-36 .. UC-60)
- [[booking-use-cases-v3#UC-36: The Company as Provider|UC-36]] #full - host groups/company-host resources are first-class.
- [[booking-use-cases-v3#UC-37: The Household/Family Account|UC-37]] #full - group accounts and membership primitives support this directly.
- [[booking-use-cases-v3#UC-38: The Product + Service Bundle|UC-38]] #strong - explicit bundle composition now exists (product/service-product/offer components), with line-level sellable attribution and physical fulfillment linkage.
- [[booking-use-cases-v3#UC-39: The Program with Attendance Tracking|UC-39]] #full - education module covers cohorts, attendance, and outcomes.
- [[booking-use-cases-v3#UC-40: The Cascading Availability (Controlled Access)|UC-40]] #strong - overlays/default modes/availability rules model this well.
- [[booking-use-cases-v3#UC-41: The Filler Booking Discount|UC-41]] #strong - discount campaigns/codes/redemptions are first-class, including automatic campaigns; advanced targeting strategy and optimization logic remain app-side.
- [[booking-use-cases-v3#UC-42: The Host Cancellation Penalty|UC-42]] #strong - workflow + payment transactions can enforce penalties.
- [[booking-use-cases-v3#UC-43: The Dynamic Duration with Price Adjustment|UC-43]] #strong - duration flexibility + commercial line items support this.
- [[booking-use-cases-v3#UC-44: The Overtime Prediction and Avoidance|UC-44]] #strong - overtime policies/forecasts are first-class; assignment optimizer is app-side.
- [[booking-use-cases-v3#UC-45: The Service-Specific Availability|UC-45]] #full - service-level calendar ownership is modeled.
- [[booking-use-cases-v3#UC-46: The Available by Default vs Unavailable by Default|UC-46]] #full - default mode is native in calendars.
- [[booking-use-cases-v3#UC-47: The Use-It-Anytime Membership|UC-47]] #full - memberships + wallets + grants + ledgers support this.
- [[booking-use-cases-v3#UC-48: The Auction-Based Booking|UC-48]] #full - auction primitives are modeled.
- [[booking-use-cases-v3#UC-49: The AI Agent Notes|UC-49]] #full - notes/revisions/visibility classes are first-class.
- [[booking-use-cases-v3#UC-50: The Complete Audit Trail|UC-50]] #full - immutable audit event stream is first-class.
- [[booking-use-cases-v3#UC-51: The Multi-Level Organization Booking|UC-51]] #full - biz + marketplace + cross-biz contracts/orders support this.
- [[booking-use-cases-v3#UC-52: The Hybrid Virtual + In-Person|UC-52]] #full - fulfillment units support mixed modality.
- [[booking-use-cases-v3#UC-53: The Virtual Waiting Room|UC-53]] #full - queue model is first-class.
- [[booking-use-cases-v3#UC-54: The Anonymous/Sensitive Booking|UC-54]] #full - governance privacy identity modes + access controls support this.
- [[booking-use-cases-v3#UC-55: The Referral Unlock Reward|UC-55]] #full - referral and reward entities are modeled.
- [[booking-use-cases-v3#UC-56: The Booking Transfer|UC-56]] #full - `fulfillment_transfer_requests` + `fulfillment_transfer_events` now provide explicit transfer contracts, deadlines, decision states, and auditable ownership handoff timeline.
- [[booking-use-cases-v3#UC-57: The Impulse Booking Cooldown|UC-57]] #strong - workflow/review/policy path supports cooldown checks.
- [[booking-use-cases-v3#UC-58: The Seasonal Availability Flip|UC-58]] #full - date-range overlays/rules are native.
- [[booking-use-cases-v3#UC-59: The Simultaneous Multi-Location|UC-59]] #full - multi-unit dependency graph supports atomic coordination.
- [[booking-use-cases-v3#UC-60: The Mandatory Follow-Up Lock|UC-60]] #full - workflow + dependency enforcement supports this.

### Part 7 (UC-61 .. UC-70)
- [[booking-use-cases-v3#UC-61: The Insurance Eligibility Re-Check|UC-61]] #strong - `payer_authorizations` + `eligibility_snapshots` now model preauth and re-check snapshots directly; payer-specific adjudication engines and connectivity remain integration/policy concerns.
- [[booking-use-cases-v3#UC-62: The Split-Tender Payment|UC-62]] #full - payment intent tenders are first-class.
- [[booking-use-cases-v3#UC-63: The Chargeback/Dispute Lifecycle|UC-63]] #full - dispute lifecycle is first-class.
- [[booking-use-cases-v3#UC-64: The Fraud-Risk Manual Review|UC-64]] #full - review queues + workflow decisions cover this.
- [[booking-use-cases-v3#UC-65: The Idempotent API Retry|UC-65]] #full - the schema now has a dedicated cross-domain idempotency registry (`idempotency_keys`) plus domain-level dedupe keys.
- [[booking-use-cases-v3#UC-66: The Offline Front Desk Mode|UC-66]] #full - offline operation journal + merge conflict + resolution event tables are now first-class.
- [[booking-use-cases-v3#UC-67: The External Channel Sync|UC-67]] #full - channels domain is first-class.
- [[booking-use-cases-v3#UC-68: The Data Residency Tenant Boundary|UC-68]] #full - residency/governance primitives are first-class.
- [[booking-use-cases-v3#UC-69: The Legal Blackout Window|UC-69]] #strong - availability + legal-hold/governance support this strongly.
- [[booking-use-cases-v3#UC-70: The Deletion vs Retention Conflict|UC-70]] #full - retention policies + legal holds + redaction jobs are first-class.

### Part 8 (UC-71 .. UC-81)
- [[booking-use-cases-v3#UC-71: The Phone/Call Booking Fee|UC-71]] #full - fee lines + payment primitives support this.
- [[booking-use-cases-v3#UC-72: The Paid Discovery Call|UC-72]] #full - sellable offers + payment primitives support this.
- [[booking-use-cases-v3#UC-73: The Manual Day-and-Hour Pricing Grid|UC-73]] #full - availability rule pricing overrides support this.
- [[booking-use-cases-v3#UC-74: The Holiday and Special-Date Pricing Override|UC-74]] #full - date-range + pricing overrides are first-class.
- [[booking-use-cases-v3#UC-75: The After-Hours and Emergency Callout Fee|UC-75]] #full - timing + fee lines + checkpoints support this.
- [[booking-use-cases-v3#UC-76: The One-Page Quick Setup vs Advanced Builder|UC-76]] #full - schema supports both minimal and advanced configuration layers.
- [[booking-use-cases-v3#UC-77: The On-Site Visit Fee (Charged on Arrival)|UC-77]] #full - fulfillment checkpoints + payment events support this.
- [[booking-use-cases-v3#UC-78: The Walk-In Queue with Estimates (Barber Shop)|UC-78]] #full - queue + prediction primitives are first-class.
- [[booking-use-cases-v3#UC-79: The Government Service Queue (DMV/Office)|UC-79]] #full - `queue_counters`, `queue_counter_assignments`, and `queue_ticket_calls` now provide first-class window/counter dispatch and service-at-window timelines.
- [[booking-use-cases-v3#UC-80: The Fixed-Price Variable-Time Service (Car Wash)|UC-80]] #strong - modeled via fixed pricing + variable operational observations.
- [[booking-use-cases-v3#UC-81: The Host-Dependent and Complexity-Based Duration|UC-81]] #strong - resource capability + prediction primitives support this.

### Part 9 (UC-82 .. UC-86)
- [[booking-use-cases-v3#UC-82: The Scheduled Shuttle Service (Airport/Route-Based)|UC-82]] #full - routes/trips/manifests are first-class.
- [[booking-use-cases-v3#UC-83: The On-Demand Shuttle (Zone-Based Pickup)|UC-83]] #strong - dispatch/trip primitives support this; zone clustering remains app-side.
- [[booking-use-cases-v3#UC-84: The Limo/Black Car Service (Scheduled by Time)|UC-84]] #full - transport scheduling is first-class.
- [[booking-use-cases-v3#UC-85: The Limo Service (Point-to-Point Transfer)|UC-85]] #strong - modeled well; flight-status integration remains external.
- [[booking-use-cases-v3#UC-86: The Charter Bus/Group Transportation|UC-86]] #full - capacity/manifests/dispatch support this.

### Part 10 (UC-87 .. UC-90)
- [[booking-use-cases-v3#UC-87: The Tool Rental (Home Depot Style)|UC-87]] #strong - assets + maintenance + condition reports cover most requirements.
- [[booking-use-cases-v3#UC-88: The Party/Event Equipment Rental|UC-88]] #strong - multi-resource + transport + condition reporting are strong.
- [[booking-use-cases-v3#UC-89: The Vehicle Rental (Car/Truck/Van)|UC-89]] #strong - fleet/usage/condition are strong.
- [[booking-use-cases-v3#UC-90: The Peer-to-Peer Equipment Rental (Fat Llama Style)|UC-90]] #strong - marketplace + commitments (`commitment_contracts`, `secured_balance_accounts`, `commitment_claims`) now cover escrow and dispute flows strongly; insurance underwriting/coverage details remain policy/integration-side.

### Part 11 (UC-91 .. UC-95)
- [[booking-use-cases-v3#UC-91: The Virtual Consultation Service|UC-91]] #strong - virtual offers/workflows are strong; conferencing-provider tables remain integration-side.
- [[booking-use-cases-v3#UC-92: The Async Virtual Service (Review & Response)|UC-92]] #full - async deliverables are first-class.
- [[booking-use-cases-v3#UC-93: The Live Virtual Class/Workshop|UC-93]] #strong - capacity/cohorts/scheduling covered; rich live interaction artifacts are app-side.
- [[booking-use-cases-v3#UC-94: The Virtual Office/Meeting Room|UC-94]] #strong - virtual resource/calendar model is strong.
- [[booking-use-cases-v3#UC-95: The Virtual Fitness Class Subscription|UC-95]] #strong - memberships + education + queue/availability cover most needs.

### Part 12 (UC-96 .. UC-102)
- [[booking-use-cases-v3#UC-96: The Classroom/Lab Booking (University/Corporate)|UC-96]] #strong - resource/capacity/scheduling support this strongly.
- [[booking-use-cases-v3#UC-97: The Training Room (Corporate)|UC-97]] #strong - multi-resource assignment + cohort tracking are strong.
- [[booking-use-cases-v3#UC-98: The Virtual Classroom (K-12/Higher Ed)|UC-98]] #strong - education primitives are strong; SIS/LMS-specific schemas are integration-side.
- [[booking-use-cases-v3#UC-99: The Virtual Workshop Room (Interactive)|UC-99]] #full - `session_interaction_artifacts` now gives first-class event-linked media/transcript/evidence storage with visibility and retention controls.
- [[booking-use-cases-v3#UC-100: The Exam/Proctored Session|UC-100]] #strong - governance/workflow/audit primitives are strong.
- [[booking-use-cases-v3#UC-101: The Hybrid Classroom (In-Person + Remote)|UC-101]] #full - mixed modality is first-class via fulfillment.
- [[booking-use-cases-v3#UC-102: The Pop-Up/Temporarily Bookable Space|UC-102]] #full - overlays/effective windows support this directly.

### Part 13 (UC-103 .. UC-106)
- [[booking-use-cases-v3#UC-103: The Subscription Box with Appointment|UC-103]] #full - `shipment_schedules`, `shipment_generation_runs`, and `shipment_generated_items` now provide first-class recurring shipment contract and generation lifecycle primitives.
- [[booking-use-cases-v3#UC-104: The Membership with Included Services|UC-104]] #full - memberships + entitlement wallets/ledger support this.
- [[booking-use-cases-v3#UC-105: The Field Service with Parts Ordering|UC-105]] #strong - field service units can now reserve/commit inventory with traceable stock movements and physical fulfillment records; supplier replenishment remains app/workflow policy.
- [[booking-use-cases-v3#UC-106: The Curated Experience/Itinerary|UC-106]] #full - multi-step fulfillment + transport + marketplace support this.

### Part 14 (UC-107 .. UC-114)
- [[booking-use-cases-v3#UC-107: The One-Off Ad-Hoc Meeting|UC-107]] #strong - draft offers and flexible booking flows support this.
- [[booking-use-cases-v3#UC-108: The Substitution Finder (Auto-Replacement)|UC-108]] #full - replacement is now first-class via staffing demand/response/assignment + fairness counters and fulfillment-source linkage.
- [[booking-use-cases-v3#UC-109: The Reserve with Google Integration|UC-109]] #strong - channel accounts/sync/link/job primitives support this strongly.
- [[booking-use-cases-v3#UC-110: The QR Code Check-In/Booking|UC-110]] #strong - access action tokens now support `qr_code` token type with issue/validate/use/revoke event timeline; channel/device UX and scanner ergonomics remain app-side.
- [[booking-use-cases-v3#UC-111: The Strategic Availability Hiding ("Look Busy")|UC-111]] #strong - overlays/rules/policies can express controlled exposure.
- [[booking-use-cases-v3#UC-112: The Video Conferencing Auto-Generation|UC-112]] #strong - workflows + channels support automation; provider-specific conferencing metadata remains integration-side.
- [[booking-use-cases-v3#UC-113: The ClassPass Integration|UC-113]] #strong - channels + marketplace + payment primitives are strong.
- [[booking-use-cases-v3#UC-114: The Social Media Booking (Instagram/Facebook)|UC-114]] #strong - channel framework supports this strongly.

### Part 15 (UC-115 .. UC-124)
- [[booking-use-cases-v3#UC-115: The Gift Booking / Gift Voucher|UC-115]] #full - gift instruments, redemptions, transfers, and expiry lifecycle primitives are first-class.
- [[booking-use-cases-v3#UC-116: The Waiver + Consent Gate|UC-116]] #strong - interaction templates + assignments + submissions + signatures + artifacts now provide a first-class waiver/consent gate backbone; legal text governance and signature policy enforcement are mostly app-policy decisions.
- [[booking-use-cases-v3#UC-117: The Group Booking with Split Payments|UC-117]] #full - participant obligations + obligation event ledger now model participant-level due, satisfaction, and enforcement lifecycle.
- [[booking-use-cases-v3#UC-118: The Enterprise PO / Net-Terms Booking|UC-118]] #full - billing accounts + purchase orders + AR invoices + invoice events now provide first-class B2B net-terms accounting primitives.
- [[booking-use-cases-v3#UC-119: The SLA / Service-Guarantee Credit|UC-119]] #full - SLA policy, breach, and compensation event tables now provide normalized guarantee-credit workflows.
- [[booking-use-cases-v3#UC-120: The Multi-Currency + Local Tax Checkout|UC-120]] #full - FX snapshots, tax profiles/rules, and deterministic tax calculation snapshots are first-class.
- [[booking-use-cases-v3#UC-121: The Damage/Incident Claim Lifecycle (Rental)|UC-121]] #strong - condition reports + dispute/payment/workflow primitives can support this pattern; dedicated claim state model would improve clarity.
- [[booking-use-cases-v3#UC-122: The Escrow + Milestone Release (Marketplace)|UC-122]] #full - commitments domain (`commitment_contracts`, `commitment_milestones`, `secured_balance_accounts/ledger_entries/allocations`) now provides first-class escrow and milestone-release primitives with auditable claim lifecycles.
- [[booking-use-cases-v3#UC-123: The Minor Protection + Guardian Approval|UC-123]] #strong - group accounts (`minor`, `managed_by`, permissions) plus workflow approvals map this well.
- [[booking-use-cases-v3#UC-124: The Communication Consent + Quiet Hours|UC-124]] #full - communication consents and quiet-hour policy tables now provide first-class channel/purpose consent state, legal basis capture, and quiet-hour controls.

### Part 16 (UC-125 .. UC-132)
- [[booking-use-cases-v3#UC-125: The Intake Form (Pre-Appointment Data Collection)|UC-125]] #strong - interaction templates/bindings/assignments/submissions plus artifact/signature rows now model intake workflows directly; advanced UI-only behavior (multi-page UX polish, conditional rendering details) remains app-side.
- [[booking-use-cases-v3#UC-126: The Release Form / Liability Waiver (Legal Protection)|UC-126]] #strong - versioned interaction templates with legal-signature evidence, signer roles, and assignment blocking provide first-class release/waiver primitives; legal jurisdiction specifics remain policy-layer.
- [[booking-use-cases-v3#UC-127: The Pre-Appointment Checklist (Task Completion Tracking)|UC-127]] #strong - requirement list templates/items/assignments and per-item runtime statuses now model checklist completion, dependencies, and blocking behavior as first-class entities.
- [[booking-use-cases-v3#UC-128: The Custom Fields (Flexible Data Capture)|UC-128]] #strong - new `custom_field_definitions/options/values` directly support scoped field definitions, validation metadata, default values, and searchable projections; advanced conditional UI logic remains app policy.
- [[booking-use-cases-v3#UC-129: The SMS Reminder System (Multi-Scenario)|UC-129]] #strong - communication templates, event bindings, outbound message ledger, delivery events, and consent/quiet-hour policy now provide robust SMS automation primitives.
- [[booking-use-cases-v3#UC-130: The Email Reminder System (Rich Communication)|UC-130]] #strong - versioned templates + binding rules + outbound message/event timelines cover rich reminder and sequence delivery; provider-specific rendering quirks remain integration-layer.
- [[booking-use-cases-v3#UC-131: The Letter/Postal Mail Templates|UC-131]] #strong - postal channel support in the communications model plus template/send/event ledgers provides a normalized base; carrier-specific certified-mail artifacts remain extension payload concerns.
- [[booking-use-cases-v3#UC-132: The Marketing Sequence Builder (Drip Campaigns)|UC-132]] #strong - campaign/step/enrollment primitives with message bindings provide first-class drip orchestration; advanced experimentation/optimization remains app logic.

### Part 17 (UC-133 .. UC-136)
- [[booking-use-cases-v3#UC-133: The Post-Appointment Survey|UC-133]] #strong - survey templates/questions/invitations/responses/answers are now first-class; advanced BI rollups and sentiment enrichment remain analytics-layer work.
- [[booking-use-cases-v3#UC-134: The Membership Subscription Model|UC-134]] #full - membership plans, entitlements, ledgers, rollover, and transfer primitives already model recurring subscription behavior.
- [[booking-use-cases-v3#UC-135: The External Integration Ecosystem|UC-135]] #full - channel accounts, sync states/jobs/items, entity links, webhooks, and extension installs provide a first-class integration backbone.
- [[booking-use-cases-v3#UC-136: The Webhook System (Real-Time Notifications)|UC-136]] #full - lifecycle event subscriptions + delivery outbox plus inbound channel/Stripe webhook tables cover secure, retryable webhook workflows.

### Part 18 (UC-137 .. UC-139)
- [[booking-use-cases-v3#UC-137: The Analytics & Tracking Dashboard|UC-137]] #full - reporting fact tables + refresh-run ledger now provide first-class analytics primitives for revenue/sellable/utilization dashboards.
- [[booking-use-cases-v3#UC-138: The Referral Program System|UC-138]] #full - referral programs/events/reward grants are first-class and already normalized.
- [[booking-use-cases-v3#UC-139: The Discount & Coupon System|UC-139]] #strong - discount campaigns, codes, and redemption ledgers now provide first-class coupon/usage primitives; extremely channel-specific issuance flows remain app/integration concerns.

### Part 19 (UC-140 .. UC-149)
- [[booking-use-cases-v3#UC-140: The Construction Site Report with Photo Documentation|UC-140]] #strong - interaction templates/submissions/artifacts/signatures plus custom fields provide a robust foundation for daily field reports with evidence; geospatial/offline sync specifics remain app and device-integration concerns.
- [[booking-use-cases-v3#UC-141: The Employee Timesheet with Clock-In/Clock-Out|UC-141]] #strong - `work_time_segments` + `work_runs/work_entries/work_approvals` + leave policy/balance/request/event tables cover clocking, geofence evidence, approvals, overtime inputs, and PTO flows; biometric-device specifics remain integration-side.
- [[booking-use-cases-v3#UC-142: The Contractor/Subcontractor Timesheet & Invoice|UC-142]] #strong - `work_runs/work_entries/work_time_segments` plus AR invoicing and commitments/retention primitives strongly cover contractor time, expense, mileage, and retainage workflows; contractor-specific templates and approval policies remain app/workflow concerns.
- [[booking-use-cases-v3#UC-143: The Policy Agreement & Handbook Acknowledgment|UC-143]] #strong - versioned interaction templates with assignment gating and legal signatures map policy acknowledgment workflows well.
- [[booking-use-cases-v3#UC-144: The Client/Customer Signature Capture|UC-144]] #strong - interaction submission signatures + artifacts + timestamps provide first-class on-site signature capture and evidence chaining.
- [[booking-use-cases-v3#UC-145: The Host/Property Manager Signature Workflow|UC-145]] #strong - signature workflows plus requirement assignments and maintenance work-order integration provide a solid host/manager sign-off foundation.
- [[booking-use-cases-v3#UC-146: The Delivery Photo & Signature Capture|UC-146]] #strong - artifact and signature primitives support delivery proof flows with evidentiary timelines; provider-side quality checks are integration logic.
- [[booking-use-cases-v3#UC-147: The Multi-Party Sign-Off Workflow|UC-147]] #strong - workflow instances/steps/decisions combined with signature records support sequential/parallel approval chains.
- [[booking-use-cases-v3#UC-148: The Safety Inspection & Compliance Checklist|UC-148]] #strong - requirement checklist templates/runtime items plus maintenance/resource status models strongly cover safety inspection and lockout-style flows.
- [[booking-use-cases-v3#UC-149: The Quality Assurance & Punch List|UC-149]] #strong - `work_templates/work_runs/work_run_steps/work_entries/work_artifacts` now provide a strong normalized backbone for punch-list execution with assignee, due/priority, and evidence capture patterns; UI/task-routing conventions remain app-side.

### Part 20 (UC-150 .. UC-157)
- [[booking-use-cases-v3#UC-150: The Plugin Install with Scoped Permissions|UC-150]] #full - extension permission definitions + scoped tenant grants (`biz`/`location`/`custom_subject`) are first-class.
- [[booking-use-cases-v3#UC-151: The Plugin Hook Execution with Retry + Dead Letter|UC-151]] #full - lifecycle events/subscriptions/delivery outbox + retries/dead-letter are first-class.
- [[booking-use-cases-v3#UC-152: The Plugin Read Model / Projection Store|UC-152]] #full - scoped extension state documents with revision + event checkpointing are first-class.
- [[booking-use-cases-v3#UC-153: The HIPAA Minimum Necessary Access Control|UC-153]] #strong - PHI access policies + purpose/action/decision access events are first-class; enforcement resolution logic by role/context remains app policy.
- [[booking-use-cases-v3#UC-154: The Emergency Break-Glass Access|UC-154]] #full - break-glass flags/reasons and explicit post-access review workflow are first-class.
- [[booking-use-cases-v3#UC-155: The Business Associate Agreement (BAA) Lifecycle|UC-155]] #full - BAA lifecycle and extension/vendor linkage are first-class.
- [[booking-use-cases-v3#UC-156: The Accounting of Disclosures Report|UC-156]] #full - PHI disclosure event ledger with recipient/purpose/legal anchors is first-class.
- [[booking-use-cases-v3#UC-157: The Security Incident + Breach Notification Workflow|UC-157]] #strong - incident + breach-notification lifecycle tables are first-class; policy-driven notification orchestration and legal content workflows remain app/integration logic.

### Part 21 (UC-158 .. UC-167)
- [[booking-use-cases-v3#UC-158: The Biz-Configurable Status Vocabulary|UC-158]] #full - `biz_config_sets/values/bindings` plus cross-domain `*_config_value_id` FKs provide first-class tenant-configurable vocabulary with defaults and deterministic system-code mapping.
- [[booking-use-cases-v3#UC-159: The Quick-Start Industry Default Pack|UC-159]] #strong - schema supports seeded config packs via deterministic set/value slugs and defaults; packaged "industry starter bundles" are primarily a seed/import workflow concern.
- [[booking-use-cases-v3#UC-160: The Scoped Override Hierarchy|UC-160]] #full - binding scopes (`biz`/`location`/`scope_ref`) + single-primary enforcement provide deterministic override resolution.
- [[booking-use-cases-v3#UC-161: The Safe Status Retirement|UC-161]] #strong - value lifecycle (`is_active`) and binding defaults support non-breaking retirement; explicit replacement-pointer contracts are not yet normalized.
- [[booking-use-cases-v3#UC-162: The Configurable Checklist Taxonomy|UC-162]] #full - checklist template/runtime status/type columns now have configurable dictionary FKs with tenant-safe integrity.
- [[booking-use-cases-v3#UC-163: The Custom Labeling for Execution Modes|UC-163]] #full - offer/offer-version execution and duration dimensions now support configurable label dictionaries alongside canonical engine enums.
- [[booking-use-cases-v3#UC-164: The Multi-Language Vocabulary Layer|UC-164]] #full - `biz_config_value_localizations` now provides first-class per-locale translation rows with tenant-safe integrity.
- [[booking-use-cases-v3#UC-165: The Plugin-Defined Option Sets|UC-165]] #strong - plugin/custom domains can bind scoped dictionaries via target/scope refs; explicit extension ownership metadata on config sets would improve governance.
- [[booking-use-cases-v3#UC-166: The Unified Reporting Across Custom Labels|UC-166]] #full - `system_code` on config values enables canonical rollups while preserving local labels per biz/location.
- [[booking-use-cases-v3#UC-167: The Config-as-Data Promotion Workflow|UC-167]] #full - `biz_config_promotion_runs` + `biz_config_promotion_run_items` now model auditable config promotion lifecycles and entity-level outcomes.

### Part 22 (UC-168)
- [[booking-use-cases-v3#UC-168: The Take-A-Number Queue with Digital Display|UC-168]] #strong - queue ticket/entry/event primitives and ETA paths are first-class; display/audio hardware integration remains app/integration-side.

### Part 23 (UC-169 .. UC-170)
- [[booking-use-cases-v3#UC-169: The Hybrid Queue + Online Booking for the Same Offer|UC-169]] #strong - queue + slot primitives can coexist against shared commercial/execution entities; admission-path prioritization and channel UX orchestration are policy-layer concerns.
- [[booking-use-cases-v3#UC-170: The ETA-Protected Booking Window with Auto Capacity Holds|UC-170]] #full - availability gates + capacity holds + source traceability are first-class and directly model this.

### Part 24 (UC-171)
- [[booking-use-cases-v3#UC-171: The Host Availability Depends on Front Desk Coverage|UC-171]] #strong - availability dependency rules/targets and deterministic failure actions are first-class; runtime evaluation strategy remains engine logic.

### Part 25 (UC-172 .. UC-175)
- [[booking-use-cases-v3#UC-172: The Open Shift Internal Job Board (First-Come, First-Serve)|UC-172]] #full - staffing demand/response/assignment with claim mode and fairness counters is first-class.
- [[booking-use-cases-v3#UC-173: The Reverse-Bid Internal Shift Market|UC-173]] #strong - staffing bid-response mode plus auction primitives model this strongly; winner policy tuning remains app-side.
- [[booking-use-cases-v3#UC-174: The Replacement Flow as a Special Case of Staffing Demand|UC-174]] #full - demand type `replacement` + source links to fulfillment assignment/unit are first-class.
- [[booking-use-cases-v3#UC-175: The Internal Staffing to Timesheet to Payroll Trace|UC-175]] #full - staffing assignments + work-time segment allocations + compensation ledger context fields provide end-to-end traceability.

### Part 26 (UC-176 .. UC-183)
- [[booking-use-cases-v3#UC-176: The Unified Operations Dispatch Board Across Fulfillment + Staffing|UC-176]] #full - canonical `operational_demands`/`operational_assignments` directly provide one cross-domain dispatch board identity layer across fulfillment, staffing, and custom sources.
- [[booking-use-cases-v3#UC-177: The Cross-Domain Assignment Timeline and Explainability View|UC-177]] #full - canonical assignment identity with source pointers and source-status snapshots provides first-class explainability timeline support.
- [[booking-use-cases-v3#UC-178: The Staffing Demand with Canonical Auction Link|UC-178]] #full - staffing demands now include tenant-safe FK linkage to auctions with mode-shape enforcement.
- [[booking-use-cases-v3#UC-179: The Resource-Type Selector for Offer Components|UC-179]] #full - `offer_component_selectors` now support `resource_type` with strict selector-shape checks.
- [[booking-use-cases-v3#UC-180: The Custom-Subject Selector for Extensible Supply Matching|UC-180]] #full - offer/service-product selectors now support `custom_subject` with tenant-safe subject FKs.
- [[booking-use-cases-v3#UC-181: The Projection Checkpoint Health Monitor|UC-181]] #full - `projection_checkpoints` now provides first-class projection lag/status/revision/cursor observability.
- [[booking-use-cases-v3#UC-182: The Replay-Safe Projection Recovery Workflow|UC-182]] #strong - projection checkpoint revision/cursor/status model supports deterministic replay; replay job orchestration remains app-side.
- [[booking-use-cases-v3#UC-183: The Unified Operational Daily Facts Dashboard|UC-183]] #strong - `fact_operational_daily` plus refresh-run control-plane tables strongly support unified operational dashboards.

### Part 27 (UC-184 .. UC-187)
- [[booking-use-cases-v3#UC-184: The User Shares One Availability Contract with a Business (Internal + External)|UC-184]] #full - `calendar_access_grants` now models one user->biz permission contract across both internal and external calendar sources.
- [[booking-use-cases-v3#UC-185: The User Shares Different Source Sets with Different Businesses|UC-185]] #full - `calendar_access_grant_sources` supports selected-source allowlists across external feeds and internal user calendar bindings from specific source bizes.
- [[booking-use-cases-v3#UC-186: The User Revokes or Time-Boxes Sharing and It Stops Deterministically|UC-186]] #full - grant lifecycle/status constraints (`granted`/`revoked`/`expired`, timestamps, active-pair uniqueness) provide deterministic revocation and expiry behavior with auditable history.
- [[booking-use-cases-v3#UC-187: The Same User Gives Different Detail Levels to Different Businesses|UC-187]] #strong - per-grant access level is first-class; final detail redaction enforcement still depends on API/query policy implementation.

### Part 28 (UC-188 .. UC-191)
- [[booking-use-cases-v3#UC-188: The Biz-Specific Write-Back Permission for Busy Blocks|UC-188]] #full - per-grant `allow_write_back_busy_blocks` supports explicit biz-level write-back policy separation under one user identity.
- [[booking-use-cases-v3#UC-189: The Cross-Biz Source Provenance View (Why Was I Marked Busy?)|UC-189]] #strong - source rows encode external vs internal provenance (`source_type`, `source_biz_id`, `calendar_binding_id`, `external_calendar_id`), but final “blocked-by” explainability rendering is resolver/query logic.
- [[booking-use-cases-v3#UC-190: The Ownership-Safe Share Contract (No Sharing Someone Else’s Calendar)|UC-190]] #full - owner-safe FKs on grant sources enforce that selected external feeds and internal user bindings belong to the grant owner.
- [[booking-use-cases-v3#UC-191: The Grant Source Drift Handling (Source Removed/Disabled Midstream)|UC-191]] #strong - schema keeps grant contract and source rows resilient with external sync-state/error primitives; deterministic fallback policy during source drift remains app-side resolver behavior.

### Part 29 (UC-192 .. UC-196)
- [[booking-use-cases-v3#UC-192: The Configurable Labor Rulebook Template|UC-192]] #full - policy templates + policy rules + policy bindings provide a first-class normalized labor-rulebook model with versioning and scoped application.
- [[booking-use-cases-v3#UC-193: The Same Policy Engine for Labor, Safety, and Service Guarantees|UC-193]] #strong - generic predicate types and domain-keyed templates provide broad reuse; runtime evaluator orchestration remains app policy logic.
- [[booking-use-cases-v3#UC-194: The Immutable Policy Breach Evidence Ledger|UC-194]] #full - policy breach rows with coherent template/rule/binding links, subject targeting, evidence snapshots, and lifecycle states are now first-class.
- [[booking-use-cases-v3#UC-195: The Generic Consequence Ledger with Financial Traceability|UC-195]] #full - typed consequence ledger with lifecycle states and optional links to compensation/payment/settlement/workflow/review artifacts provides first-class traceable remediation primitives.
- [[booking-use-cases-v3#UC-196: The Waiver and Dismissal Trail for Policy Exceptions|UC-196]] #strong - waiver/dismissal breach states and reversible consequence lifecycles are modeled directly; approval-routing policy remains workflow/app logic.

### Part 30 (UC-197 .. UC-210)
- [[booking-use-cases-v3#UC-197: The Licensed Digital Product Sale with Key Issuance|UC-197]] #strong - access artifacts + artifact links/events + action tokens now provide first-class key issuance/verification/revocation lifecycle with order/payment linkage; license-type vocabulary enforcement is still policy/config driven.
- [[booking-use-cases-v3#UC-198: The Secure Download Delivery with Expiry and Limits|UC-198]] #full - delivery links + usage windows + access activity logs + action token events provide first-class expiry/cap telemetry and controlled reissue workflows.
- [[booking-use-cases-v3#UC-199: The Flexible Pricing Product (Free, Fixed, Name-Your-Price)|UC-199]] #full - sellable pricing modes/thresholds/overrides now model free/fixed/flexible pricing with currency-aware constraints and scoped pricing behavior.
- [[booking-use-cases-v3#UC-200: The Product Variant and Bundle Storefront|UC-200]] #full - variant dimensions/values/selections plus bundle composition and line-level sellable attribution now provide first-class variant + bundle storefront primitives.
- [[booking-use-cases-v3#UC-201: The Customer Library and Access Center|UC-201]] #full - `access_library_items` now provides a first-class owner-centric read model over access artifacts, memberships, entitlements, and usage windows.
- [[booking-use-cases-v3#UC-202: The Abandoned Checkout Recovery for Services and Products|UC-202]] #strong - checkout sessions/items/events/recovery links are first-class and capture abandonment/recovery attribution; anti-spam cadence policy across channels remains app/policy orchestration.
- [[booking-use-cases-v3#UC-203: The Affiliate Referral Commerce Loop|UC-203]] #full - `referral_links`, `referral_link_clicks`, and `referral_attributions` now provide first-class tracked-link attribution windows and conversion decisions on top of existing referral programs/events/reward grants.
- [[booking-use-cases-v3#UC-204: The Ticket Hold, Transfer, and Resale Governance Flow|UC-204]] #full - capacity holds + access artifacts + transfer policies + transfer workflows + resale listings now provide first-class hold/transfer/resale governance with full ownership timeline traceability.
- [[booking-use-cases-v3#UC-205: The Multi-Session Event Agenda with Room Assignment|UC-205]] #strong - multi-session cohort/session scheduling and resource assignment provide strong agenda + room conflict foundations; attendee-facing itinerary projection/reminder shaping is app-side.
- [[booking-use-cases-v3#UC-206: The Virtual Event Engagement Layer|UC-206]] #strong - session interaction events/aggregates capture chat/Q&A/poll/replay behaviors as first-class records; engagement scoring strategy and marketing segmentation remain analytics/app logic.
- [[booking-use-cases-v3#UC-207: The Course Path with Prerequisite Gating|UC-207]] #strong - requirement sets/nodes/edges/evaluations provide a normalized prerequisite and unlock-gating graph; unlock orchestration remains evaluator/app logic.
- [[booking-use-cases-v3#UC-208: The Assessment and Assignment Lifecycle|UC-208]] #strong - assessment templates/items/attempts/responses/results plus grading events now provide first-class quiz/attempt/grading lifecycle; assignment-UX-specific artifact conventions remain app-side.
- [[booking-use-cases-v3#UC-209: The Membership Tier Content Gating Model|UC-209]] #strong - membership + entitlement primitives support tiered access semantics; explicit tier-to-content mapping tables and storefront visibility projections are still mostly app policy.
- [[booking-use-cases-v3#UC-210: The Delivery Security Policy Pack for Digital Assets|UC-210]] #strong - access security signals/decisions plus activity logs and policy outcomes now provide normalized delivery-security detection and consequence flow; watermark/DRM provider specifics remain integration-level payloads.

### Part 31 (UC-211 .. UC-216)
- [[booking-use-cases-v3#UC-211: The Followed Subject Alert Subscription|UC-211]] #full - `graph_subject_subscriptions` now models per-subscriber subject subscriptions with delivery mode, preferred channel, and cadence controls.
- [[booking-use-cases-v3#UC-212: The Identity Notification Endpoints Registry|UC-212]] #full - `graph_identity_notification_endpoints` provides owner-scoped, channel-aware endpoint registry with default-endpoint constraints and lifecycle controls.
- [[booking-use-cases-v3#UC-213: The Subject Event Stream with Idempotent Writes|UC-213]] #full - `graph_subject_events` gives an immutable biz-scoped subject event stream with request-key dedupe and correlation tracing fields.
- [[booking-use-cases-v3#UC-214: The Per-Subscriber Delivery State Timeline|UC-214]] #strong - `graph_subject_event_deliveries` captures delivery/read/retry timeline and failure evidence; retry orchestration policy remains app/worker logic.
- [[booking-use-cases-v3#UC-215: The Biz-Safe Audience Fanout for Subject Events|UC-215]] #strong - tenant-safe event/subscription and owner-safe endpoint foreign keys strongly enforce safe fanout boundaries; fanout execution strategy remains runtime logic.
- [[booking-use-cases-v3#UC-216: The Notification Cadence and Noise-Control Policy|UC-216]] #strong - cadence fields (`delivery_mode`, `min_delivery_interval_minutes`, `next_eligible_delivery_at`) are first-class; digest batching policy stays app-side.

### Part 32 (UC-217 .. UC-222)
- [[booking-use-cases-v3#UC-217: The Seat-Map Booking with Hold Timer|UC-217]] #full - seat-map geometry, seat rows, hold lifecycles, and reservation conversion are now first-class in `seating`.
- [[booking-use-cases-v3#UC-218: The Queue Counter/Window Dispatch Board|UC-218]] #full - counter entities, staffing assignments, and ticket-call timelines are first-class in `queue_operations`.
- [[booking-use-cases-v3#UC-219: The Booking Transfer Contract|UC-219]] #full - transfer contracts and immutable transfer event timelines are first-class in `fulfillment_transfers`.
- [[booking-use-cases-v3#UC-220: The Referral Link Attribution Window|UC-220]] #full - referral link issuance, click telemetry, and attribution decisions are first-class in `referral_attribution`.
- [[booking-use-cases-v3#UC-221: The Session Interaction Artifact Trail|UC-221]] #full - interaction artifacts are first-class with storage, visibility, and retention metadata in `session_interaction_artifacts`.
- [[booking-use-cases-v3#UC-222: The Customer Library Read Model|UC-222]] #full - owner-centric library projection is first-class in `access_library_items`.

### Part 33 (UC-223 .. UC-230)
- [[booking-use-cases-v3#UC-223: The Portable Credential Wallet (Upload Once, Reuse Everywhere)|UC-223]] #full - `user_credential_records`, `user_credential_documents`, and `user_credential_facts` provide a first-class user-owned credential wallet independent from biz tenancy.
- [[booking-use-cases-v3#UC-224: The Selective Sharing Contract (Different Biz, Different Access)|UC-224]] #full - `biz_credential_share_grants` + selector rows provide explicit per-biz scope/data-level sharing contracts with revocation/expiry.
- [[booking-use-cases-v3#UC-225: The Candidate Discovery Filter by Credential Facts|UC-225]] #full - discovery visibility on records/facts plus indexed fact projections supports platform-level candidate filtering without exposing full documents.
- [[booking-use-cases-v3#UC-226: The Opening-Linked Credential Request (Pre-Hire Qualification)|UC-226]] #strong - request + request-item primitives model source-linked qualification asks; opening-specific fulfillment gating logic remains app orchestration.
- [[booking-use-cases-v3#UC-227: The Reverification and Expiry Gate for Assignment Eligibility|UC-227]] #strong - verification timelines and minimum-validity requirement items are first-class; real-time eligibility evaluator policy is app-side.
- [[booking-use-cases-v3#UC-228: The Cross-Biz Verification Reuse with Local Policy Overrides|UC-228]] #strong - verifier biz metadata and required verification-status constraints support reuse/override patterns; trust-scoring policy remains runtime logic.
- [[booking-use-cases-v3#UC-229: The Sensitive Document Redaction and Controlled Disclosure|UC-229]] #strong - document sensitivity/preview-policy + grant access controls are first-class; final redaction rendering and download guards are API policy-layer.
- [[booking-use-cases-v3#UC-230: The Immutable Credential Disclosure Timeline|UC-230]] #full - `credential_disclosure_events` provides immutable-style disclosure traceability linked to grants/requests/records/documents.

### Part 34 (UC-231 .. UC-241)
- [[booking-use-cases-v3#UC-231: The Delegated Admin with Approval Caps|UC-231]] #full - enterprise delegation and approval-cap primitives are first-class in `enterprise_admin_delegations` and `enterprise_approval_authority_limits`.
- [[booking-use-cases-v3#UC-232: The Contract Pack Canary Rollout Across a Franchise Network|UC-232]] #full - versioned pack bindings plus rollout runs/targets/results provide first-class phased rollout orchestration.
- [[booking-use-cases-v3#UC-233: The Intercompany Settlement Window Close|UC-233]] #full - intercompany accounts/entries/settlement runs provide accounting-grade settlement window closure with reconciliation fields.
- [[booking-use-cases-v3#UC-234: The Enterprise SSO + SCIM Provisioning Lifecycle|UC-234]] #full - identity provider rows, SCIM sync states, and external directory links are first-class enterprise identity primitives.
- [[booking-use-cases-v3#UC-235: The Leave and PTO-Aware Scheduling Guard|UC-235]] #strong - leave policy/balance/request/event primitives are first-class; direct scheduling enforcement against leave remains policy/resolver logic.
- [[booking-use-cases-v3#UC-236: The Access Security Signal and Auto-Lockdown|UC-236]] #full - access security signals and decisions are first-class and link cleanly to token/artifact usage flows.
- [[booking-use-cases-v3#UC-237: The Cross-Sell Wishlist / Save-for-Later List|UC-237]] #full - `wishlists` + `wishlist_items` now provide first-class persistent save-for-later flows keyed by owner and canonical sellable.
- [[booking-use-cases-v3#UC-238: The Versioned Quote-to-Order Acceptance Flow|UC-238]] #full - `sales_quotes`, `sales_quote_versions`, `sales_quote_lines`, and `sales_quote_acceptances` now provide normalized revisioned quote contracts with conversion linkage.
- [[booking-use-cases-v3#UC-239: The Installment Plan for High-Ticket Services|UC-239]] #full - `installment_plans` + `installment_schedule_items` now provide first-class staged receivable schedules tied to payments.
- [[booking-use-cases-v3#UC-240: The Scheduled Gift Delivery (Date + Message + Recipient Channel)|UC-240]] #full - `gift_delivery_schedules` + `gift_delivery_attempts` now provide deterministic timed-delivery orchestration and retry timeline.
- [[booking-use-cases-v3#UC-241: The AR AutoPay Rule for Net-Term Accounts|UC-241]] #full - `billing_account_autopay_rules` + `autocollection_attempts` now provide first-class net-terms auto-collection policy and execution ledger.

### Part 35 (UC-242 .. UC-247)
- [[booking-use-cases-v3#UC-242: The Bakery Batch Prepay + Waitlist Model|UC-242]] #full - `production_batches` + `production_batch_reservations` now provide first-class finite-batch supply modeling on top of checkout/order and waitlist flow primitives.
- [[booking-use-cases-v3#UC-243: The Paid Ad Click-to-Order Attribution (Google/Meta IDs)|UC-243]] #strong - referral links/clicks/attributions plus checkout acquisition fields strongly support click-to-order attribution windows and auditability.
- [[booking-use-cases-v3#UC-244: The Lead Ads to Queue/Booking Intake Flow|UC-244]] #full - `crm_leads` + lead events now provide normalized lead intake state on top of channel/webhook, queue, and workflow routing primitives.
- [[booking-use-cases-v3#UC-245: The Ad Audience Segment Export from Platform Behavior|UC-245]] #full - `marketing_audience_segments`, memberships, and sync runs now provide first-class segment definition/materialization/export.
- [[booking-use-cases-v3#UC-246: The ROAS/CAC Dashboard with Spend + Conversion Join|UC-246]] #full - `ad_spend_daily_facts` now provides normalized spend-side ingestion that joins cleanly with attribution and revenue facts.
- [[booking-use-cases-v3#UC-247: The Offline Conversion Feedback to Ad Platforms|UC-247]] #full - `offline_conversion_pushes` now provides first-class outbound conversion feedback ledger with provider/account lineage.

### Part 36 (UC-248 .. UC-257)
- [[booking-use-cases-v3#UC-248: The Unified Customer Profile (Contact 360)|UC-248]] #full - `crm_contacts` + `crm_contact_channels` now provide a first-class shared contact identity and endpoint layer, unified with leads/opportunities/conversations/quotes and reusable across workflow domains.
- [[booking-use-cases-v3#UC-249: The Lead Capture and Qualification Lifecycle|UC-249]] #full - `crm_leads` + `crm_lead_events` now provide first-class lead identity, ownership, scoring, and lifecycle timeline.
- [[booking-use-cases-v3#UC-250: The Opportunity Pipeline (Deals, Stages, and Probability)|UC-250]] #full - `crm_pipelines`, `crm_pipeline_stages`, `crm_opportunities`, and stage events now provide first-class pipeline/deal forecasting structure.
- [[booking-use-cases-v3#UC-251: The CRM Task and Follow-Up Engine|UC-251]] #strong - work management + workflows + outbound messaging provide strong follow-up task orchestration with assignment/SLA behavior.
- [[booking-use-cases-v3#UC-252: The Omnichannel Conversation Inbox|UC-252]] #full - `crm_conversations`, participants, messages, and `crm_contact_channels` provide first-class threaded inbox state with durable sender/participant anchors and outbound message linkage.
- [[booking-use-cases-v3#UC-253: The CRM SLA and Escalation Policy|UC-253]] #strong - SLA policies/breaches/consequences + review queues/workflows support first-response/escalation governance strongly.
- [[booking-use-cases-v3#UC-254: The Proposal + E-Sign + Order Conversion Flow|UC-254]] #full - quote versioning plus acceptance evidence and interaction submission linkage now provide first-class proposal/e-sign/order-conversion structure, with acceptance actors normalized via contact/subject anchors.
- [[booking-use-cases-v3#UC-255: The Account Hierarchy and Buying Center Model|UC-255]] #strong - group accounts, subject relationships, and enterprise relationship graph provide strong hierarchy/federation primitives for account structures.
- [[booking-use-cases-v3#UC-256: The Churn Risk and Reactivation Playbooks|UC-256]] #strong - ranking/intelligence signals + campaign enrollments + communications/consent support retention orchestration strongly.
- [[booking-use-cases-v3#UC-257: The Contact Deduplication and Merge Audit Trail|UC-257]] #full - `crm_merge_candidates`, `crm_merge_decisions`, and `crm_subject_redirects` now provide first-class dedupe/merge governance and lineage redirects.


## Manual UC Group Matrix (Authoritative)

Format: `+` = enabling tables(rows), `-` = lacking/missing tables(rows).

- **Part 1 (UC-1..UC-9)** | +: offers(offer), offer_versions(version), booking_orders(order), booking_order_lines(line), fulfillment_units(unit), fulfillment_assignments(assignment), calendars(calendar), calendar_bindings(binding), compensation_plans(plan), compensation_ledger_entries(entry), ranking_profiles(profile), ranking_events(event) | -: none
- **Part 2 (UC-10..UC-15)** | +: subject_location_bindings(binding), resources(resource), resource_maintenance_policies(policy), resource_maintenance_work_orders(work_order), program_cohorts(cohort), session_attendance_records(attendance), transport_routes(route), transport_trips(trip), eta_events(event) | -: none
- **Part 3 (UC-16..UC-22)** | +: memberships(membership), entitlement_wallets(wallet), entitlement_grants(grant), demand_signal_observations(signal_obs), demand_pricing_evaluations(evaluation), queues(queue), queue_entries(entry), offer_component_seat_types(seat_type), seat_maps(map), seat_map_seats(seat), seat_holds(hold), seat_reservations(reservation) | -: none
- **Part 4 (UC-23..UC-29)** | +: cross_biz_contracts(contract), cross_biz_orders(order), fulfillment_dependencies(edge), policy_templates(template), policy_rules(rule), policy_breach_events(breach), policy_consequence_events(consequence), capacity_pools(pool) | -: none
- **Part 5 (UC-30..UC-35)** | +: standing_reservation_contracts(contract), standing_reservation_exceptions(exception), standing_reservation_occurrences(occurrence), fulfillment_dependencies(edge), workflow_instances(instance), workflow_steps(step) | -: none
- **Part 6 (UC-36..UC-60)** | +: resources(resource), group_accounts(group), memberships(membership), product_bundles(bundle), booking_order_line_sellables(line_sellable), calendars(calendar), calendar_overlays(overlay), notes(note), audit_events(event), queues(queue) | -: none
- **Part 7 (UC-61..UC-70)** | +: review_queues(queue), workflow_instances(instance), payment_disputes(dispute), idempotency_keys(key), offline_ops_journal(op), channel_sync_states(state), legal_holds(hold), redaction_jobs(job), payer_authorizations(auth), eligibility_snapshots(snapshot) | -: none
- **Part 8 (UC-71..UC-81)** | +: booking_order_lines(fee_line), payment_intents(intent), payment_transactions(txn), availability_rules(rule), queue_tickets(ticket), queue_counters(counter), queue_counter_assignments(assignment), queue_ticket_calls(call), service_time_observations(observation) | -: none
- **Part 9 (UC-82..UC-86)** | +: transport_routes(route), transport_trips(trip), transport_route_stops(stop), trip_manifests(manifest), eta_events(event) | -: none
- **Part 10 (UC-87..UC-90)** | +: resources(resource), resource_maintenance_work_orders(work_order), resource_condition_reports(report), marketplace_listings(listing), cross_biz_contracts(contract), commitment_contracts(contract), secured_balance_accounts(account), commitment_claims(claim) | -: insurance_coverage_policies(policy), insurance_mediation_cases(case)
- **Part 11 (UC-91..UC-95)** | +: offers(offer), fulfillment_units(unit), channel_accounts(account), workflow_instances(instance), memberships(membership), program_cohort_sessions(session) | -: none
- **Part 12 (UC-96..UC-102)** | +: resources(resource), calendars(calendar), program_cohort_sessions(session), session_attendance_records(attendance), fulfillment_units(unit), session_interaction_events(event), session_interaction_aggregates(aggregate), session_interaction_artifacts(artifact) | -: none
- **Part 13 (UC-103..UC-106)** | +: inventory_items(item), inventory_reservations(reservation), physical_fulfillments(fulfillment), memberships(membership), entitlement_grants(grant), fulfillment_dependencies(edge), shipment_schedules(schedule), shipment_generation_runs(run), shipment_generated_items(item) | -: none
- **Part 14 (UC-107..UC-114)** | +: offers(offer), staffing_demands(demand), staffing_assignments(assignment), channel_entity_links(link), channel_sync_jobs(job), channel_webhook_events(event), access_action_tokens(token), access_action_token_events(event) | -: none
- **Part 15 (UC-115..UC-124)** | +: gift_instruments(instrument), gift_redemptions(redemption), booking_participant_obligations(obligation), billing_accounts(account), ar_invoices(invoice), sla_breach_events(breach), tax_calculations(calc), communication_consents(consent), commitment_contracts(contract), commitment_milestones(milestone), secured_balance_accounts(account), secured_balance_ledger_entries(entry), commitment_claims(claim) | -: none
- **Part 16 (UC-125..UC-132)** | +: interaction_templates(template), interaction_assignments(assignment), interaction_submissions(submission), requirement_list_templates(template), custom_field_definitions(definition), message_templates(template), outbound_messages(message), marketing_campaign_enrollments(enrollment) | -: none
- **Part 17 (UC-133..UC-136)** | +: survey_templates(template), survey_responses(response), memberships(membership), channel_accounts(account), channel_webhook_events(event), lifecycle_event_deliveries(delivery) | -: none
- **Part 18 (UC-137..UC-139)** | +: fact_revenue_daily(fact), fact_sellable_daily(fact), fact_resource_utilization_daily(fact), referral_programs(program), reward_grants(grant), discount_codes(code), discount_redemptions(redemption) | -: none
- **Part 19 (UC-140..UC-149)** | +: work_templates(template), work_template_steps(step), work_runs(run), work_run_steps(step_runtime), work_entries(entry), work_artifacts(artifact), work_time_segments(segment), leave_requests(request), interaction_submission_signatures(signature), requirement_list_assignments(instance), commitment_contracts(contract), commitment_milestones(milestone), secured_balance_accounts(account) | -: none
- **Part 20 (UC-150..UC-157)** | +: extension_definitions(definition), biz_extension_installs(install), extension_permission_definitions(permission), lifecycle_events(event), lifecycle_event_deliveries(delivery), extension_state_documents(state_doc), phi_access_events(event), breach_notifications(notification) | -: none
- **Part 21 (UC-158..UC-167)** | +: biz_config_sets(set), biz_config_values(value), biz_config_value_localizations(localization), biz_config_bindings(binding), biz_config_promotion_runs(run), biz_config_promotion_run_items(run_item), system_code mappings for reporting rollups | -: none
- **Part 22 (UC-168)** | +: queues(queue), queue_tickets(ticket), queue_events(event), wait_time_predictions(prediction) | -: none
- **Part 23 (UC-169..UC-170)** | +: offer_version_admission_modes(mode), queues(queue), booking_orders(order), capacity_holds(hold), availability_dependency_rules(rule) | -: none
- **Part 24 (UC-171)** | +: availability_dependency_rules(rule), availability_dependency_rule_targets(target), calendars(calendar), resources(resource) | -: none
- **Part 25 (UC-172..UC-175)** | +: staffing_demands(demand), staffing_responses(response), staffing_assignments(assignment), work_time_segment_allocations(allocation), compensation_ledger_entries(entry), compensation_pay_run_items(item) | -: none
- **Part 26 (UC-176..UC-183)** | +: operational_demands(demand), operational_assignments(assignment), projection_checkpoints(checkpoint), fact_operational_daily(fact), offer_component_selectors(selector), service_product_requirement_selectors(selector) | -: none
- **Part 27 (UC-184..UC-187)** | +: calendar_access_grants(grant), calendar_access_grant_sources(source), external_calendars(calendar), external_calendar_events(event), calendar_bindings(binding) | -: none
- **Part 28 (UC-188..UC-191)** | +: calendar_access_grants(grant), calendar_access_grant_sources(source), external_calendars(calendar), external_calendar_events(event) | -: none
- **Part 29 (UC-192..UC-196)** | +: policy_templates(template), policy_rules(rule), policy_bindings(binding), policy_breach_events(breach), policy_consequence_events(consequence) | -: none
- **Part 30 (UC-197..UC-210)** | +: access_artifacts(artifact), access_artifact_links(link), access_artifact_events(event), access_activity_logs(log), access_usage_windows(limit), access_delivery_links(link), access_action_tokens(token), access_action_token_events(event), access_transfer_policies(policy), access_transfers(transfer), access_resale_listings(listing), access_security_signals(signal), access_security_decisions(decision), access_library_items(library_item), checkout_sessions(session), checkout_session_events(event), checkout_recovery_links(recovery), sellable_variant_dimensions(dimension), sellable_variants(variant), sellable_pricing_modes(mode), sellable_pricing_thresholds(threshold), sellable_pricing_overrides(override), requirement_sets(set), requirement_evaluations(evaluation), assessment_templates(template), assessment_items(item), assessment_attempts(attempt), assessment_responses(response), assessment_results(result), grading_events(event), session_interaction_events(event) | -: none
- **Part 31 (UC-211..UC-216)** | +: graph_subject_subscriptions(subscription), graph_identity_notification_endpoints(endpoint), graph_subject_events(event), graph_subject_event_deliveries(delivery), graph_identities(identity), subjects(subject) | -: none
- **Part 32 (UC-217..UC-222)** | +: seat_maps(map), seat_map_seats(seat), seat_holds(hold), seat_reservations(reservation), queue_counters(counter), queue_counter_assignments(assignment), queue_ticket_calls(call), fulfillment_transfer_requests(transfer), fulfillment_transfer_events(event), referral_links(link), referral_link_clicks(click), referral_attributions(attribution), session_interaction_artifacts(artifact), access_library_items(library_item) | -: none
- **Part 33 (UC-223..UC-230)** | +: credential_type_definitions(type_def), user_credential_profiles(profile), user_credential_records(record), user_credential_documents(document), user_credential_facts(fact), user_credential_verifications(verification), biz_credential_share_grants(grant), biz_credential_share_grant_selectors(selector), biz_credential_requests(request), biz_credential_request_items(request_item), credential_disclosure_events(event) | -: none
- **Part 34 (UC-231..UC-241)** | +: enterprise_scopes(scope), enterprise_admin_delegations(delegation), enterprise_approval_authority_limits(limit), enterprise_contract_pack_versions(version), enterprise_change_rollout_runs(run), enterprise_intercompany_entries(entry), enterprise_identity_providers(idp), enterprise_scim_sync_states(sync_state), leave_requests(request), leave_events(event), access_security_signals(signal), access_security_decisions(decision), billing_accounts(account), ar_invoices(invoice), wishlists(wishlist), wishlist_items(item), sales_quotes(quote), sales_quote_versions(version), sales_quote_lines(line), sales_quote_acceptances(acceptance), installment_plans(plan), installment_schedule_items(item), gift_delivery_schedules(schedule), gift_delivery_attempts(attempt), billing_account_autopay_rules(rule), autocollection_attempts(attempt) | -: none
- **Part 35 (UC-242..UC-247)** | +: production_batches(batch), production_batch_reservations(reservation), queues(queue), queue_entries(entry), checkout_sessions(session), booking_orders(order), inventory_reservations(reservation), referral_links(link), referral_link_clicks(click), referral_attributions(attribution), marketing_audience_segments(segment), marketing_audience_segment_memberships(membership), marketing_audience_sync_runs(run), ad_spend_daily_facts(fact), offline_conversion_pushes(push), channel_webhook_events(webhook), channel_sync_jobs(sync_job), channel_entity_links(link), fact_revenue_daily(fact) | -: none
- **Part 36 (UC-248..UC-257)** | +: users(user), group_accounts(account), custom_field_values(value), notes(note), communication_consents(consent), review_queues(queue), review_queue_items(item), workflow_instances(instance), work_runs(run), work_entries(entry), outbound_messages(message), sla_policies(policy), sla_breach_events(breach), sla_compensation_events(compensation), marketing_campaign_enrollments(enrollment), subject_relationships(relationship), enterprise_relationships(relationship), crm_contacts(contact), crm_contact_channels(channel), crm_pipelines(pipeline), crm_pipeline_stages(stage), crm_leads(lead), crm_lead_events(event), crm_opportunities(opportunity), crm_opportunity_stage_events(stage_event), crm_conversations(conversation), crm_conversation_participants(participant), crm_conversation_messages(message), crm_merge_candidates(candidate), crm_merge_decisions(decision), crm_subject_redirects(redirect) | -: none


## Snapshot Summary

- #full: 144
- #strong: 113
- #partial: 0
- #gap: 0

Total evaluated: 257 use cases.

## Biggest Remaining Schema Gaps

- Insurance coverage policy/benefit-plan normalization for deeper payer mediation across non-healthcare and healthcare partner ecosystems.
