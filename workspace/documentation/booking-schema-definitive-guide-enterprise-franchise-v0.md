---
date: 2026-02-21
tags:
  - schema
  - guide
  - definitive
  - enterprise
  - franchise
  - v0
---

# Definitive Guide: Enterprise + Franchise Setup (v0)

Source links:
- Base guide: [[booking-schema-definitive-guide-v0-eli5]]
- Use cases: [[booking-use-cases-v3]]
- Coverage: [[booking-schema-v0-coverage-report]]

---

## 0) Latest Schema Notes (2026-02-21)

- Coverage rerun remains complete (`257/257` UC lines mapped), with totals `#full = 144`, `#strong = 113`.
- Cross-domain contact identity in enterprise flows is now cleaner via `crm_contacts` + `crm_contact_channels`, reducing duplicate user/group contact modeling.
- Quote decision actors are normalized to contact/subject anchors, which makes enterprise approval and delegated signing trails easier to extend without schema branching.

---

## 1) Who This Is For

Use this setup for:
- one parent network with many member bizes/locations,
- central standards with local overrides,
- delegated authority with strict auditability,
- intercompany financial traceability.

ELI5:
One big company brain, many local hands.

---

## 2) Core Backbone

1. Network topology
- `enterprise_relationship_templates`
- `enterprise_relationships`

2. Unified scope primitive (most important)
- `enterprise_scopes`
- one reusable scope row for `network | biz | location | subject`
- reused by inheritance, delegation, contract binding, rollout targets.

3. Override/inheritance control plane
- `enterprise_inheritance_strategies`
- `enterprise_inheritance_resolutions`

4. Delegated admin + approval caps
- `enterprise_admin_delegations`
- `enterprise_approval_authority_limits`

5. Policy/contract rollout across network
- `enterprise_contract_pack_templates`
- `enterprise_contract_pack_versions`
- `enterprise_contract_pack_bindings`
- `enterprise_change_rollout_runs`
- `enterprise_change_rollout_targets`
- `enterprise_change_rollout_results`

6. Intercompany ledger and settlement
- `enterprise_intercompany_accounts`
- `enterprise_intercompany_entries`
- `enterprise_intercompany_settlement_runs`

7. Enterprise identity integration
- `enterprise_identity_providers`
- `enterprise_scim_sync_states`
- `enterprise_external_directory_links`

8. Fast network analytics
- `fact_enterprise_revenue_daily`
- `fact_enterprise_utilization_daily`
- `fact_enterprise_compliance_daily`

---

## 3) Setup Playbook

1. Define relationship language first
- create template keys like `parent_of`, `franchise_of`, `region_of`.
- then create actual graph edges in `enterprise_relationships`.

2. Create canonical scopes once
- insert rows into `enterprise_scopes` for every level you manage.
- reuse `scope_id` everywhere instead of duplicating scope columns.

3. Define inheritance policies
- pricing, policy, config inheritance in `enterprise_inheritance_strategies`.
- materialize resolved values in `enterprise_inheritance_resolutions`.

4. Roll out standards safely
- version packs in `enterprise_contract_pack_versions`.
- bind by scope in `enterprise_contract_pack_bindings`.
- execute phased rollout with `enterprise_change_rollout_*`.

5. Wire authority safely
- grant delegated rights with `enterprise_admin_delegations`.
- set money/approval caps in `enterprise_approval_authority_limits`.

6. Add financial governance
- open lanes in `enterprise_intercompany_accounts`.
- write entries in `enterprise_intercompany_entries`.
- close windows with settlement runs.

---

## 4) High-Value Patterns

Use enterprise control plane with core commerce/scheduling domains:
- Selling: `sellables`, `offers`, `service_products`, `booking_orders`.
- Execution: `fulfillment_units`, `fulfillment_assignments`.
- Time: `calendars`, `calendar_bindings`, `availability_rules`.
- Cross-biz trading: `cross_biz_contracts`, `cross_biz_orders`.

Rule of thumb:
- enterprise tables decide policy and authority,
- core commerce tables execute demand and money.

---

## 5) Common Mistakes

- Duplicating scope columns in custom tables instead of referencing `enterprise_scopes`.
- Encoding hierarchy in app-only config instead of `enterprise_relationships`.
- Running big rollouts without `enterprise_change_rollout_results` evidence.
- Blending intercompany accounting with customer payment rows.

---

## 6) Health Checklist

- Every enterprise-targeted rule references `scope_id`.
- Every delegated authority row has clear effective window.
- Every policy rollout has per-target result history.
- Every intercompany transfer is in ledger + settlement runs.
- Network dashboards can read from `fact_enterprise_*` without ad-hoc SQL.
