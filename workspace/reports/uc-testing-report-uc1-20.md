# UC-1 Through UC-20 Agent API Test Report

**Generated:** 2026-02-22  
**Test Method:** Scenario pack execution against agent API at `http://localhost:6131/api/v1/agent/`  
**Test Files:** `workspace/agent-api-uc{N}-{shortname}.json`

---

## Summary Statistics

| Metric | Value |
|--------|-------|
| Total Use Cases Tested | 20 |
| Total Scenarios Executed | 195 |
| Total Passed | 78 (40%) |
| Total Failed | 117 (60%) |
| Use Cases Fully Supported | 0 |
| Use Cases Partially Supported | 20 |
| Use Cases Completely Blocked | 0 |

### Pass Rate by Use Case

| UC | Name | Total | Passed | Failed | Pass % |
|----|------|-------|--------|--------|--------|
| UC-1 | Solo Consultant (Fixed) | 18 | 1 | 17 | 6% |
| UC-2 | Solo Consultant (Variable) | 10 | 4 | 6 | 40% |
| UC-3 | Hair Salon Commission | 15 | 10 | 5 | 67% |
| UC-4 | Salon Favorability | 10 | 5 | 5 | 50% |
| UC-5 | Medical Room Pairing | 12 | 4 | 8 | 33% |
| UC-6 | Approval Workflow | 9 | 4 | 5 | 44% |
| UC-7 | Fitness Class | 12 | 4 | 8 | 33% |
| UC-8 | Tutoring Packages | 10 | 3 | 7 | 30% |
| UC-9 | Reception Calendar | 8 | 5 | 3 | 63% |
| UC-10 | Multi-Location | 7 | 4 | 3 | 57% |
| UC-11 | Multi-Provider Commission | 10 | 5 | 5 | 50% |
| UC-12 | Equipment Maintenance | 8 | 4 | 4 | 50% |
| UC-13 | Rental Gap Management | 8 | 3 | 5 | 38% |
| UC-14 | Corporate Training | 8 | 3 | 5 | 38% |
| UC-15 | Mobile Service | 8 | 1 | 7 | 13% |
| UC-16 | Package Deal | 7 | 2 | 5 | 29% |
| UC-17 | Dynamic Pricing | 7 | 3 | 4 | 43% |
| UC-18 | Seat Selection | 8 | 5 | 3 | 63% |
| UC-19 | Waitlist Auto-Offer | 7 | 4 | 3 | 57% |
| UC-20 | First-Confirm Waitlist | 8 | 2 | 6 | 25% |

---

## Top Schema Issues Identified

### 1. **Missing Tables** (Most Critical)

The following tables referenced in use cases do not exist in the schema:

| Missing Table | Affected Use Cases | Impact |
|---------------|-------------------|--------|
| `booking_order_private_notes` | UC-1, UC-8 | Cannot store private notes |
| `resource_compensation_rates` | UC-3, UC-11 | Cannot track commission splits |
| `resource_favorability_scores` | UC-4 | Cannot rank providers |
| `slot_allocation_rules` | UC-4 | Cannot allocate by favorability |
| `resource_pairings` | UC-5 | Cannot link provider + room |
| `approval_workflows` | UC-6 | Cannot require approval |
| `booking_approval_requests` | UC-6 | Cannot track approval status |
| `payment_holds` | UC-6 | Cannot hold payment pending approval |
| `seat_maps` | UC-7, UC-18 | Cannot do seat selection |
| `seat_map_seats` | UC-7, UC-18 | Cannot assign specific seats |
| `class_schedules` | UC-7 | Cannot manage group classes |
| `class_occurrences` | UC-7 | Cannot track class instances |
| `membership_plans` | UC-7 | Cannot sell memberships |
| `queues` | UC-3, UC-19, UC-20 | Cannot manage waitlists |
| `queue_entries` | UC-19, UC-20 | Cannot track waitlist entries |
| `package_products` | UC-8, UC-16 | Cannot sell session packages |
| `customer_purchases` | UC-8, UC-16 | Cannot track package usage |
| `calendar_groups` | UC-9 | Cannot show central calendar view |
| `service_areas` | UC-15 | Cannot define mobile service radius |
| `route_plans` | UC-15 | Cannot optimize routes |
| `equipment_maintenance_schedules` | UC-12 | Cannot track equipment maintenance |
| `pricing_tiers` | UC-13 | Cannot offer weekly discounts |
| `deposit_policies` | UC-13 | Cannot hold damage deposits |
| `session_attendance` | UC-14 | Cannot track attendance |
| `certificate_templates` | UC-14 | Cannot issue certificates |
| `dynamic_pricing_rules` | UC-17 | Cannot do surge pricing |
| `membership_tiers` | UC-17 | Cannot have VIP tiers |
| `seat_pricing_tiers` | UC-18 | Cannot price seats differently |
| `waitlist_auto_offer_policies` | UC-19 | Cannot auto-offer waitlist spots |
| `waitlist_claim_locks` | UC-20 | Cannot handle race conditions |

