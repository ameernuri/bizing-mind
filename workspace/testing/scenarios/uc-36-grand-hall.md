---
date: 2026-02-22
type: test-scenario
format: json-embedded
uc: 36
business: Grand Hall Events
category: space_rental
---

# UC-36: Event Venue Rental

## Description
Multi-room venue with concurrent bookings

## Test Scenario

```json
{
  "defaults": {
    "dryRun": false,
    "scope": {
      "bizId": "biz_3A2Phq5eS0U52YQ2xIObVXARWIS"
    }
  },
  "scenarios": [
    {
      "id": "uc36-01",
      "name": "Create space_rental business",
      "prompt": "insert into bizes id = biz_3A2Phq5eS0U52YQ2xIObVXARWIS name = Grand Hall Events slug = grand-hall-202502221116 status = active timezone = America/Los_Angeles"
    },
    {
      "id": "uc36-02",
      "name": "Create location",
      "prompt": "insert into locations id = loc_3A2Phkznnt9L2m4tJBYsNmafTWB biz_id = biz_3A2Phq5eS0U52YQ2xIObVXARWIS name = Main Location slug = main-36-202502221116 timezone = America/Los_Angeles"
    },
    {
      "id": "uc36-03",
      "name": "Create resource",
      "prompt": "insert into resources id = res_3A2Pho9Sc5nrpD1F9NGkwoa9OA7 biz_id = biz_3A2Phq5eS0U52YQ2xIObVXARWIS location_id = loc_3A2Phkznnt9L2m4tJBYsNmafTWB type = host name = Event Venue Rental Resource slug = res-36-202502221116 timezone = America/Los_Angeles capacity = 1"
    },
    {
      "id": "uc36-04",
      "name": "Create calendar",
      "prompt": "insert into calendars id = cal_3A2PhnoC5CMVp8jegaXdWKuRzpe biz_id = biz_3A2Phq5eS0U52YQ2xIObVXARWIS name = Booking Calendar timezone = America/Los_Angeles slot_duration_min = 60 status = active"
    },
    {
      "id": "uc36-05",
      "name": "Create offer",
      "prompt": "insert into offers id = ofr_3A2PhqbHOlb3CuKlnGvtYfLjpeP biz_id = biz_3A2Phq5eS0U52YQ2xIObVXARWIS name = Event Venue Rental Service slug = offer-36-202502221116 status = active execution_mode = request"
    },
    {
      "id": "uc36-06",
      "name": "Verify setup",
      "prompt": "list bizes where id = biz_3A2Phq5eS0U52YQ2xIObVXARWIS"
    }
  ]
}
```

## Usage

```bash
curl -s -X POST http://localhost:6129/api/v1/agent/scenarios/run \
  -H 'content-type: application/json' \
  -d @testing/scenarios/uc-36-grand-hall.md
```

---

*Auto-generated from JSON*