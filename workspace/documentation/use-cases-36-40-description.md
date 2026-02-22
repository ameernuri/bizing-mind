# New Use Cases 36-40 - Scenario Descriptions

Generated: February 22, 2026  
Total: 5 new use cases, 30 scenarios  
Pass Rate: 100% (30/30)

---

## UC-36: Event Venue Rental (Grand Hall Events)

**File:** `testing/scenarios/uc-36-grand-hall.json`

**Business Type:** Space rental - Multi-room venue

**What it tests:**
- Business setup for venue rental company
- Location creation for event space
- Resource configuration for venue rooms
- Calendar setup for availability
- Service offer for venue booking

**Persona:** Venue manager renting out event spaces for weddings, corporate events, parties

**Key Flow:**
1. Create business "Grand Hall Events"
2. Set up main location
3. Create resource for venue space
4. Configure calendar for bookings
5. Publish venue rental offer
6. Verify complete setup

---

## UC-37: Personal Training (FitPro Training)

**File:** `testing/scenarios/uc-37-fitpro.json`

**Business Type:** Fitness - Personal training sessions

**What it tests:**
- Personal trainer business setup
- Training facility location
- Trainer as resource (capacity=1)
- Calendar for session booking
- Service offer for training packages

**Persona:** Personal trainer offering one-on-one fitness sessions with package deals

**Key Flow:**
1. Create business "FitPro Training"
2. Set up training facility location
3. Create trainer resource
4. Configure session calendar
5. Publish training service offer
6. Verify setup complete

---

## UC-38: Car Detailing (Sparkle Auto Detail)

**File:** `testing/scenarios/uc-38-sparkle-auto.json`

**Business Type:** Auto service - Car detailing

**What it tests:**
- Auto service business setup
- Service bay location
- Detailing bay as resource
- Calendar for service appointments
- Tiered service packages offer

**Persona:** Auto detailer with multiple service bays offering basic, premium, and deluxe packages

**Key Flow:**
1. Create business "Sparkle Auto Detail"
2. Set up service bay location
3. Create detailing bay resource
4. Configure appointment calendar
5. Publish detailing service offer
6. Verify setup complete

---

## UC-39: Language Immersion (Global Speak Academy)

**File:** `testing/scenarios/uc-39-global-speak.json`

**Business Type:** Education - Language classes

**What it tests:**
- Language school business setup
- Classroom location
- Instructor resource
- Class schedule calendar
- Group class offer

**Persona:** Language academy offering intensive immersion courses with beginner, intermediate, and advanced levels

**Key Flow:**
1. Create business "Global Speak Academy"
2. Set up classroom location
3. Create instructor resource
4. Configure class calendar
5. Publish language course offer
6. Verify setup complete

---

## UC-40: Legal Consultation (Justice Law Partners)

**File:** `testing/scenarios/uc-40-justice-law.json`

**Business Type:** Professional - Legal services

**What it tests:**
- Law firm business setup
- Office location
- Attorney as resource
- Consultation calendar
- Retainer-based service offer

**Persona:** Law firm offering initial consultations and ongoing retainer-based legal services

**Key Flow:**
1. Create business "Justice Law Partners"
2. Set up law office location
3. Create attorney resource
4. Configure consultation calendar
5. Publish legal service offer
6. Verify setup complete

---

## Test Results

| UC | Business | Scenarios | Passed | Rate |
|----|----------|-----------|--------|------|
| UC-36 | Event Venue | 6/6 | 6 | 100% |
| UC-37 | Personal Training | 6/6 | 6 | 100% |
| UC-38 | Car Detailing | 6/6 | 6 | 100% |
| UC-39 | Language Immersion | 6/6 | 6 | 100% |
| UC-40 | Legal Consultation | 6/6 | 6 | 100% |
| **Total** | **5 New UCs** | **30/30** | **30** | **100%** |

---

## Related Files

- **Test Config:** `testing/fitness/fitness-loop-new-uc-36-40.json`
- **Test Report:** `reports/new-uc-36-40-agent-fitness.md`
- **Scenarios:** `testing/scenarios/uc-36-grand-hall.json` through `uc-40-justice-law.json`

---

## Running These Tests

```bash
./scripts/run-agent-fitness-loop.sh testing/fitness/fitness-loop-new-uc-36-40.json
```

Or run individually:

```bash
# UC-36
curl -s -X POST http://localhost:6129/api/v1/agent/scenarios/run \
  -H 'content-type: application/json' \
  -d @testing/scenarios/uc-36-grand-hall.json

# UC-37
curl -s -X POST http://localhost:6129/api/v1/agent/scenarios/run \
  -H 'content-type: application/json' \
  -d @testing/scenarios/uc-37-fitpro.json
```

---

*Part of Bizing Schema v0 Testing Suite*