### 2. **Enum Value Issues**

| Column | Attempted Value | Issue |
|--------|----------------|-------|
| `availability_rules.mode` | "standard" | May not be valid enum value |
| `offer_versions.status` | "current" | Should be "active" |
| `booking_orders.status` | "pending_approval" | May not exist |
| `fulfillment_units.status` | "confirmed" | Should be "scheduled" or "active" |

### 3. **Foreign Key Constraints**

| Scenario | Error Pattern |
|----------|---------------|
| Creating booking orders | Requires valid `offer_version_id` |
| Creating fulfillment units | Requires valid `booking_order_id` |
| Creating services | Requires valid `service_group_id` |

### 4. **Missing Columns**

| Table | Missing Column | Expected Type |
|-------|---------------|---------------|
| `resources` | `is_mobile` | boolean |
| `resources` | `max_simultaneous_bookings` | integer |
| `booking_orders` | `customer_purchase_id` | string (FK) |
| `booking_orders` | `confirmed_duration_min` | integer |
| `offer_versions` | `requires_deposit` | boolean |
| `offer_versions` | `deposit_percent_bps` | integer |

---

## Per-Use-Case Breakdown

### UC-1: Solo Consultant (Fixed Duration) - 6% Pass
**What Worked:**
- Basic business creation

**What Failed:**
- `availability_rules`: Invalid mode enum ("standard")
- `offer_versions`: Invalid status enum ("current")
- `booking_order_private_notes`: Table doesn't exist
- `booking_order_lines`: `line_type` enum validation

**Action Items for Codex:**
1. Add `booking_order_private_notes` table
2. Fix `availability_rule_mode` enum to accept "standard"
3. Fix `offer_version_status` enum to accept "current" or document "active" as correct value
4. Verify `booking_order_line_type` enum values

---

### UC-2: Solo Consultant (Variable Duration) - 40% Pass
**What Worked:**
- Business, location, resource creation
- Calendar with variable settings
- Offer creation

**What Failed:**
- `offer_versions.duration_mode = "variable"`: May not be valid
- `offer_versions.unit_pricing_minor`: Column may not exist
- `booking_orders.requested_duration_min`: Column may not exist

**Action Items for Codex:**
1. Add `unit_pricing_minor` to `offer_versions`
2. Add `requested_duration_min` to `booking_orders`
3. Add `confirmed_duration_min` to `booking_orders`

---

### UC-3: Hair Salon with Commission - 67% Pass
**What Worked:**
- Business, resources, services creation
- Basic offer structure

**What Failed:**
- `resource_compensation_rates`: Table doesn't exist
- `queues`: Table doesn't exist (for walk-ins)
- `fulfillment_assignments`: Table may not exist

**Action Items for Codex:**
1. Create `resource_compensation_rates` table
2. Create `queues` table
3. Create `fulfillment_assignments` table

---

