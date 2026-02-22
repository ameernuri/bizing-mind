---
date: 2026-02-22
type: test-scenario
format: json-embedded
uc: 38
business: Sparkle Auto Detail
category: auto_service
---

# UC-38: Car Detailing

## Description
Service bays with tiered packages

## Test Scenario

```json
{
  "defaults": {
    "dryRun": false,
    "scope": {
      "bizId": "biz_3A2PhmR18Ukw9cHQ8IWtXsC5rzT"
    }
  },
  "scenarios": [
    {
      "id": "uc38-01",
      "name": "Create auto_service business",
      "prompt": "insert into bizes id = biz_3A2PhmR18Ukw9cHQ8IWtXsC5rzT name = Sparkle Auto Detail slug = sparkle-auto-202502221116 status = active timezone = America/Los_Angeles"
    },
    {
      "id": "uc38-02",
      "name": "Create location",
      "prompt": "insert into locations id = loc_3A2PhttrRWsZUEg9oHBDZlH9nlr biz_id = biz_3A2PhmR18Ukw9cHQ8IWtXsC5rzT name = Main Location slug = main-38-202502221116 timezone = America/Los_Angeles"
    },
    {
      "id": "uc38-03",
      "name": "Create resource",
      "prompt": "insert into resources id = res_3A2PhoKisEhJJleTHg9QpNvEokJ biz_id = biz_3A2PhmR18Ukw9cHQ8IWtXsC5rzT location_id = loc_3A2PhttrRWsZUEg9oHBDZlH9nlr type = host name = Car Detailing Resource slug = res-38-202502221116 timezone = America/Los_Angeles capacity = 1"
    },
    {
      "id": "uc38-04",
      "name": "Create calendar",
      "prompt": "insert into calendars id = cal_3A2PhpgGzrxJeZVDgAOQ8fQ1wrq biz_id = biz_3A2PhmR18Ukw9cHQ8IWtXsC5rzT name = Booking Calendar timezone = America/Los_Angeles slot_duration_min = 60 status = active"
    },
    {
      "id": "uc38-05",
      "name": "Create offer",
      "prompt": "insert into offers id = ofr_3A2PhlK8UMZQ8kXd9s4zlnCHFE3 biz_id = biz_3A2PhmR18Ukw9cHQ8IWtXsC5rzT name = Car Detailing Service slug = offer-38-202502221116 status = active execution_mode = request"
    },
    {
      "id": "uc38-06",
      "name": "Verify setup",
      "prompt": "list bizes where id = biz_3A2PhmR18Ukw9cHQ8IWtXsC5rzT"
    }
  ]
}
```

## Usage

```bash
curl -s -X POST http://localhost:6129/api/v1/agent/scenarios/run \
  -H 'content-type: application/json' \
  -d @testing/scenarios/uc-38-sparkle-auto.md
```

---

*Auto-generated from JSON*