# Comprehensive UC Testing Report - Extended Persona Suite
**Date:** February 22, 2026  
**Total Use Cases Tested:** 35 (UC-1 through UC-35)  
**Total Scenarios:** 225  

---

## Executive Summary

| Phase            | UCs               | Scenarios | Pass Rate | Status          |
| ---------------- | ----------------- | --------- | --------- | --------------- |
| **Original 20**  | UC-1 to UC-20     | 90        | **100%**  | ✅ **Perfect**   |
| **New Personas** | UC-21 to UC-35    | 135       | **100%**  | ✅ **Perfect**   |
| **Overall**      | **UC-1 to UC-35** | **225**   | **100%**  | ✅ **Perfect** |

**Key Achievement:** All 35 use cases now achieve **100% pass rate** with regenerated scenario inputs and strict translator validation.

---

## Original 20 Use Cases (UC-1 to UC-20)

### Results Summary

| UC    | Persona              | Scenarios | Passed | Rate   |
| ----- | -------------------- | --------- | ------ | ------ |
| UC-1  | Sarah (Career Coach) | 5/5       | 5      | 100% ✅ |
| UC-2  | Mark (Consultant)    | 5/5       | 5      | 100% ✅ |
| UC-3  | Maria (Hair Salon)   | 5/5       | 5      | 100% ✅ |
| UC-4  | Premium Salon        | 5/5       | 5      | 100% ✅ |
| UC-5  | Medical Clinic       | 5/5       | 5      | 100% ✅ |
| UC-6  | Cardiology           | 5/5       | 5      | 100% ✅ |
| UC-7  | Spin Studio          | 5/5       | 5      | 100% ✅ |
| UC-8  | Math Tutor           | 5/5       | 5      | 100% ✅ |
| UC-9  | Multi-Provider       | 5/5       | 5      | 100% ✅ |
| UC-10 | Dental Chain         | 5/5       | 5      | 100% ✅ |
| UC-11 | Commission Model     | 4/4       | 4      | 100% ✅ |
| UC-12 | Equipment Maint      | 4/4       | 4      | 100% ✅ |
| UC-13 | Rental Gap           | 4/4       | 4      | 100% ✅ |
| UC-14 | Corporate Training   | 4/4       | 4      | 100% ✅ |
| UC-15 | Mobile Service       | 4/4       | 4      | 100% ✅ |
| UC-16 | Package Deal         | 4/4       | 4      | 100% ✅ |
| UC-17 | Dynamic Pricing      | 4/4       | 4      | 100% ✅ |
| UC-18 | Seat Selection       | 4/4       | 4      | 100% ✅ |
| UC-19 | Waitlist Auto        | 4/4       | 4      | 100% ✅ |
| UC-20 | First-Confirm        | 4/4       | 4      | 100% ✅ |

**Total:** 90/90 scenarios passed (**100%**) 🎯

---

## New Persona Use Cases (UC-21 to UC-35)

### Personas Tested

| UC    | Persona         | Business Type   | Scenarios | Passed | Rate |
| ----- | --------------- | --------------- | --------- | ------ | ---- |
| UC-21 | Dr. Emma        | Therapist       | 9/9       | 9      | 100%  |
| UC-22 | Chef Marco      | Private Chef    | 9/9       | 9      | 100%  |
| UC-23 | Yoga Studio     | Wellness Center | 9/9       | 9      | 100%  |
| UC-24 | Auto Shop       | Mechanic        | 9/9       | 9      | 100%  |
| UC-25 | Photographer    | Creative        | 9/9       | 9      | 100%  |
| UC-26 | Consulting Firm | B2B             | 9/9       | 9      | 100%  |
| UC-27 | Vet Clinic      | Pet Care        | 9/9       | 9      | 100%  |
| UC-28 | Music School    | Education       | 9/9       | 9      | 100%  |
| UC-29 | Coworking       | Space Rental    | 9/9       | 9      | 100%  |
| UC-30 | Cleaning Co     | Home Services   | 9/9       | 9      | 100%  |
| UC-31 | Language Tutor  | Education       | 9/9       | 9      | 100%  |
| UC-32 | Massage Spa     | Wellness        | 9/9       | 9      | 100%  |
| UC-33 | Tax Accountant  | Financial       | 9/9       | 9      | 100%  |
| UC-34 | Dance Studio    | Arts            | 9/9       | 9      | 100%  |
| UC-35 | IT Support      | Tech Services   | 9/9       | 9      | 100%  |

**Total:** 135/135 scenarios passed (**100%**)

---

## Error Analysis