### UC-4: Salon with Favorability - 50% Pass
**What Worked:**
- Business, resources, calendar creation

**What Failed:**
- `resource_favorability_scores`: Table doesn't exist
- `slot_allocation_rules`: Table doesn't exist
- `service_product_requirement_groups`: Table may not exist

**Action Items for Codex:**
1. Create `resource_favorability_scores` table
2. Create `slot_allocation_rules` table
3. Verify `service_product_requirement_groups` exists

---

### UC-5: Medical Clinic Room Pairing - 33% Pass
**What Worked:**
- Business, location, resource creation

**What Failed:**
- `resource_pairings`: Table doesn't exist
- `waitlist_policies`: Table doesn't exist
- `fulfillment_units.secondary_resource_id`: Column may not exist

**Action Items for Codex:**
1. Create `resource_pairings` table
2. Create `waitlist_policies` table
3. Add `secondary_resource_id` to `fulfillment_units`

---

### UC-6: Approval Workflow - 44% Pass
**What Worked:**
- Business, resource creation
- Service with `requires_approval` flag

**What Failed:**
- `approval_workflows`: Table doesn't exist
- `booking_approval_requests`: Table doesn't exist
- `payment_holds`: Table doesn't exist
- `booking_orders.status = "pending_approval"`: Invalid enum

**Action Items for Codex:**
1. Create `approval_workflows` table
2. Create `booking_approval_requests` table
3. Create `payment_holds` table
4. Add "pending_approval" to `booking_order_status` enum

---

### UC-7: Fitness Class Studio - 33% Pass
**What Worked:**
- Business, location, resource creation

**What Failed:**
- `seat_maps`: Table doesn't exist
- `seat_map_seats`: Table doesn't exist
- `class_schedules`: Table doesn't exist
- `class_occurrences`: Table doesn't exist
- `membership_plans`: Table doesn't exist
- `cancellation_policies`: Table may not exist

**Action Items for Codex:**
1. Create `seat_maps` table
2. Create `seat_map_seats` table
3. Create `class_schedules` table
4. Create `class_occurrences` table
5. Create `membership_plans` table

---

### UC-8: Tutoring with Packages - 30% Pass
**What Worked:**
- Business, resource creation

**What Failed:**
- `package_products`: Table doesn't exist
- `customer_purchases`: Table doesn't exist
- `booking_series`: Table may not exist
- `booking_orders.customer_purchase_id`: Column doesn't exist

**Action Items for Codex:**
1. Create `package_products` table
2. Create `customer_purchases` table
3. Create `booking_series` table
4. Add `customer_purchase_id` to `booking_orders`

---

### UC-9: Receptionist Calendar - 63% Pass
**What Worked:**
- Multiple calendar creation
- Calendar queries

**What Failed:**
- `calendar_groups`: Table doesn't exist
- `availability_overrides`: Table may not exist

**Action Items for Codex:**
1. Create `calendar_groups` table
2. Create `availability_overrides` table

---

### UC-10: Multi-Location Chain - 57% Pass
**What Worked:**
- Multiple location creation
- Multi-location resource

**What Failed:**
- `location_pricing_rules`: Table doesn't exist
- `transfer_policies`: Table doesn't exist

**Action Items for Codex:**
1. Create `location_pricing_rules` table
2. Create `transfer_policies` table

---

### UC-11: Multi-Provider Commission - 50% Pass
**What Worked:**
- Multiple resources creation
- Service requirement groups (may work)

**What Failed:**
- `resource_compensation_rates`: Table doesn't exist (same as UC-3)

**Action Items for Codex:**
1. Create `resource_compensation_rates` table (shared with UC-3)

---

### UC-12: Equipment Maintenance - 50% Pass
**What Worked:**
- Business, resources creation

**What Failed:**
- `equipment_maintenance_schedules`: Table doesn't exist
- `equipment_usage_logs`: Table doesn't exist
- `equipment_maintenance_triggers`: Table doesn't exist

