---
date: 2026-02-21
tags:
  - schema
  - guide
  - definitive
  - eli5
  - booking
  - bizing
  - v0
  - playbook
---

# The Definitive Guide to the Bizing Schema (v0, ELI5)

Source links:
- Use cases: [[booking-use-cases-v3]]
- Coverage report: [[booking-schema-v0-coverage-report]]
- Canonical schema barrel: `/Users/ameer/projects/bizing/packages/db/src/schema/canonical.ts`
- Canonical schema map: `/Users/ameer/projects/bizing/packages/db/src/schema/SCHEMA.md`

Regenerated on **2026-02-21** against the latest canonical schema.

---

## 0) Latest Refresh Delta (2026-02-21)

- Coverage rerun status: `257/257` UCs mapped, with `#full = 144`, `#strong = 113`, `#partial = 0`, `#gap = 0` (see [[booking-schema-v0-coverage-report]]).
- Contact backbone is now first-class and reusable: `crm_contacts` + `crm_contact_channels` are the shared identity/endpoint layer used across CRM, quotes, marketing audiences, and commerce preference flows.
- Actor identities in quote acceptance are now normalized to contact/subject anchors (`decided_by_crm_contact_id` or `decided_by_subject_type/id`) to avoid repeated user/group pairs.
- Active-row uniqueness for nullable anchor models was hardened using split partial unique indexes (contact path vs subject path), preventing duplicate “active” rows under PostgreSQL `NULL` semantics.

---

### Guide Series Convention

Focused setup guides use a shared section sequence so they are easy to scan and compare:
`Latest Schema Notes` -> `Who This Is For` -> `Core Backbone` -> `Setup Playbook` -> `High-Value Patterns` -> `Common Mistakes` -> `Health Checklist`.

---

## 1) What This Schema Is For

This schema is one shared business backbone for:
- selling time,
- selling services,
- selling products,
- scheduling/allocating resources,
- tracking fulfillment,
- tracking money,
- auditing everything.

ELI5:
A haircut, a workshop seat, a room rental, and a product shipment should all use one coherent machine, not disconnected mini-systems.

---

## 2) The Core Mental Model (The 8 Building Blocks)

1. **Sellable**
- Commercial identity for anything purchasable.
- Core table: `sellables`.

2. **Resource**
- Anything that can fulfill work in time (host/asset/venue/company-host).
- Core table: `resources`.

3. **Calendar**
- Time policy and availability control layer.
- Core tables: `calendars`, `calendar_bindings`, `availability_rules`, overlays/gates/holds.

4. **Order**
- Commercial contract with line-level traceability.
- Core tables: `booking_orders`, `booking_order_lines`, `booking_order_line_sellables`.

5. **Fulfillment Unit**
- Executable work unit produced from demand.
- Core tables: `fulfillment_units`, dependencies, assignments, checkpoints.

6. **Ledger/Event**
- Immutable-style trace of money, policy, access, and operations.
- Core families: payments, compensation, audit, policy consequences, PHI access, etc.

7. **Subject**
- Generic identity anchor for extensibility and plugin-safe linking.
- Core table: `subjects`.

8. **Enterprise Scope**
- Reusable “where does this apply?” primitive for enterprise control.
- Core table: `enterprise_scopes`.
- Reused by inheritance/delegation/contract rollouts/approval limits.

Rule of thumb:
If a new feature cannot connect cleanly to these building blocks, it probably belongs in an extension projection, not core transactional schema.

---

## 3) Big Architecture Decisions (Why This Is Stable)

1. Resource wrappers are lean; operations are centralized
- `assets` and `venues` are identity/profile wrappers.
- Operational scheduling state is centralized in `resources`.

2. Commercial and execution are intentionally separate
- Order tables describe economic contract.
- Fulfillment tables describe operational execution.

3. Availability is universal, not host-only
- Calendars can be bound to biz/location/user/resource/service/service product/offer/custom subject.

4. Scope is normalized in enterprise domain
- `enterprise_scopes` removes duplicated scope columns/checks across tables.

5. Extensibility is first-class
- lifecycle event bus + delivery outbox + extension state docs + custom fields + subjects.

6. Money uses minor-unit integers
- avoids floating-point finance bugs.

---

## 4) How a Booking Works End-to-End

### Step A: Define what can be sold
- `services` and `service_products` define fulfillment intent.
- `offers` and `offer_versions` define commercial presentation.
- `sellables` gives a single commercial identity.

### Step B: Define who/what can fulfill
- `resources` rows represent real supply.
- selectors/capabilities constrain eligible resources.

### Step C: Define when it can happen
- bind calendars,
- apply recurring windows + exceptions + holds,
- optionally include dependency rules and shared capacity pools.

### Step D: Capture demand
- create `booking_orders` + `booking_order_lines`.
- map each line to sellables for reporting and attribution.

### Step E: Execute work
- generate `fulfillment_units`.
- assign resources.
- track checkpoints and status events.

### Step F: Settle money
- run intent/tender/transaction/dispute/settlement/payout flows.
- optional compensation and intercompany ledgers.

