---
date: 2026-02-19
tags:
  - schema
  - blueprint
  - v4
  - eli5
  - booking
  - redesign
---

# Bizing Booking Schema v4 Blueprint (ELI5 + Deep)

> This is the publishable blueprint for the next schema generation.  
> It assumes **no backward-compat constraints**, **no production data**, and the full v3 use-case catalog.

---

## 0) ELI5 First: What We Are Building

Imagine Bizing is a giant, smart playground for time.

- People want to buy experiences (haircut, MRI, shuttle ride, class, tool rental, limo, exam).
- Businesses own supply (hosts, rooms, tools, vehicles, routes, programs).
- The system must answer one question reliably:  
  **"Can this exact thing happen at this exact time for this exact person, and what is the exact price and policy?"**

The schema must do this for:
- super simple setup (one person, one service, one price), and
- super complex operations (multi-step medical flows, queues, rentals, transport routes, compliance, disputes, cross-org orchestration).

---

## 1) Coverage Report Against `booking-use-cases-v3.md`

Source file for all UC links: [[booking-use-cases-v3]].

Source reviewed:  
`/Users/ameer/projects/bizing/mind/workspace/booking-use-cases-v3.md`

### Coverage Legend
- `Perfect`: works naturally in current schema with clean mapping.
- `Partial`: possible, but needs app-heavy logic / JSON / non-first-class patterns.
- `Poor`: can be forced but schema shape fights the use case.
- `Not`: missing core model primitives.

---

## Part 1 (UC-1..UC-9)

