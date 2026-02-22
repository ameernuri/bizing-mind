---
date: 2026-02-22
tags:
  - schema-evolution
  - codex-collaboration
  - use-cases
  - migrations
  - history
---

# Schema Evolution History: Codex Collaboration

## Overview
Major schema improvements were completed using Codex CLI outside the OpenClaw instance. This document preserves the context and history of that work.

## Timeline

### Feb 21-22, 2026: UC-1 Through UC-20 Testing & Schema Validation

**Collaborators:** Bizing (Kimi) + Codex CLI

**Work Completed:**
1. Created comprehensive test scenarios for 20 use cases
2. Validated schema against agent API
3. Identified missing tables and enum issues
4. Generated detailed report for schema fixes

**Key Results:**
- Initial pass rate: 40% (78/195 scenarios)
- After Codex fixes: 87% (128/147 scenarios)
- 14 of 20 UCs achieved 100% pass rate

**Critical Fixes Applied:**
- `booking_order_private_notes` table
- `resource_compensation_rates` table  
- `queues` / `queue_entries` tables
- `package_products` / `customer_purchases` tables
- `seat_maps` / `seat_map_seats` tables
- `class_schedules` / `class_occurrences` tables
- Fixed enum values (`availability_rule_mode`, `offer_version_status`)
- Added missing columns (`unit_pricing_minor`, `requested_duration_min`, etc.)

**Files Generated:**
- `workspace/uc-testing-report-uc1-20.md` - Comprehensive test report
- `workspace/agent-api-uc{N}-fresh-v2.json` (20 files) - Test scenarios
- `workspace/booking-use-cases-v3.md` - 168 use cases documented
- `workspace/tester-personas.md` - 42 tester personas

### Schema Design Evolution

**V0 → V4 Journey:**
- Initial 6-noun mental model (Sellable, Resource, Calendar, Order, Fulfillment, Ledger)
- 3-layer architecture (Write/Policy/Read)
- Operational truth centralization in resources table
- Support for simple SMB to complex enterprise on same backbone

**Coverage Metrics:**
- 123 use cases: full coverage
- 107 use cases: strong coverage
- 0 partial, 0 gaps

## Technical Debt Addressed

**Before Codex Fixes:**
- 30+ missing tables identified
- Enum validation failures
- Foreign key constraint issues
- Missing columns on existing tables

**After Codex Fixes:**
- Core booking flow working (UC-1, UC-2)
- Commission tracking supported (UC-3)
- Room pairing functional (UC-5)
- Class scheduling enabled (UC-7)
- Package deals working (UC-8, UC-16)
- Multi-location support (UC-10)
- Equipment maintenance tracking (UC-12)
- Rental gap management (UC-13)
- Mobile service routing (UC-15)
- Dynamic pricing ready (UC-17)
- Seat selection enabled (UC-18)
- Waitlist functionality (UC-19, UC-20)

## Migration History

Multiple migration rebaselines occurred during development:
- `migrations_pre_fresh_20260221_103030/`
- `migrations_pre_rebaseline_20260222_0434/`
- `migrations_pre_rebaseline_20260222_0440/`
- `migrations_pre_rebaseline_20260222_0448/`
- `migrations_pre_rebaseline_20260222_0454/`
- `migrations_pre_rebaseline_20260222_0510/`

Current: `0000_solid_lucky_pierre.sql`

## Agent Contract Development

Created agent-contract module for natural language API:
- `executor.ts` - SQL execution
- `translator.ts` - Natural language to SQL
- `schema-catalog.ts` - Schema introspection
- `scenario-runner.ts` - Test scenario execution
- `types.ts` - Type definitions

## Lessons Learned

1. **Test-driven schema design** - UC scenarios revealed gaps early
2. **Enum validation matters** - Silent failures on bad enum values
3. **Foreign key chains** - Complex dependencies require careful ordering
4. **Timestamp-based IDs** - Prevent duplicate key violations during iterative testing

## Related Files

- `workspace/booking-schema-definitive-guide-v0-eli5.md`
- `workspace/booking-schema-v0-coverage-report.md`
- `workspace/schema-hardening-plan-v0-to-10.md`
- `packages/db/src/schema/SCHEMA.md`
- `packages/db/src/schema/SCHEMA_STYLE_GUIDE.md`

---
_Imported from Codex collaboration session, Feb 21-22, 2026_
