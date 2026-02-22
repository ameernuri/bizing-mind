---
date: 2026-02-22
type: test-scenario
format: json-embedded
uc: 40
business: Justice Law Partners
category: professional
---

# UC-40: Legal Consultation

## Description
Retainer-based consultation booking

## Test Scenario

```json
{
  "defaults": {
    "dryRun": false,
    "scope": {
      "bizId": "biz_3A2PhjOA6BtyZQTeDhEhlJI0oRV"
    }
  },
  "scenarios": [
    {
      "id": "uc40-01",
      "name": "Create professional business",
      "prompt": "insert into bizes id = biz_3A2PhjOA6BtyZQTeDhEhlJI0oRV name = Justice Law Partners slug = justice-law-202502221116 status = active timezone = America/Los_Angeles"
    },
    {
      "id": "uc40-02",
      "name": "Create location",
      "prompt": "insert into locations id = loc_3A2PhlV63E7YbqJQt62j6DQGQjM biz_id = biz_3A2PhjOA6BtyZQTeDhEhlJI0oRV name = Main Location slug = main-40-202502221116 timezone = America/Los_Angeles"
    },
    {
      "id": "uc40-03",
      "name": "Create resource",
      "prompt": "insert into resources id = res_3A2Phq4DDAKWsI8bg5aFRhXkGKs biz_id = biz_3A2PhjOA6BtyZQTeDhEhlJI0oRV location_id = loc_3A2PhlV63E7YbqJQt62j6DQGQjM type = host name = Legal Consultation Resource slug = res-40-202502221116 timezone = America/Los_Angeles capacity = 1"
    },
    {
      "id": "uc40-04",
      "name": "Create calendar",
      "prompt": "insert into calendars id = cal_3A2Phj90FfJ7C3zO4FjrfR3cIyi biz_id = biz_3A2PhjOA6BtyZQTeDhEhlJI0oRV name = Booking Calendar timezone = America/Los_Angeles slot_duration_min = 60 status = active"
    },
    {
      "id": "uc40-05",
      "name": "Create offer",
      "prompt": "insert into offers id = ofr_3A2PhnT7hLi7Sj6iPP3GQwCGg9k biz_id = biz_3A2PhjOA6BtyZQTeDhEhlJI0oRV name = Legal Consultation Service slug = offer-40-202502221116 status = active execution_mode = request"
    },
    {
      "id": "uc40-06",
      "name": "Verify setup",
      "prompt": "list bizes where id = biz_3A2PhjOA6BtyZQTeDhEhlJI0oRV"
    }
  ]
}
```

## Usage

```bash
curl -s -X POST http://localhost:6129/api/v1/agent/scenarios/run \
  -H 'content-type: application/json' \
  -d @testing/scenarios/uc-40-justice-law.md
```

---

*Auto-generated from JSON*