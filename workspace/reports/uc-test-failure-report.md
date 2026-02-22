# UC Test Failure Report - Feb 22, 2026

## Executive Summary

**Root Cause:** Slug uniqueness constraint violations, not KSUID collisions.

The database already contains test records from earlier runs with slugs like:
- `sarah-career-coaching`
- `sarah-office` 
- `mark-consulting`
- etc.

## UC-1 Failure Analysis

| Step | Error | Cause |
|------|-------|-------|
| uc1-01 | `duplicate key value violates unique constraint "bizes_slug_unique"` | Slug `sarah-career-coaching` already exists |
| uc1-02 | FK constraint `locations_biz_id_bizes_id_fk` | Business wasn't created (step 1 failed) |
| uc1-03 | FK constraint `resources_biz_id_bizes_id_fk` | Business wasn't created |
| uc1-04 | FK constraint `calendars_biz_id_bizes_id_fk` | Business wasn't created |
| uc1-05 | ✅ Success | Query returned 0 rows (business doesn't exist) |

## Pattern Across UC-1 to UC-10

All failures follow the same pattern:
1. **First insert fails** due to slug collision
2. **All subsequent inserts fail** due to FK constraints (parent record missing)
3. **Queries succeed** but return empty results

## UC-11 to UC-20 Success Explanation

These used simple test slugs like `test-uc11` which hadn't been used before, so they passed.

## Affected Slugs (Need to be Unique)

From v3 test files:
- `sarah-career-coaching`, `sarah-office`, `sarah-chen`
- `mark-consulting`, `mark-office`, `mark-johnson`
- `maria-salon`, `downtown-salon`, `stylist-a`, `stylist-b`
- `premium-salon`, `main-loc`, `stylist-a` (duplicate!)
- `medical-clinic`, `main-clinic`, `exam-room-1`, `dr-jones`
- `cardio-specialists`, `cardio-center`, `dr-heart`
- `spin-city`, `main-studio`, `spin-instructor`
- `math-excellence`, `main-campus`, `ms-rodriguez`
- `multi-provider-med`, `medical-center`
- `clean-teeth`, `downtown`, `suburban`, `dr-williams`

## Fix Options

### Option 1: Timestamped Slugs (Recommended)
Append timestamp to make slugs unique:
```
sarah-career-coaching-202502220807
sarah-office-202502220807
```

### Option 2: KSUID-Based Slugs
Use portion of KSUID in slug:
```
sarah-career-coaching-3a21sk
```

### Option 3: Clear Test Data First
Run cleanup before tests:
```sql
DELETE FROM bizes WHERE slug LIKE 'sarah-career-coaching%';
DELETE FROM locations WHERE slug LIKE 'sarah-office%';
-- etc
```

### Option 4: Use ON CONFLICT
Modify schema or API to use `ON CONFLICT DO NOTHING` for test runs.

## Recommendation

**Option 1 (Timestamped Slugs)** is cleanest:
- Maintains readability
- Guaranteed unique per run
- No schema changes needed
- Test data can be cleaned up later by timestamp pattern

## Files to Regenerate

All 20 v3 files need updated slugs:
- `workspace/agent-api-uc1-fresh-v3.json` through `uc20-fresh-v3.json`

---
Report generated: 2026-02-22 08:07 PST
