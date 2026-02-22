---
date: 2026-02-22
type: test-scenario
format: json-embedded
uc: 37
business: FitPro Training
category: fitness
---

# UC-37: Personal Training

## Description
One-on-one training with package sessions

## Test Scenario

```json
{
  "defaults": {
    "dryRun": false,
    "scope": {
      "bizId": "biz_3A2Phq2wJjq0u2Xqy1voIRr5yAl"
    }
  },
  "scenarios": [
    {
      "id": "uc37-01",
      "name": "Create fitness business",
      "prompt": "insert into bizes id = biz_3A2Phq2wJjq0u2Xqy1voIRr5yAl name = FitPro Training slug = fitpro-202502221116 status = active timezone = America/Los_Angeles"
    },
    {
      "id": "uc37-02",
      "name": "Create location",
      "prompt": "insert into locations id = loc_3A2PhiKpCzpntaWYheQ75lGMytI biz_id = biz_3A2Phq2wJjq0u2Xqy1voIRr5yAl name = Main Location slug = main-37-202502221116 timezone = America/Los_Angeles"
    },
    {
      "id": "uc37-03",
      "name": "Create resource",
      "prompt": "insert into resources id = res_3A2PhjZVLmq4NEyakPc7A9OwRpZ biz_id = biz_3A2Phq2wJjq0u2Xqy1voIRr5yAl location_id = loc_3A2PhiKpCzpntaWYheQ75lGMytI type = host name = Personal Training Resource slug = res-37-202502221116 timezone = America/Los_Angeles capacity = 1"
    },
    {
      "id": "uc37-04",
      "name": "Create calendar",
      "prompt": "insert into calendars id = cal_3A2PhkN12ivG7kB9hUUlFwrQPi0 biz_id = biz_3A2Phq2wJjq0u2Xqy1voIRr5yAl name = Booking Calendar timezone = America/Los_Angeles slot_duration_min = 60 status = active"
    },
    {
      "id": "uc37-05",
      "name": "Create offer",
      "prompt": "insert into offers id = ofr_3A2Phh7GGVxWpcHVz60fjt3oKYX biz_id = biz_3A2Phq2wJjq0u2Xqy1voIRr5yAl name = Personal Training Service slug = offer-37-202502221116 status = active execution_mode = request"
    },
    {
      "id": "uc37-06",
      "name": "Verify setup",
      "prompt": "list bizes where id = biz_3A2Phq2wJjq0u2Xqy1voIRr5yAl"
    }
  ]
}
```

## Usage

```bash
curl -s -X POST http://localhost:6129/api/v1/agent/scenarios/run \
  -H 'content-type: application/json' \
  -d @testing/scenarios/uc-37-fitpro.md
```

---

*Auto-generated from JSON*