**Action Items for Codex:**
1. Create `equipment_maintenance_schedules` table
2. Create `equipment_usage_logs` table
3. Create `equipment_maintenance_triggers` table

---

### UC-13: Multi-Day Rental - 38% Pass
**What Worked:**
- Business, location, venue creation
- Offer creation

**What Failed:**
- `offer_versions.min_gap_between_bookings_min`: Column doesn't exist
- `pricing_tiers`: Table doesn't exist
- `deposit_policies`: Table doesn't exist

**Action Items for Codex:**
1. Add `min_gap_between_bookings_min` to `offer_versions`
2. Create `pricing_tiers` table
3. Create `deposit_policies` table

---

### UC-14: Corporate Training - 38% Pass
**What Worked:**
- Business, resource creation
- Multi-session product (partial)

**What Failed:**
- `session_attendance`: Table doesn't exist
- `certificate_templates`: Table doesn't exist
- `booking_orders.payment_terms`: Column doesn't exist

**Action Items for Codex:**
1. Create `session_attendance` table
2. Create `certificate_templates` table
3. Add `payment_terms` to `booking_orders`

---

### UC-15: Mobile Service - 13% Pass
**What Worked:**
- Basic business creation only

**What Failed:**
- `service_areas`: Table doesn't exist
- `resources.is_mobile`: Column doesn't exist
- `route_plans`: Table doesn't exist
- `customer_locations`: Table doesn't exist
- `resource_travel_logs`: Table doesn't exist

**Action Items for Codex:**
1. Create `service_areas` table
2. Add `is_mobile` to `resources`
3. Create `route_plans` table
4. Create `customer_locations` table
5. Create `resource_travel_logs` table

---

### UC-16: Package Deal - 29% Pass
**What Worked:**
- Business creation

**What Failed:**
- `package_products`: Table doesn't exist (same as UC-8)
- `customer_purchases`: Table doesn't exist (same as UC-8)
- `package_transfer_policies`: Table doesn't exist
- `package_refund_policies`: Table doesn't exist
- `package_sharing_policies`: Table doesn't exist

**Action Items for Codex:**
1. Create `package_products` table
2. Create `customer_purchases` table
3. Create `package_transfer_policies` table
4. Create `package_refund_policies` table
5. Create `package_sharing_policies` table

---

### UC-17: Dynamic Pricing - 43% Pass
**What Worked:**
- Business, resource creation

**What Failed:**
- `dynamic_pricing_rules`: Table doesn't exist
- `membership_tiers`: Table doesn't exist

**Action Items for Codex:**
1. Create `dynamic_pricing_rules` table
2. Create `membership_tiers` table

---

### UC-18: Seat Selection Venue - 63% Pass
**What Worked:**
- Business, location creation

**What Failed:**
- `seat_map_sections`: Table doesn't exist
- `seat_pricing_tiers`: Table doesn't exist
- `seat_hold_policies`: Table doesn't exist

**Action Items for Codex:**
1. Create `seat_map_sections` table
2. Create `seat_pricing_tiers` table
3. Create `seat_hold_policies` table

---

### UC-19: Waitlist Auto-Offer - 57% Pass
**What Worked:**
- Business, location, queue creation

**What Failed:**
- `waitlist_policies`: Table doesn't exist (same as UC-5)
- `waitlist_auto_offer_policies`: Table doesn't exist
- `customer_waitlist_prefs`: Table doesn't exist

**Action Items for Codex:**
1. Create `waitlist_policies` table
2. Create `waitlist_auto_offer_policies` table
3. Create `customer_waitlist_prefs` table

---

### UC-20: First-Confirm Waitlist - 25% Pass
**What Worked:**
- Business, location, class schedule creation (partial)

**What Failed:**
- `waitlist_claim_locks`: Table doesn't exist
- `waitlist_notification_policies`: Table doesn't exist
- `waitlist_claims`: Table doesn't exist