### Step G: Audit and project
- append audit/policy/access events.
- update reporting facts and projection checkpoints.

---

## 5) Calendar and Availability (ELI5)

A calendar is a reusable “time brain.”
It can belong to many entity types through `calendar_bindings`.

### What it controls
- base availability,
- exceptions,
- temporary blocks,
- lead-time and gating rules,
- capacity holds,
- dependency rules (for example: host needs front-desk coverage).

### How to query availability in one unified way
1. Pick target entity (resource/service/service product/offer/location/biz/custom subject).
2. Resolve all bound calendars.
3. Load active rules/overlays/holds in requested window.
4. Apply dependency rules and capacity rules.
5. Subtract already allocated fulfillment windows.
6. Return remaining slots + reasons.

This same query pattern works for hosts, assets, venues, services, and service products.

---

## 6) Enterprise Control Plane (What Changed Recently)

The latest schema now uses **normalized enterprise scopes**.

### Why this matters
Previously, several tables repeated:
- `scope_type`
- `scope_key`
- `target_*` columns.

Now:
- one `enterprise_scopes` row represents scope identity,
- dependent tables just store `scope_id`.

### Benefits
- less schema duplication,
- fewer inconsistent scope-shape bugs,
- easier extension and policy composition,
- cleaner migrations for future enterprise features.

### Enterprise domains
- topology: `enterprise_relationship_*`
- inheritance: `enterprise_inheritance_*`
- delegation + authority: `enterprise_admin_delegations`, `enterprise_approval_authority_limits`
- contract pack rollout: `enterprise_contract_pack_*`, `enterprise_change_rollout_*`
- intercompany ledger: `enterprise_intercompany_*`
- identity sync: `enterprise_identity_providers`, `enterprise_scim_sync_states`, `enterprise_external_directory_links`
- analytics facts: `fact_enterprise_*`

---

## 7) Plugins and Extensibility (How Third Parties Plug In)

Core extension primitives:
- definitions/install state,
- permission definitions + scoped grants,
- lifecycle event subscriptions + deliveries,
- extension state documents,
- idempotency keys,
- custom field definitions/values,
- subject graph links.

ELI5:
Core schema stays stable; plugins subscribe to events and maintain their own state without forcing core-table rewrites.

---

## 8) Money and Traceability

### Payment side
- intents,
- split tenders,
- transactions,
- disputes,
- settlements,
- payouts.

### Attribution side
- order line to sellable mapping,
- tender-to-line allocations,
- compensation ledgers,
- intercompany ledgers,
- policy consequence events.

Result:
You can answer “who paid what, for which line, using which tender, when, and what got fulfilled.”

---

## 9) Cookbook Playbooks

### Playbook A: Simplest booking with minimal UI
1. Create one `service` + one `service_product`.
2. Create one `offer` + one `offer_version` + one `sellable` mapping.
3. Create one `resource`.
4. Bind one calendar and one weekly rule.
5. Create `booking_order` with one line.
6. Create one `fulfillment_unit` + assignment.

### Playbook B: Complex multi-resource composite booking
1. Define service product requirements (required/optional selectors).
2. Add seat types and capacity constraints.
3. Add dependency rules and shared capacity pool.
4. Build offer version with multiple components.
5. On booking: generate fulfillment DAG and allocate resources.

### Playbook C: Field-service call fee scenario
1. Add call fee as explicit sellable/line item.
2. Trigger charge at arrival checkpoint.
3. Support split tender if needed.
4. Keep full line/tender/transaction trace.

### Playbook D: Enterprise rollout scenario
1. Define `enterprise_scopes` for network/biz/location.
2. Version contract pack.
3. Bind pack to target scopes.
4. Execute staged rollout and collect results.
5. Audit with result/event timelines.

---

## 10) Dos and Don’ts

### Do
- keep one source of operational truth in `resources`,
- keep commercial lines explicit,
- keep assignment and checkpoint trails append-oriented,
- use scope tables/selectors instead of feature-specific nullable columns.

### Don’t
- put business-critical state in UI-only metadata,
- duplicate scope models per domain,
- mutate away historical finance/compliance events,
- create feature-specific side tables before checking existing primitives.

---

## 11) What This Schema Is Great At

- multi-tenant, multi-location, multi-resource scheduling,
- blended services + products + bundles,
- enterprise governance and rollout,
- strong auditable financial and compliance flows,
- extension/plugin ecosystems.

## 12) What Still Depends on App/Engine Logic

- ranking/optimization algorithms,
- slot search heuristics and tie-breaking,
- route optimization math,
- policy execution engines,
- UX-level visibility and presentation controls.

The schema provides robust primitives and traceability; engines apply strategy.

---

## 13) Final ELI5 Summary

Think of Bizing as:
- one universal selling ledger,
- one universal time/availability engine,
- one universal execution engine,
- one universal evidence and money trail,
- plus a clean extension surface.

That is why it supports both existing and unimagined use cases without becoming rigid.
