---
date: 2026-02-22
type: test-scenario
format: json-embedded
uc: 39
business: Global Speak Academy
category: education
---

# UC-39: Language Immersion

## Description
Intensive group classes with levels

## Test Scenario

```json
{
  "defaults": {
    "dryRun": false,
    "scope": {
      "bizId": "biz_3A2PhpWxUlMYygRKdMrVGaCdRlK"
    }
  },
  "scenarios": [
    {
      "id": "uc39-01",
      "name": "Create education business",
      "prompt": "insert into bizes id = biz_3A2PhpWxUlMYygRKdMrVGaCdRlK name = Global Speak Academy slug = global-speak-202502221116 status = active timezone = America/Los_Angeles"
    },
    {
      "id": "uc39-02",
      "name": "Create location",
      "prompt": "insert into locations id = loc_3A2PhnO45nwFM5rXLdzAN5cZXui biz_id = biz_3A2PhpWxUlMYygRKdMrVGaCdRlK name = Main Location slug = main-39-202502221116 timezone = America/Los_Angeles"
    },
    {
      "id": "uc39-03",
      "name": "Create resource",
      "prompt": "insert into resources id = res_3A2PhnHFZL25suB8GV9NqgtAtuF biz_id = biz_3A2PhpWxUlMYygRKdMrVGaCdRlK location_id = loc_3A2PhnO45nwFM5rXLdzAN5cZXui type = host name = Language Immersion Resource slug = res-39-202502221116 timezone = America/Los_Angeles capacity = 1"
    },
    {
      "id": "uc39-04",
      "name": "Create calendar",
      "prompt": "insert into calendars id = cal_3A2PhmXAXNQi2YkZ5XLlu6IVFSS biz_id = biz_3A2PhpWxUlMYygRKdMrVGaCdRlK name = Booking Calendar timezone = America/Los_Angeles slot_duration_min = 60 status = active"
    },
    {
      "id": "uc39-05",
      "name": "Create offer",
      "prompt": "insert into offers id = ofr_3A2PhrbOi0FoMb8EhA4sfPdO1xv biz_id = biz_3A2PhpWxUlMYygRKdMrVGaCdRlK name = Language Immersion Service slug = offer-39-202502221116 status = active execution_mode = request"
    },
    {
      "id": "uc39-06",
      "name": "Verify setup",
      "prompt": "list bizes where id = biz_3A2PhpWxUlMYygRKdMrVGaCdRlK"
    }
  ]
}
```

## Usage

```bash
curl -s -X POST http://localhost:6129/api/v1/agent/scenarios/run \
  -H 'content-type: application/json' \
  -d @testing/scenarios/uc-39-global-speak.md
```

---

*Auto-generated from JSON*