- [[booking-use-cases-v3#UC-1: The Solo Consultant (Fixed Duration)|UC-1]] Solo consultant fixed duration: `Perfect`
- [[booking-use-cases-v3#UC-2: The Solo Consultant (Variable Duration)|UC-2]] Solo consultant variable duration: `Perfect`
- [[booking-use-cases-v3#UC-3: The Hair Salon with Commission Tracking|UC-3]] Salon + commission tracking: `Partial`
- [[booking-use-cases-v3#UC-4: The Salon with Provider Favorability/Ranking|UC-4]] Favorability/ranking slot allocation: `Partial`
- [[booking-use-cases-v3#UC-5: The Medical Clinic with Room Pairing|UC-5]] Medical room pairing: `Partial`
- [[booking-use-cases-v3#UC-6: The Medical Clinic with Approval Workflow|UC-6]] Approval workflow booking: `Partial`
- [[booking-use-cases-v3#UC-7: The Fitness Class Studio|UC-7]] Fitness class with equipment assignment: `Partial`
- [[booking-use-cases-v3#UC-8: The Tutoring Center with Packages|UC-8]] Tutoring + packages: `Partial`
- [[booking-use-cases-v3#UC-9: The Front Desk Receptionist Calendar|UC-9]] Front desk multi-provider calendar: `Partial`

## Part 2 (UC-10..UC-15)

- [[booking-use-cases-v3#UC-10: The Multi-Location Chain|UC-10]] Multi-location chain: `Perfect`
- [[booking-use-cases-v3#UC-11: The Multi-Provider Appointment with Commission Split|UC-11]] Multi-provider appointment + split comp: `Partial`
- [[booking-use-cases-v3#UC-12: The Equipment-Required Service with Auto-Maintenance|UC-12]] Equipment required + auto maintenance: `Poor`
- [[booking-use-cases-v3#UC-13: The Multi-Day Rental with Gap Management|UC-13]] Multi-day rental + gap management: `Partial`
- [[booking-use-cases-v3#UC-14: The Corporate Training with Attendance Tracking|UC-14]] Corporate training + attendance: `Partial`
- [[booking-use-cases-v3#UC-15: The Mobile Service with Route Optimization|UC-15]] Mobile service + route optimization: `Poor`

## Part 3 (UC-16..UC-22)

- [[booking-use-cases-v3#UC-16: The Package Deal with Expiration|UC-16]] Package deal + expiration/transfer: `Partial`
- [[booking-use-cases-v3#UC-17: The Dynamic/Surge Pricing|UC-17]] Dynamic surge pricing algorithm: `Not`
- [[booking-use-cases-v3#UC-18: The Seat Selection Venue|UC-18]] Visual seat map booking: `Not`
- [[booking-use-cases-v3#UC-19: The Waitlist with Auto-Offer and Pricing|UC-19]] Waitlist auto-offer + fee: `Perfect` (core), `Partial` (rich policy variants)
- [[booking-use-cases-v3#UC-20: The First-Confirm-First-Booked Waitlist|UC-20]] First-confirm-first-booked waitlist: `Perfect`
- [[booking-use-cases-v3#UC-21: The Recurring Subscription with Pause|UC-21]] Recurring subscription + pause: `Partial`
- [[booking-use-cases-v3#UC-22: The Tour/Experience with Minimum Viable|UC-22]] Tour min/max viability + weather logic: `Partial`

## Part 4 (UC-23..UC-29)

- [[booking-use-cases-v3#UC-23: The Franchise Chain with Royalty|UC-23]] Franchise + royalty hierarchy: `Not`
- [[booking-use-cases-v3#UC-24: The Multi-Step Medical Procedure|UC-24]] Multi-step medical dependencies: `Partial`
- [[booking-use-cases-v3#UC-25: The Multi-Resource Event|UC-25]] Multi-resource event quote-to-booking: `Partial`
- [[booking-use-cases-v3#UC-26: The Union Production with Complex Rules|UC-26]] Union production labor rules: `Not`
- [[booking-use-cases-v3#UC-27: The Equipment Sharing Pool|UC-27]] Equipment sharing pool with priority: `Poor`
- [[booking-use-cases-v3#UC-28: The Airline-Style Overbooking|UC-28]] Airline-style overbooking engine: `Not`
- [[booking-use-cases-v3#UC-29: The Conditional/Rule-Based Booking|UC-29]] Conditional prerequisites/eligibility: `Partial`

## Part 5 (UC-30..UC-35)

- [[booking-use-cases-v3#UC-30: The Standing Reservation|UC-30]] Standing reservation: `Partial`
- [[booking-use-cases-v3#UC-31: The Floating Appointment|UC-31]] Floating appointment assigned later: `Poor`
- [[booking-use-cases-v3#UC-32: The Reverse Auction Marketplace|UC-32]] Reverse-auction marketplace: `Not`
- [[booking-use-cases-v3#UC-33: The Cascading Appointment|UC-33]] Cascading appointments with dependencies: `Partial`
- [[booking-use-cases-v3#UC-34: The Multi-Timezone Coordination|UC-34]] Multi-timezone coordination fairness: `Partial`
- [[booking-use-cases-v3#UC-35: The Disaster Recovery Mass Reschedule|UC-35]] Disaster recovery mass reschedule: `Partial`

## Part 6 (UC-36..UC-60)

- [[booking-use-cases-v3#UC-36: The Company as Provider|UC-36]] Company as provider: `Perfect`
- [[booking-use-cases-v3#UC-37: The Household/Family Account|UC-37]] Household/family account: `Perfect`
- [[booking-use-cases-v3#UC-38: The Product + Service Bundle|UC-38]] Product + service bundle: `Partial`
- [[booking-use-cases-v3#UC-39: The Program with Attendance Tracking|UC-39]] Program attendance completion: `Partial`
- [[booking-use-cases-v3#UC-40: The Cascading Availability (Controlled Access)|UC-40]] Cascading availability exposure: `Partial`
- [[booking-use-cases-v3#UC-41: The Filler Booking Discount|UC-41]] Filler discount auto-campaigns: `Partial`
- [[booking-use-cases-v3#UC-42: The Host Cancellation Penalty|UC-42]] Host cancellation penalties: `Partial`
- [[booking-use-cases-v3#UC-43: The Dynamic Duration with Price Adjustment|UC-43]] Dynamic duration + final adjustment: `Partial`
- [[booking-use-cases-v3#UC-44: The Overtime Prediction and Avoidance|UC-44]] Overtime prediction and avoidance: `Poor`
- [[booking-use-cases-v3#UC-45: The Service-Specific Availability|UC-45]] Service-specific availability by host: `Perfect` (now service calendars exist)
- [[booking-use-cases-v3#UC-46: The Available by Default vs Unavailable by Default|UC-46]] Available-by-default vs unavailable-by-default: `Perfect`
- [[booking-use-cases-v3#UC-47: The Use-It-Anytime Membership|UC-47]] Use-it-anytime membership allowance: `Partial`
- [[booking-use-cases-v3#UC-48: The Auction-Based Booking|UC-48]] Auction-based booking: `Not`
- [[booking-use-cases-v3#UC-49: The AI Agent Notes|UC-49]] Public/private/AI notes: `Partial`
- [[booking-use-cases-v3#UC-50: The Complete Audit Trail|UC-50]] Complete immutable audit trail + retention policy profiles: `Partial`
- [[booking-use-cases-v3#UC-51: The Multi-Level Organization Booking|UC-51]] Cross-organization booking contracts: `Not`
- [[booking-use-cases-v3#UC-52: The Hybrid Virtual + In-Person|UC-52]] Hybrid virtual + in-person in one booking: `Partial`
- [[booking-use-cases-v3#UC-53: The Virtual Waiting Room|UC-53]] Virtual waiting room queue: `Poor`
- [[booking-use-cases-v3#UC-54: The Anonymous/Sensitive Booking|UC-54]] Anonymous/sensitive booking mode: `Poor`
- [[booking-use-cases-v3#UC-55: The Referral Unlock Reward|UC-55]] Referral unlock rewards: `Not`
- [[booking-use-cases-v3#UC-56: The Booking Transfer|UC-56]] Booking transfer workflow: `Partial`
- [[booking-use-cases-v3#UC-57: The Impulse Booking Cooldown|UC-57]] Impulse cooldown hold: `Partial`
- [[booking-use-cases-v3#UC-58: The Seasonal Availability Flip|UC-58]] Seasonal availability flip: `Perfect`
- [[booking-use-cases-v3#UC-59: The Simultaneous Multi-Location|UC-59]] Simultaneous multi-location atomic booking: `Not`
- [[booking-use-cases-v3#UC-60: The Mandatory Follow-Up Lock|UC-60]] Mandatory linked follow-up lock: `Partial`

## Part 7 (UC-61..UC-70)

- [[booking-use-cases-v3#UC-61: The Insurance Eligibility Re-Check|UC-61]] Insurance re-check and preauth expiry: `Partial`
- [[booking-use-cases-v3#UC-62: The Split-Tender Payment|UC-62]] Split tender payments: `Perfect`
- [[booking-use-cases-v3#UC-63: The Chargeback/Dispute Lifecycle|UC-63]] Chargeback lifecycle: `Perfect`
- [[booking-use-cases-v3#UC-64: The Fraud-Risk Manual Review|UC-64]] Fraud-risk manual review queue: `Partial`
- [[booking-use-cases-v3#UC-65: The Idempotent API Retry|UC-65]] Idempotent API retry: `Perfect`
- [[booking-use-cases-v3#UC-66: The Offline Front Desk Mode|UC-66]] Offline front desk mode + reconciliation: `Poor`
- [[booking-use-cases-v3#UC-67: The External Channel Sync|UC-67]] External channel sync + oversell controls: `Partial`
- [[booking-use-cases-v3#UC-68: The Data Residency Tenant Boundary|UC-68]] Data residency tenant boundary: `Poor`
- [[booking-use-cases-v3#UC-69: The Legal Blackout Window|UC-69]] Legal blackout windows: `Partial`
- [[booking-use-cases-v3#UC-70: The Deletion vs Retention Conflict|UC-70]] Delete vs retention conflict workflow: `Partial`

## Part 8 (UC-71..UC-81)

- [[booking-use-cases-v3#UC-71: The Phone/Call Booking Fee|UC-71]] Phone booking fee: `Perfect`
- [[booking-use-cases-v3#UC-72: The Paid Discovery Call|UC-72]] Paid discovery call + crediting: `Partial`
- [[booking-use-cases-v3#UC-73: The Manual Day-and-Hour Pricing Grid|UC-73]] Manual day/hour pricing grid: `Perfect`
- [[booking-use-cases-v3#UC-74: The Holiday and Special-Date Pricing Override|UC-74]] Holiday/date overrides: `Perfect`
- [[booking-use-cases-v3#UC-75: The After-Hours and Emergency Callout Fee|UC-75]] After-hours and emergency callout fee: `Perfect`
- [[booking-use-cases-v3#UC-76: The One-Page Quick Setup vs Advanced Builder|UC-76]] Quick setup vs advanced builder: `Partial` (schema okay, setup UX mode not modeled explicitly)
- [[booking-use-cases-v3#UC-77: The On-Site Visit Fee (Charged on Arrival)|UC-77]] On-site visit fee charged on arrival: `Perfect`
- [[booking-use-cases-v3#UC-78: The Walk-In Queue with Estimates (Barber Shop)|UC-78]] Walk-in queue with estimates: `Poor`
- [[booking-use-cases-v3#UC-79: The Government Service Queue (DMV/Office)|UC-79]] Government queue/ticket windows: `Poor`
- [[booking-use-cases-v3#UC-80: The Fixed-Price Variable-Time Service (Car Wash)|UC-80]] Fixed-price variable-time queue service: `Poor`
- [[booking-use-cases-v3#UC-81: The Host-Dependent and Complexity-Based Duration|UC-81]] Host-dependent + complexity-based duration: `Poor`

## Part 9 (UC-82..UC-86)

- [[booking-use-cases-v3#UC-82: The Scheduled Shuttle Service (Airport/Route-Based)|UC-82]] Scheduled shuttle routes: `Not`
- [[booking-use-cases-v3#UC-83: The On-Demand Shuttle (Zone-Based Pickup)|UC-83]] On-demand zone shuttle pooling: `Not`
- [[booking-use-cases-v3#UC-84: The Limo/Black Car Service (Scheduled by Time)|UC-84]] Limo scheduled itinerary service: `Not`
- [[booking-use-cases-v3#UC-85: The Limo Service (Point-to-Point Transfer)|UC-85]] Limo point-to-point transfer with flight sync: `Not`
- [[booking-use-cases-v3#UC-86: The Charter Bus/Group Transportation|UC-86]] Charter bus quote/deposit/driver regulations: `Not`

## Part 10 (UC-87..UC-90)

- [[booking-use-cases-v3#UC-87: The Tool Rental (Home Depot Style)|UC-87]] Tool rental with condition/deposit/late fees: `Poor`
- [[booking-use-cases-v3#UC-88: The Party/Event Equipment Rental|UC-88]] Event equipment rental delivery/setup: `Partial`
- [[booking-use-cases-v3#UC-89: The Vehicle Rental (Car/Truck/Van)|UC-89]] Vehicle rental with mileage/one-way: `Partial`
- [[booking-use-cases-v3#UC-90: The Peer-to-Peer Equipment Rental (Fat Llama Style)|UC-90]] Peer-to-peer equipment rental with mediation: `Poor`

## Part 11 (UC-91..UC-95)

- [[booking-use-cases-v3#UC-91: The Virtual Consultation Service|UC-91]] Virtual consultation with pre-intake and link handling: `Partial`
- [[booking-use-cases-v3#UC-92: The Async Virtual Service (Review & Response)|UC-92]] Async review-and-return service: `Poor`
- [[booking-use-cases-v3#UC-93: The Live Virtual Class/Workshop|UC-93]] Live virtual workshop/class operations: `Partial`
- [[booking-use-cases-v3#UC-94: The Virtual Office/Meeting Room|UC-94]] Virtual office/meeting room product: `Partial`
- [[booking-use-cases-v3#UC-95: The Virtual Fitness Class Subscription|UC-95]] Virtual fitness subscription operations: `Partial`

## Part 12 (UC-96..UC-102)

- [[booking-use-cases-v3#UC-96: The Classroom/Lab Booking (University/Corporate)|UC-96]] Classroom/lab recurring booking: `Partial`
- [[booking-use-cases-v3#UC-97: The Training Room (Corporate)|UC-97]] Corporate training room ops: `Partial`
- [[booking-use-cases-v3#UC-98: The Virtual Classroom (K-12/Higher Ed)|UC-98]] Virtual classroom with SIS/LMS style flows: `Partial`
- [[booking-use-cases-v3#UC-99: The Virtual Workshop Room (Interactive)|UC-99]] Interactive virtual workshop room: `Partial`
- [[booking-use-cases-v3#UC-100: The Exam/Proctored Session|UC-100]] Proctored exam workflow: `Poor`
- [[booking-use-cases-v3#UC-101: The Hybrid Classroom (In-Person + Remote)|UC-101]] Hybrid classroom parity model: `Partial`
- [[booking-use-cases-v3#UC-102: The Pop-Up/Temporarily Bookable Space|UC-102]] Pop-up temporary space policy: `Partial`

## Part 13 (UC-103..UC-106)

- [[booking-use-cases-v3#UC-103: The Subscription Box with Appointment|UC-103]] Subscription box + consultation: `Partial`
- [[booking-use-cases-v3#UC-104: The Membership with Included Services|UC-104]] Membership with included service credits: `Partial`
- [[booking-use-cases-v3#UC-105: The Field Service with Parts Ordering|UC-105]] Field service with parts ordering + follow-up: `Partial`
- [[booking-use-cases-v3#UC-106: The Curated Experience/Itinerary|UC-106]] Curated multi-stop itinerary service: `Partial`

---

## 2) What This Means in Plain English

Current schema is strong at:
- core booking, availability, pricing, fees, payments, waitlists, tenancy.

Current schema is weakest at:
- queue-native operations,
- transport/routing,
- maintenance/condition lifecycles,
- cross-org contracting,
- privacy/compliance workflow primitives,
- marketplace/auction patterns,
- async deliverable jobs.

So v4 should not "patch" these with more nullable columns.  
It should add a clean, modular spine.

---

## 3) v4 Blueprint (ELI5 Mental Model)

We split the world into 6 boxes:

1. `Offer` box: what customer can buy.
2. `Supply` box: what can fulfill it (host/asset/venue/vehicle/room).
3. `Time` box: when supply is available.
4. `Fulfillment` box: the work plan created after purchase.
5. `Money` box: quote, charge, refund, dispute.
6. `Governance` box: rules, audit, compliance, tenant boundaries.

If each box is clean, new use cases become composition, not hacks.

---

## 4) Proposed v4 Schema Modules

## A) Offer Catalog (Versioned and Publishable)

### New core tables
- `offers`
  - business-facing identity: name, slug, status.
  - execution mode: `slot`, `queue`, `request`, `auction`, `async`, `route_trip`, `open_access`, `itinerary`.

- `offer_versions`
  - immutable published version snapshots.
  - pricing model, duration model, policy model, capacity model.

- `offer_components`
  - defines required/optional components.
  - can point to specific resources, tags, categories, or capability types.

- `offer_component_seats`
  - seat classes, min/max/default quantities, price deltas.

Why:
- lets you ship "simple now, advanced later" without mutating old bookings.
- solves [[booking-use-cases-v3#UC-76: The One-Page Quick Setup vs Advanced Builder|UC-76]] cleanly.

## B) Supply Model (Keep resources, extend types)

### Keep and extend
- keep `resources` as canonical supply abstraction.
- add resource subtypes through extension tables, not enum explosion in one row.

### New/extended tables
- `resource_capability_templates` (skill/equipment/category capability dictionary)
- `resource_capability_assignments`
- `resource_condition_reports` (before/after condition evidence)
- `resource_maintenance_policies`
- `resource_maintenance_work_orders`
- `resource_usage_counters`

Why:
- covers [[booking-use-cases-v3#UC-12: The Equipment-Required Service with Auto-Maintenance|UC-12]] / [[booking-use-cases-v3#UC-27: The Equipment Sharing Pool|UC-27]] / [[booking-use-cases-v3#UC-87: The Tool Rental (Home Depot Style)|UC-87]] / [[booking-use-cases-v3#UC-90: The Peer-to-Peer Equipment Rental (Fat Llama Style)|UC-90]] / [[booking-use-cases-v3#UC-105: The Field Service with Parts Ordering|UC-105]] properly.

## C) Time & Availability (Keep current, add overlays + resolution)

### Keep
- `calendars` and `availability_rules` stay core.

### Add
- `calendar_overlays`
  - explicit layer model: base hours, blackout, seasonal, emergency override.

- `availability_resolution_runs`
  - stores computed decision traces for debugging and support.

- `capacity_pools`
  - shared capacity objects for overbooking/queue/service pools.

Why:
- prevents "why is this unavailable?" chaos.
- enables [[booking-use-cases-v3#UC-28: The Airline-Style Overbooking|UC-28]] / [[booking-use-cases-v3#UC-40: The Cascading Availability (Controlled Access)|UC-40]] with explicit inventory semantics.

## D) Fulfillment Core (Replace booking monolith with order + units)

### New core tables
- `booking_orders`
  - customer intent/contract root.

- `fulfillment_units`
  - atomic units of work/time (one order can produce many units).

- `fulfillment_dependencies`
  - prerequisite graph (`must_follow`, `same_day`, `min_gap`, `hard_block_if_missing`).

- `fulfillment_assignments`
  - actual resource assignment per unit.

- `fulfillment_checkpoints`
  - arrival, check-in, pickup, dropoff, completion milestones.

Why:
- naturally handles [[booking-use-cases-v3#UC-24: The Multi-Step Medical Procedure|UC-24]] / [[booking-use-cases-v3#UC-25: The Multi-Resource Event|UC-25]] / [[booking-use-cases-v3#UC-33: The Cascading Appointment|UC-33]] / [[booking-use-cases-v3#UC-59: The Simultaneous Multi-Location|UC-59]] / [[booking-use-cases-v3#UC-60: The Mandatory Follow-Up Lock|UC-60]] / [[booking-use-cases-v3#UC-106: The Curated Experience/Itinerary|UC-106]].
- avoids stuffing every complex path into one booking row.

## E) Queue Domain (First-Class)

### New tables
- `queues`
- `queue_entries`
- `queue_tickets`
- `queue_events`
- `service_time_observations`
- `wait_time_predictions`

Why:
- covers [[booking-use-cases-v3#UC-53: The Virtual Waiting Room|UC-53]] / [[booking-use-cases-v3#UC-78: The Walk-In Queue with Estimates (Barber Shop)|UC-78]] / [[booking-use-cases-v3#UC-79: The Government Service Queue (DMV/Office)|UC-79]] / [[booking-use-cases-v3#UC-80: The Fixed-Price Variable-Time Service (Car Wash)|UC-80]] / [[booking-use-cases-v3#UC-81: The Host-Dependent and Complexity-Based Duration|UC-81]] without pretending queue is an appointment.

## F) Transportation Domain (First-Class)

### New tables
- `fleet_vehicles`
- `transport_routes`
- `transport_route_stops`
- `transport_trips`
- `trip_stop_inventory`
- `trip_manifests`
- `dispatch_tasks`
- `eta_events`

Why:
- required for [[booking-use-cases-v3#UC-82: The Scheduled Shuttle Service (Airport/Route-Based)|UC-82]] through [[booking-use-cases-v3#UC-86: The Charter Bus/Group Transportation|UC-86]].

## G) Marketplace + Cross-Biz Domain

### New tables
- `marketplace_listings`
- `bids`
- `auctions`
- `cross_biz_contracts`
- `cross_biz_orders`
- `revenue_share_rules`
- `referral_programs`
- `referral_events`
- `reward_grants`

Why:
- required for [[booking-use-cases-v3#UC-23: The Franchise Chain with Royalty|UC-23]] / [[booking-use-cases-v3#UC-32: The Reverse Auction Marketplace|UC-32]] / [[booking-use-cases-v3#UC-48: The Auction-Based Booking|UC-48]] / [[booking-use-cases-v3#UC-51: The Multi-Level Organization Booking|UC-51]] / [[booking-use-cases-v3#UC-55: The Referral Unlock Reward|UC-55]].

## H) Compliance, Privacy, Residency Domain

### New tables
- `tenant_compliance_profiles`
- `data_residency_policies`
- `retention_policies`
- `legal_holds`
- `privacy_identity_modes`
- `data_subject_requests`
- `redaction_jobs`

Why:
- covers [[booking-use-cases-v3#UC-54: The Anonymous/Sensitive Booking|UC-54]] / [[booking-use-cases-v3#UC-68: The Data Residency Tenant Boundary|UC-68]] / [[booking-use-cases-v3#UC-70: The Deletion vs Retention Conflict|UC-70]] / [[booking-use-cases-v3#UC-100: The Exam/Proctored Session|UC-100]] reliably.

## I) Async/Job and Review Workflows

### New tables
- `review_queues` (fraud/manual review, approval queues)
- `workflow_instances`
- `workflow_steps`
- `workflow_decisions`
- `async_deliverables` (for [[booking-use-cases-v3#UC-92: The Async Virtual Service (Review & Response)|UC-92]] style submit-review-return)

Why:
- covers [[booking-use-cases-v3#UC-6: The Medical Clinic with Approval Workflow|UC-6]] / [[booking-use-cases-v3#UC-64: The Fraud-Risk Manual Review|UC-64]] / [[booking-use-cases-v3#UC-92: The Async Virtual Service (Review & Response)|UC-92]] without custom workflow code per feature.

---

## 5) Big Invariants (Must Be True Always)

1. Every business-domain row has strict tenant boundary (`biz_id` + composite FK enforcement).
2. Every published offer is immutable (`offer_versions`).
3. Every calendar has exactly one owner, and one active calendar per owner.
4. Every fulfillment unit has deterministic status transitions.
5. Every payment movement is append-only and reconcilable.
6. Every sensitive action is auditable and policy-evaluable.
7. Queue and slot are separate execution modes, never mixed in one fake model.
8. Transportation and rental are first-class domains, not encoded in metadata blobs.

---

## 6) What I Changed My Mind On (Important Reflection)

### Earlier thought
"Maybe we can keep stretching the current booking tables with extra fields."

### Updated view
That creates brittle growth.

For v4, better approach is:
- keep stable core primitives,
- add mode-specific extension domains,
- use `offer_versions` + `fulfillment_units` as the universal center.

This gives flexibility without schema spaghetti.

---

## 7) How Simple Setup Still Stays Simple

Even with v4, simple onboarding can remain 5 steps:

1. Create one `offer` (`execution_mode = slot`).
2. Publish one `offer_version` (fixed duration + fixed price).
3. Attach one host resource.
4. Create one calendar + weekly availability.
5. Go live.

Complex businesses then "turn on" additional modules only if needed (queue, transport, marketplace, compliance packs).

---

## 8) How Complex Setup Works Without Hacks

Example: [[booking-use-cases-v3#UC-77: The On-Site Visit Fee (Charged on Arrival)|UC-77]] (on-site fee even if no repair)
- offer version defines callout policy.
- fulfillment unit has `arrival_checkpoint`.
- fee rule triggers on checkpoint.
- charge becomes normal line item.

Example: [[booking-use-cases-v3#UC-82: The Scheduled Shuttle Service (Airport/Route-Based)|UC-82]] (scheduled shuttle)
- offer mode = `route_trip`.
- booking creates trip manifest row, not fake host appointment.
- stop inventory decrements per segment.

Example: [[booking-use-cases-v3#UC-100: The Exam/Proctored Session|UC-100]] (proctored exam)
- offer mode = `slot` + compliance workflow attached.
- workflow steps enforce ID check, room scan, secure client attestations.
- result issuance remains separate from booking status.

---

## 9) Proposed v4 Build Order (Pragmatic)

### Phase 1 (foundation)
- `offers`, `offer_versions`, `fulfillment_units`, strict tenant FK pass, policy/workflow primitives.

### Phase 2 (operational depth)
- queue domain + maintenance/condition lifecycle + advanced availability overlays.

### Phase 3 (new verticals)
- transportation module + marketplace/cross-biz contracts + compliance residency/retention pack.

### Phase 4 (optimization)
- prediction tables, ranking/favorability engine, dynamic pricing optimizer, auto-dispatch strategies.

---

## 10) Final Blueprint Verdict

If the goal is:
- support all 106 scenarios,
- keep simple setup simple,
- avoid bending schema,
- remain reusable across industries,

then v4 should be:
- **modular**,
- **mode-driven**,
- **versioned**,
- **tenant-strict**,
- **fulfillment-graph-based**.

That is the best chance to stay elegant at small scale and not collapse at enterprise complexity.

---

## 11) Detailed Gap Matrix (Every `Partial`, `Poor`, `Not`)

Format:
- `Why`: why current schema is not fully native for this scenario.
- `Fix`: schema-native change needed in v4.

### Part 1 (UC-1..UC-9)

- [[booking-use-cases-v3#UC-3: The Hair Salon with Commission Tracking|UC-3]] (`Partial`) Why: commission logic is not first-class; splits are mostly app logic. Fix: add `comp_plans`, `comp_rules`, `comp_earnings_ledger`, `comp_payout_batches`.
- [[booking-use-cases-v3#UC-4: The Salon with Provider Favorability/Ranking|UC-4]] (`Partial`) Why: favorability/ranking and slot-priority policies are not modeled. Fix: add `ranking_profiles`, `ranking_events`, `slot_allocation_policies`.
- [[booking-use-cases-v3#UC-5: The Medical Clinic with Room Pairing|UC-5]] (`Partial`) Why: provider-room hard pairing is expressible but not enforced as constraint object. Fix: add `resource_pairing_rules` with hard/soft pairing semantics.
- [[booking-use-cases-v3#UC-6: The Medical Clinic with Approval Workflow|UC-6]] (`Partial`) Why: approval workflow states exist loosely, but no reusable workflow engine. Fix: add `workflow_instances`, `workflow_steps`, `workflow_decisions`, `review_queues`.
- [[booking-use-cases-v3#UC-7: The Fitness Class Studio|UC-7]] (`Partial`) Why: class capacity and waitlist exist, but equipment-per-participant assignment is not first-class. Fix: add `session_inventory_units`, `participant_inventory_assignments`.
- [[booking-use-cases-v3#UC-8: The Tutoring Center with Packages|UC-8]] (`Partial`) Why: package wallets exist, but substitute tutor and subject-eligibility matching are not modeled as capability constraints. Fix: add `resource_capability_templates`, `resource_capability_assignments`, `assignment_policies`.
- [[booking-use-cases-v3#UC-9: The Front Desk Receptionist Calendar|UC-9]] (`Partial`) Why: role-based visibility and masked views are mostly app-side. Fix: add `calendar_access_policies`, `field_visibility_policies`.

### Part 2 (UC-10..UC-15)

- [[booking-use-cases-v3#UC-11: The Multi-Provider Appointment with Commission Split|UC-11]] (`Partial`) Why: multi-provider assignment exists, but role-based compensation and fallback assignment policies are not first-class. Fix: add `assignment_role_templates`, `fallback_chains`, `comp_split_rules`.
- [[booking-use-cases-v3#UC-12: The Equipment-Required Service with Auto-Maintenance|UC-12]] (`Poor`) Why: maintenance blocks and trigger thresholds are not core entities. Fix: add `resource_usage_counters`, `resource_maintenance_policies`, `maintenance_work_orders`, and calendar overlay integration.
- [[booking-use-cases-v3#UC-13: The Multi-Day Rental with Gap Management|UC-13]] (`Partial`) Why: multi-day works, but cleanup/gap rules are not explicit reusable policy objects. Fix: add `turnover_policies` and enforce via `fulfillment_dependencies(min_gap)`.
- [[booking-use-cases-v3#UC-14: The Corporate Training with Attendance Tracking|UC-14]] (`Partial`) Why: programs/attendance exist, but company-level substitution and invoice terms are not fully structured. Fix: add `program_billing_accounts`, `participant_substitution_rules`, `invoice_terms`.
- [[booking-use-cases-v3#UC-15: The Mobile Service with Route Optimization|UC-15]] (`Poor`) Why: route optimization and travel-time-aware sloting are missing domain primitives. Fix: add transportation/dispatch module (`routes`, `dispatch_tasks`, `eta_events`).

### Part 3 (UC-16..UC-22)

- [[booking-use-cases-v3#UC-16: The Package Deal with Expiration|UC-16]] (`Partial`) Why: transfer/refund logic exists conceptually but policy graph is thin. Fix: add `entitlement_transfer_policies`, `proration_rules`, `wallet_event_reasons`.
- [[booking-use-cases-v3#UC-17: The Dynamic/Surge Pricing|UC-17]] (`Not`) Why: no algorithmic surge engine or demand signal model. Fix: add `pricing_signal_stream`, `dynamic_pricing_models`, `price_decision_logs`.
- [[booking-use-cases-v3#UC-18: The Seat Selection Venue|UC-18]] (`Not`) Why: no seat-map geometry or adjacency model. Fix: add `seat_maps`, `seat_nodes`, `seat_edges`, `seat_holds`.
- [[booking-use-cases-v3#UC-19: The Waitlist with Auto-Offer and Pricing|UC-19]] (`Partial`) Why: core waitlist exists, but advanced paid-waitlist refund/penalty policy variants are not fully first-class. Fix: add `waitlist_policy_sets`, `waitlist_fee_refund_rules`, `offer_penalty_rules`.
- [[booking-use-cases-v3#UC-21: The Recurring Subscription with Pause|UC-21]] (`Partial`) Why: recurring rules exist, but subscription-slot reservation semantics and pause guarantees are not explicit. Fix: add `subscription_slot_claims`, `pause_policies`, `credit_rollover_rules`.
- [[booking-use-cases-v3#UC-22: The Tour/Experience with Minimum Viable|UC-22]] (`Partial`) Why: min/max exists indirectly, but viability thresholds and weather cancellation policies are not first-class. Fix: add `session_viability_rules`, `weather_contingency_rules`.

### Part 4 (UC-23..UC-29)

- [[booking-use-cases-v3#UC-23: The Franchise Chain with Royalty|UC-23]] (`Not`) Why: franchise hierarchy and royalties are absent. Fix: add `org_hierarchies`, `franchise_contracts`, `royalty_rules`, `royalty_ledger_entries`.
- [[booking-use-cases-v3#UC-24: The Multi-Step Medical Procedure|UC-24]] (`Partial`) Why: linked bookings exist, but strict prerequisite DAG for care pathways is not canonical. Fix: add `fulfillment_units` + `fulfillment_dependencies` + `clinical_prerequisite_rules`.
- [[booking-use-cases-v3#UC-25: The Multi-Resource Event|UC-25]] (`Partial`) Why: multi-resource requirements exist, but quote/proposal lifecycle and staged deposits are not first-class. Fix: add `quotes`, `quote_versions`, `deposit_schedules`.
- [[booking-use-cases-v3#UC-26: The Union Production with Complex Rules|UC-26]] (`Not`) Why: labor law/union rule enforcement model is missing. Fix: add `labor_rule_sets`, `shift_constraints`, `overtime_calculators`, `compliance_violations`.
- [[booking-use-cases-v3#UC-27: The Equipment Sharing Pool|UC-27]] (`Poor`) Why: priority preemption and equipment pool dispatch logic are not native. Fix: add `priority_classes`, `preemption_rules`, `resource_pool_allocations`.
- [[booking-use-cases-v3#UC-28: The Airline-Style Overbooking|UC-28]] (`Not`) Why: controlled overbooking model and no-show prediction are missing. Fix: add `capacity_pools`, `overbooking_policies`, `no_show_models`.
- [[booking-use-cases-v3#UC-29: The Conditional/Rule-Based Booking|UC-29]] (`Partial`) Why: prerequisites are currently app-composed from scattered tables. Fix: add unified `policy_rules` + `eligibility_evaluations`.

### Part 5 (UC-30..UC-35)

- [[booking-use-cases-v3#UC-30: The Standing Reservation|UC-30]] (`Partial`) Why: recurring exists, but perpetual standing-reservation contract semantics are missing. Fix: add `standing_reservation_contracts` with pause/priority behavior.
- [[booking-use-cases-v3#UC-31: The Floating Appointment|UC-31]] (`Poor`) Why: floating time-window assignments are not first-class objects. Fix: add `assignment_windows`, `floating_requests`, `slot_commitments`.
- [[booking-use-cases-v3#UC-32: The Reverse Auction Marketplace|UC-32]] (`Not`) Why: marketplace bidding/award model is absent. Fix: add `marketplace_listings`, `bids`, `awards`, `marketplace_fees`.
- [[booking-use-cases-v3#UC-33: The Cascading Appointment|UC-33]] (`Partial`) Why: followups exist, but dependency graph for chained services is weak. Fix: standardize on `fulfillment_dependencies`.
- [[booking-use-cases-v3#UC-34: The Multi-Timezone Coordination|UC-34]] (`Partial`) Why: timezone support exists, fairness rotation logic does not. Fix: add `coordination_policies`, `fairness_rotation_state`.
- [[booking-use-cases-v3#UC-35: The Disaster Recovery Mass Reschedule|UC-35]] (`Partial`) Why: incident tables exist, but automated mass-reschedule plans and triage policies are limited. Fix: add `reschedule_playbooks`, `triage_rules`, `bulk_reassignment_jobs`.

### Part 6 (UC-36..UC-60)

- [[booking-use-cases-v3#UC-38: The Product + Service Bundle|UC-38]] (`Partial`) Why: service+product bundles are possible but bundle composition/versioning is not first-class. Fix: add `offer_bundles`, `bundle_components`, `bundle_pricing_rules`.
- [[booking-use-cases-v3#UC-39: The Program with Attendance Tracking|UC-39]] (`Partial`) Why: programs exist, but graduation criteria and makeup path rules are not strict policy entities. Fix: add `completion_rules`, `makeup_equivalency_rules`.
- [[booking-use-cases-v3#UC-40: The Cascading Availability (Controlled Access)|UC-40]] (`Partial`) Why: availability exists, but controlled slot-release strategy is not explicit. Fix: add `availability_release_policies` and `slot_release_jobs`.
- [[booking-use-cases-v3#UC-41: The Filler Booking Discount|UC-41]] (`Partial`) Why: pricing rules exist, but campaign targeting and timed offer windows are not first-class. Fix: add `promo_campaigns`, `offer_windows`, `audience_segments`.
- [[booking-use-cases-v3#UC-42: The Host Cancellation Penalty|UC-42]] (`Partial`) Why: penalties can be charged, but favorability/strike systems are not modeled. Fix: add `host_reliability_profiles`, `penalty_events`, `suspension_rules`.
- [[booking-use-cases-v3#UC-43: The Dynamic Duration with Price Adjustment|UC-43]] (`Partial`) Why: variable duration works, but estimate-to-actual adjustment policy lacks explicit structure. Fix: add `duration_estimate_models`, `overtime_rate_rules`, `post_service_adjustments`.
- [[booking-use-cases-v3#UC-44: The Overtime Prediction and Avoidance|UC-44]] (`Poor`) Why: overtime prediction engine is missing. Fix: add `staff_capacity_forecasts`, `overtime_projection_events`, `assignment_recommendations`.
- [[booking-use-cases-v3#UC-47: The Use-It-Anytime Membership|UC-47]] (`Partial`) Why: memberships exist, but real-time access gate/entry tracking is not a first-class attendance gate domain. Fix: add `access_sessions`, `access_gate_events`, `allowance_enforcement_rules`.
- [[booking-use-cases-v3#UC-48: The Auction-Based Booking|UC-48]] (`Not`) Why: auction lifecycle tables are missing. Fix: add `auctions`, `auction_bids`, `auction_extensions`, `auction_settlements`.
- [[booking-use-cases-v3#UC-49: The AI Agent Notes|UC-49]] (`Partial`) Why: note visibility exists, but AI note provenance and confidence/audit are not first-class. Fix: add `ai_note_sources`, `ai_note_confidence`, `ai_note_actions`.
- [[booking-use-cases-v3#UC-50: The Complete Audit Trail|UC-50]] (`Partial`) Why: audit exists, but policy-driven retention and immutable guarantees per legal profile are incomplete. Fix: add `retention_policies`, `audit_immutability_controls`, `legal_holds`.
- [[booking-use-cases-v3#UC-51: The Multi-Level Organization Booking|UC-51]] (`Not`) Why: cross-org transactional contract model does not exist. Fix: add `cross_biz_contracts`, `cross_biz_orders`, `revenue_share_rules`.
- [[booking-use-cases-v3#UC-52: The Hybrid Virtual + In-Person|UC-52]] (`Partial`) Why: segment model exists, but modality transitions and synchronized timing policies are not standardized. Fix: add `modality_transition_rules` on fulfillment units.
- [[booking-use-cases-v3#UC-53: The Virtual Waiting Room|UC-53]] (`Poor`) Why: waiting-room queue semantics are not first-class queue objects. Fix: use queue module (`queues`, `queue_entries`, `queue_events`) for virtual sessions.
- [[booking-use-cases-v3#UC-54: The Anonymous/Sensitive Booking|UC-54]] (`Poor`) Why: pseudonymous booking and staged identity reveal are not modeled. Fix: add `privacy_identity_modes`, `identity_reveal_policies`, `secure_alias_maps`.
- [[booking-use-cases-v3#UC-55: The Referral Unlock Reward|UC-55]] (`Not`) Why: referral tracking and reward unlock state machine are absent. Fix: add `referral_programs`, `referral_events`, `reward_grants`.
- [[booking-use-cases-v3#UC-56: The Booking Transfer|UC-56]] (`Partial`) Why: transfers exist but transfer policy/eligibility windows are app-driven. Fix: add `transfer_policies`, `transfer_approval_rules`.
- [[booking-use-cases-v3#UC-57: The Impulse Booking Cooldown|UC-57]] (`Partial`) Why: reservation holds exist, but dedicated cooldown contract semantics are not explicit. Fix: add `cooldown_policies` with auto-confirm timers.
- [[booking-use-cases-v3#UC-59: The Simultaneous Multi-Location|UC-59]] (`Not`) Why: atomic multi-location requirement in one booking is not a first-class dependency type. Fix: add `fulfillment_dependencies(type=all_or_nothing_parallel)`.
- [[booking-use-cases-v3#UC-60: The Mandatory Follow-Up Lock|UC-60]] (`Partial`) Why: followups exist, but hard-lock cancellation constraints and clinical override workflow are not first-class. Fix: add `mandatory_followup_rules` + workflow enforcement.

### Part 7 (UC-61..UC-70)

- [[booking-use-cases-v3#UC-61: The Insurance Eligibility Re-Check|UC-61]] (`Partial`) Why: insurance fields can live in metadata but re-check cadence/preauth expiry are not explicit. Fix: add `coverage_checks`, `preauth_records`, `recheck_jobs`.
- [[booking-use-cases-v3#UC-64: The Fraud-Risk Manual Review|UC-64]] (`Partial`) Why: review queue concept is not centralized yet. Fix: add `risk_signals`, `review_queues`, `review_decisions`.
- [[booking-use-cases-v3#UC-66: The Offline Front Desk Mode|UC-66]] (`Poor`) Why: offline action log and reconciliation contracts are missing. Fix: add `offline_action_batches`, `sync_conflict_records`, `reconciliation_decisions`.
- [[booking-use-cases-v3#UC-67: The External Channel Sync|UC-67]] (`Partial`) Why: external sync exists, but inventory reservation policy and temporary oversell locks are not explicit. Fix: add `channel_inventory_policies`, `sync_guard_locks`.
- [[booking-use-cases-v3#UC-68: The Data Residency Tenant Boundary|UC-68]] (`Poor`) Why: strict region residency controls are not modeled as tenant policy objects. Fix: add `data_residency_policies`, `region_scoped_storage_bindings`, `access_region_audits`.
- [[booking-use-cases-v3#UC-69: The Legal Blackout Window|UC-69]] (`Partial`) Why: blackout/lead-time rules are possible in pricing/availability but legal override traceability is weak. Fix: add `legal_blackout_rules`, `override_authorizations`.
- [[booking-use-cases-v3#UC-70: The Deletion vs Retention Conflict|UC-70]] (`Partial`) Why: deletion workflows are not first-class with retention exceptions. Fix: add `data_subject_requests`, `redaction_jobs`, `retention_holds`.

### Part 8 (UC-71..UC-81)

- [[booking-use-cases-v3#UC-72: The Paid Discovery Call|UC-72]] (`Partial`) Why: paid call + credit-forward behavior is doable but not normalized as offer credit rule. Fix: add `credit_forward_rules` tied to offer versions.
- [[booking-use-cases-v3#UC-76: The One-Page Quick Setup vs Advanced Builder|UC-76]] (`Partial`) Why: schema supports both simple/advanced, but explicit setup-mode metadata and migration state are not modeled. Fix: add `setup_profiles` + `complexity_state` per biz/offer.
- [[booking-use-cases-v3#UC-78: The Walk-In Queue with Estimates (Barber Shop)|UC-78]] (`Poor`) Why: walk-in queue estimates are not first-class operational tables. Fix: queue module + service-time observation model.
- [[booking-use-cases-v3#UC-79: The Government Service Queue (DMV/Office)|UC-79]] (`Poor`) Why: ticket windows and counter assignment are not native entities. Fix: add `service_counters`, `queue_tickets`, `counter_assignments`.
- [[booking-use-cases-v3#UC-80: The Fixed-Price Variable-Time Service (Car Wash)|UC-80]] (`Poor`) Why: fixed-price/variable-time queue pattern lacks native mode. Fix: execution mode `queue` + `estimate_ranges` + `throughput_stats`.
- [[booking-use-cases-v3#UC-81: The Host-Dependent and Complexity-Based Duration|UC-81]] (`Poor`) Why: complexity-based host-duration estimation lacks explicit model. Fix: add `complexity_models`, `provider_duration_profiles`.

### Part 9 (UC-82..UC-86)

- [[booking-use-cases-v3#UC-82: The Scheduled Shuttle Service (Airport/Route-Based)|UC-82]] (`Not`) Why: route-stop-seat inventory for scheduled shuttles is absent. Fix: add transport module (`routes`, `route_stops`, `trips`, `trip_stop_inventory`).
- [[booking-use-cases-v3#UC-83: The On-Demand Shuttle (Zone-Based Pickup)|UC-83]] (`Not`) Why: on-demand pooled zone dispatch primitives are absent. Fix: add `service_zones`, `dispatch_tasks`, `pooling_groups`, `eta_events`.
- [[booking-use-cases-v3#UC-84: The Limo/Black Car Service (Scheduled by Time)|UC-84]] (`Not`) Why: multi-stop limo itinerary and chauffeur assignment with timing constraints are not first-class. Fix: add `trip_itineraries`, `chauffeur_assignments`, `stop_schedules`.
- [[booking-use-cases-v3#UC-85: The Limo Service (Point-to-Point Transfer)|UC-85]] (`Not`) Why: point-to-point transfer + flight-sync behavior has no dedicated domain. Fix: add `transfer_orders`, `flight_tracking_links`, `waiting_time_rules`.
- [[booking-use-cases-v3#UC-86: The Charter Bus/Group Transportation|UC-86]] (`Not`) Why: charter quote/deposit/regulation model does not exist. Fix: add `transport_quotes`, `driver_compliance_rules`, `deposit_schedules`.

### Part 10 (UC-87..UC-90)

- [[booking-use-cases-v3#UC-87: The Tool Rental (Home Depot Style)|UC-87]] (`Poor`) Why: rental-specific condition/deposit/late-return lifecycle is only partially represented. Fix: add `rental_contracts`, `condition_reports`, `return_assessments`, `deposit_holds`.
- [[booking-use-cases-v3#UC-88: The Party/Event Equipment Rental|UC-88]] (`Partial`) Why: event equipment rental works via resources + bookings, but delivery/setup windows and venue coordination rules are not first-class. Fix: add `delivery_windows`, `setup_tasks`, `coordination_constraints`.
- [[booking-use-cases-v3#UC-89: The Vehicle Rental (Car/Truck/Van)|UC-89]] (`Partial`) Why: mileage and one-way pricing can be derived, but no native vehicle-rental contract model. Fix: add `vehicle_rental_contracts`, `mileage_logs`, `fuel_policies`.
- [[booking-use-cases-v3#UC-90: The Peer-to-Peer Equipment Rental (Fat Llama Style)|UC-90]] (`Poor`) Why: peer-to-peer trust/claim/mediation workflow is not modeled. Fix: add `owner_approval_flows`, `damage_claims`, `mediation_cases`, `trust_scores`.

### Part 11 (UC-91..UC-95)

- [[booking-use-cases-v3#UC-91: The Virtual Consultation Service|UC-91]] (`Partial`) Why: virtual sessions are possible, but pre-intake/tech-check/room-state are not first-class entities. Fix: add `session_prechecks`, `virtual_room_sessions`, `connection_events`.
- [[booking-use-cases-v3#UC-92: The Async Virtual Service (Review & Response)|UC-92]] (`Poor`) Why: async deliverable lifecycle is not represented by booking-slot tables. Fix: add mode `async` + `async_deliverables`, `review_cycles`, `deadline_states`.
- [[booking-use-cases-v3#UC-93: The Live Virtual Class/Workshop|UC-93]] (`Partial`) Why: live classes are covered partly by programs, but interactive workshop controls are not first-class. Fix: add `session_interaction_settings`, `breakout_assignments`, `recording_access_rules`.
- [[booking-use-cases-v3#UC-94: The Virtual Office/Meeting Room|UC-94]] (`Partial`) Why: persistent virtual room product semantics are not explicit. Fix: add `virtual_room_templates`, `persistent_room_assignments`.
- [[booking-use-cases-v3#UC-95: The Virtual Fitness Class Subscription|UC-95]] (`Partial`) Why: membership covers pricing, but virtual-fitness operational telemetry and policy are not first-class. Fix: add `virtual_participation_events`, `camera_policy_rules`, `engagement_metrics`.

### Part 12 (UC-96..UC-102)

- [[booking-use-cases-v3#UC-96: The Classroom/Lab Booking (University/Corporate)|UC-96]] (`Partial`) Why: recurring room booking works, but academic calendar conflict domain is not first-class. Fix: add `academic_calendars`, `term_exceptions`, `priority_booking_windows`.
- [[booking-use-cases-v3#UC-97: The Training Room (Corporate)|UC-97]] (`Partial`) Why: training rooms are possible, but AV support/material logistics are not modeled. Fix: add `facility_support_tasks`, `material_orders`, `trainer_access_passes`.
- [[booking-use-cases-v3#UC-98: The Virtual Classroom (K-12/Higher Ed)|UC-98]] (`Partial`) Why: enrollment/attendance exists, but SIS/LMS integrations and gradebook linkage are not first-class. Fix: add `roster_sync_links`, `gradebook_entries`, `assignment_submissions`.
- [[booking-use-cases-v3#UC-99: The Virtual Workshop Room (Interactive)|UC-99]] (`Partial`) Why: interactive workshop artifacts are not first-class data objects. Fix: add `workshop_artifacts`, `poll_results`, `voting_rounds`.
- [[booking-use-cases-v3#UC-100: The Exam/Proctored Session|UC-100]] (`Poor`) Why: proctoring/identity verification chain is not represented as compliance workflow primitives. Fix: add `exam_sessions`, `proctor_events`, `identity_verifications`, `security_attestations`.
- [[booking-use-cases-v3#UC-101: The Hybrid Classroom (In-Person + Remote)|UC-101]] (`Partial`) Why: hybrid mode works via segments, but parity controls and modality switching policies are not explicit. Fix: add `hybrid_participation_rules`, `modality_switch_events`.
- [[booking-use-cases-v3#UC-102: The Pop-Up/Temporarily Bookable Space|UC-102]] (`Partial`) Why: temporary availability can be set, but pop-up policy package (insurance/permit/bond) is not normalized. Fix: add `temporary_space_policies`, `permit_records`, `bond_holds`.

### Part 13 (UC-103..UC-106)

- [[booking-use-cases-v3#UC-103: The Subscription Box with Appointment|UC-103]] (`Partial`) Why: subscription and consultation can be linked, but preference-to-box fulfillment loop is not first-class. Fix: add `subscription_cycles`, `preference_profiles`, `consultation_to_fulfillment_links`.
- [[booking-use-cases-v3#UC-104: The Membership with Included Services|UC-104]] (`Partial`) Why: membership credits exist, but included-service entitlement catalogs and guest-pass rules are not explicit. Fix: add `membership_entitlements`, `guest_pass_rules`, `priority_window_rules`.
- [[booking-use-cases-v3#UC-105: The Field Service with Parts Ordering|UC-105]] (`Partial`) Why: multi-visit repair is possible, but parts ordering and warranty graph are not first-class. Fix: add `parts_orders`, `warranty_records`, `repair_case_workflows`.
- [[booking-use-cases-v3#UC-106: The Curated Experience/Itinerary|UC-106]] (`Partial`) Why: multi-stop itinerary can be emulated with linked bookings, but coordinated vendor timeline and fallback plans are not first-class. Fix: add `itineraries`, `itinerary_stops`, `vendor_commitments`, `contingency_plans`.

---

## 12) Quick Read: If You Want One Rule

When a use case is not `Perfect`, the fix is almost always the same pattern:
- move from loosely structured app logic/JSON,
- to explicit domain tables + constraints + state machines,
- and connect them through `offer_versions` and `fulfillment_units`.

That keeps schema flexible without becoming vague.
