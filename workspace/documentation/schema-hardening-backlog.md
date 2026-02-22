# Schema Hardening Backlog (v0)

This backlog turns architecture goals into concrete implementation tasks.

## P0 (now)

- [x] Add automated schema guard checks.
  - Added: `packages/db/scripts/schema-guard.ts`
  - Checks:
    - leftover `@codex`/`TODO`/`FIXME` markers (error)
    - same-table `status` + `is_active` duplication (error)
    - missing `biz_id` in tenant-domain tables (warn)
    - missing table JSDoc near `pgTable` blocks (warn)
- [x] Add schema conventions doc.
  - Added: `packages/db/src/schema/SCHEMA_STYLE_GUIDE.md`
- [x] Fix db operational script drift.
  - Added missing `packages/db/scripts/migrate.ts`
  - Converted db scripts to bun in `packages/db/package.json`
  - Added root `db:guard` script in `package.json`
- [x] Align seed with current schema.
  - Removed stale `services.isActive` usage in `packages/db/scripts/seed.ts`

## P1 (next)

- [ ] Enforce tenant-safe composite FK policy across all tenant-scoped relationships.
  - Goal: no child row can reference parent row from a different biz.
  - Approach: require `(biz_id, id)` unique on parent + composite FK on child.
- [x] Normalize unconstrained lifecycle classifiers and harden guard detection.
  - Fixed `schema-guard` regex so `status: varchar("status", { ... })` is detected.
  - Added constrained-pattern handling (`CHECK` / `status_config_value_id`) to avoid false positives.
  - Normalized strictly finite biz-config promotion classifiers to enums:
    - `biz_config_promotion_operation`
    - `biz_config_promotion_run_status`
    - `biz_config_promotion_entity_type`
    - `biz_config_promotion_action`
    - `biz_config_promotion_item_status`
- [ ] Add invariant tests for key polymorphic selectors and owner-shape constraints.
  - Focus: offers, service products, resource selectors, calendar ownership.
- [ ] Add consistency checks for default rows in dictionary tables.
  - Example: max one default per scope for status dictionaries and similar templates.

## P2 (after API stabilizes)

- [ ] Introduce partitioning strategy for append-heavy audit/event timelines.
  - Candidate domains: audit events, sync events, pricing evaluations, resolution runs.
- [ ] Create canonical “data flow maps” for each core use case.
  - Booking
  - Rental
  - Queue
  - Transportation
  - Education/program
- [ ] Add generated schema diagnostics report in CI artifacts.
  - Duplicated index names
  - Missing comments
  - Missing tenant boundary markers
  - Large table hotspot summary

## Notes

- v0 policy: no backwards compatibility constraints.
- Prefer structural fixes over wrappers/shims.
- Keep cross-domain abstractions generic; avoid vertical-specific hardcoding in core tables.
- Next-level architecture plan: [[schema-unified-commerce-evolution-plan-v0]]