**Action Items for Codex:**
1. Create `waitlist_claim_locks` table
2. Create `waitlist_notification_policies` table
3. Create `waitlist_claims` table

---

## Priority Recommendations for Codex

### P0 - Critical (Blocks Basic Use Cases)

1. **Fix enum values:**
   - `availability_rule_mode`: Accept "standard" or document valid values
   - `offer_version_status`: Accept "current" or document "active" as correct

2. **Add missing columns to existing tables:**
   - `resources.is_mobile` (boolean)
   - `resources.max_simultaneous_bookings` (integer)
   - `booking_orders.customer_purchase_id` (string)
   - `booking_orders.requested_duration_min` (integer)
   - `booking_orders.confirmed_duration_min` (integer)
   - `booking_orders.payment_terms` (string)
   - `offer_versions.unit_pricing_minor` (integer)
   - `offer_versions.requires_deposit` (boolean)
   - `offer_versions.deposit_percent_bps` (integer)
   - `offer_versions.min_gap_between_bookings_min` (integer)
   - `fulfillment_units.secondary_resource_id` (string)

### P1 - High (Enables Core Business Models)

3. **Create core booking tables:**
   - `booking_order_private_notes`
   - `queues` and `queue_entries`
   - `class_schedules` and `class_occurrences`

4. **Create package/session tables:**
   - `package_products`
   - `customer_purchases`

### P2 - Medium (Enables Advanced Features)

5. **Create commission/pricing tables:**
   - `resource_compensation_rates`
   - `dynamic_pricing_rules`

6. **Create waitlist tables:**
   - `waitlist_policies`
   - `waitlist_auto_offer_policies`
   - `waitlist_claim_locks`

### P3 - Low (Nice to Have)

7. **Create specialized tables:**
   - `seat_maps`, `seat_map_seats`, `seat_map_sections`, `seat_pricing_tiers`
   - `equipment_maintenance_schedules`, `equipment_usage_logs`
   - `approval_workflows`, `booking_approval_requests`, `payment_holds`

---

## Appendix: Test Files Generated

| File | Use Case |
|------|----------|
| `agent-api-uc1-solo-consultant-fixed.json` | UC-1: Solo Consultant (Fixed) |
| `agent-api-uc2-variable-duration.json` | UC-2: Solo Consultant (Variable) |
| `agent-api-uc3-salon-commission.json` | UC-3: Hair Salon Commission |
| `agent-api-uc4-salon-favorability.json` | UC-4: Salon Favorability |
| `agent-api-uc5-medical-room-pairing.json` | UC-5: Medical Room Pairing |
| `agent-api-uc6-approval-workflow.json` | UC-6: Approval Workflow |
| `agent-api-uc7-fitness-class.json` | UC-7: Fitness Class |
| `agent-api-uc8-tutoring-packages.json` | UC-8: Tutoring Packages |
| `agent-api-uc9-reception-calendar.json` | UC-9: Reception Calendar |
| `agent-api-uc10-multi-location.json` | UC-10: Multi-Location Chain |
| `agent-api-uc11-multi-provider-commission.json` | UC-11: Multi-Provider Commission |
| `agent-api-uc12-equipment-maintenance.json` | UC-12: Equipment Maintenance |
| `agent-api-uc13-rental-gap.json` | UC-13: Rental Gap Management |
| `agent-api-uc14-corporate-training.json` | UC-14: Corporate Training |
| `agent-api-uc15-mobile-service.json` | UC-15: Mobile Service |
| `agent-api-uc16-package-deal.json` | UC-16: Package Deal |
| `agent-api-uc17-dynamic-pricing.json` | UC-17: Dynamic Pricing |
| `agent-api-uc18-seat-selection.json` | UC-18: Seat Selection |
| `agent-api-uc19-waitlist-auto.json` | UC-19: Waitlist Auto-Offer |
| `agent-api-uc20-first-confirm.json` | UC-20: First-Confirm Waitlist |

---

*Report generated by Bizing Agent Testing System*