### Pattern 1: Reused Scenario Data

**Issue:** Duplicate key violations when replaying static JSON files.

**Classification:** Test harness misuse, not a schema defect.

**Why:** Persona JSON files were generated once and reused. Re-running against a non-empty DB collides on IDs/slugs.

**Fix Applied:**
- Persona generator now emits fresh IDs every run using built-in crypto UUIDs.
- Persona slugs/emails remain timestamp-suffixed to stay unique across runs.

---

### Pattern 2: Prompt/Schema Drift in Offer Inserts

**Issue:** `offers.execution_mode` not-null violations and hidden invalid fields.

**Classification:** Agent prompt misuse + translator safety gap, not a schema defect.

**Why this happened:**
- Persona prompts inserted `offers.type = service` (column does not exist).
- Translator previously ignored unknown assignment columns, so `type` was silently dropped.
- Prompts also omitted required `execution_mode`, so DB insert failed.

**Canonical behavior:**
- Keep `offers.execution_mode` **NOT NULL**.
- Do **not** use `'manual'` as a default (invalid enum value for `offer_execution_mode`).

**Fix Applied:**
- Persona scenarios now set `execution_mode = slot`.
- Persona scenarios no longer send `offers.type`.
- Translator now rejects unknown assignment columns for insert/update instead of silently ignoring them.
- Translator update parser now ignores `WHERE` segment when parsing `SET` assignments (prevents accidental updates to filter columns).

---

## Test Coverage Analysis

### Business Types Covered

| Category | Examples | Count |
|----------|----------|-------|
| **Health/Wellness** | Therapist, Yoga, Massage, Vet | 4 |
| **Professional Services** | Consulting, Accounting, IT | 3 |
| **Creative/Arts** | Photography, Music, Dance | 3 |
| **Home Services** | Cleaning, Chef, Mechanic | 3 |
| **Education** | Tutoring, Language, Training | 3 |
| **Space/Equipment** | Coworking, Auto Shop | 2 |
| **Medical** | Cardiology, Dental, General | 3 |
| **Other** | Career Coach, Hair Salon | 2 |

**Total Unique Business Types:** 23

---

## Schema Validation Results

### ✅ Working Tables (Consistently Pass)

- `bizes` - Business creation
- `locations` - Location management
- `resources` - Resource/host configuration
- `calendars` - Calendar setup
- `availability_rules` - Scheduling rules

### ✅ Tables Requiring Fixes

None from this report. Failures were generated by prompt shape and runner behavior, not canonical schema definitions.

### ✅ Query Operations (All Pass)

- `list` queries
- `count` queries
- Filtered lookups

---

## Recommendations

### 1. Contract/Scenario Correctness (Implemented)

- Keep `offers.execution_mode` required.
- Use only canonical offer columns in scenarios.
- Fail fast on unknown assignment columns in the translator.

### 2. Test Infrastructure

**Run with Fresh Scenario Material:**
- Use `run-uc-tests.sh` for all future testing
- Use `run-persona-tests.sh` for UC-21 to UC-35
- Regenerate persona scenarios before each persona run
- Avoid replaying stale static JSON against persistent databases

### 3. Test Coverage Expansion

**Priority Next UCs:**
- UC-36+: Multi-location chains with shared inventory
- UC-40+: Enterprise with approval workflows
- UC-45+: Complex commission splits (3+ providers)
- UC-50+: Subscription/membership models

---

## Files Generated

| File | Description |
|------|-------------|
| `run-uc-tests.sh` | Dynamic test runner with fresh ID generation |
| `run-persona-tests.sh` | Persona runner that regenerates UC-21..UC-35 files each run |
| `agent-api-uc{N}-fresh-v4.json` | Fresh scenario files (UC-1 to UC-20) |
| `agent-api-uc{N}-persona.json` | New persona tests (UC-21 to UC-35) |
| `uc-test-failure-report.md` | Initial failure analysis |
| `extended-persona-report.md` | This report |

---

## Conclusion

**Schema Status:** Production-ready for tested use cases

- **UC-1 to UC-20:** 100% pass rate with dynamic runner
- **UC-21 to UC-35:** 100% pass rate with regenerated persona scenarios
- **Overall:** 100% pass rate across 35 use cases and 225 scenarios

**Next Steps:**
1. Keep regenerating persona scenarios before each run.
2. Keep translator strict mode for unknown columns.
3. If any failures appear, classify them as true DB constraints vs scenario misuse before changing schema.

---

*Report updated: 2026-02-22 08:31 PST*  
*Bizing Schema v0 Validation*
