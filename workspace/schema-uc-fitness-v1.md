---
date: 2026-02-21
tags:
  - analysis
  - schema
  - use-cases
  - fitness
  - v0
---

# Schema-Use Case Fitness Snapshot (v0)

Primary source:
- [[booking-schema-v0-coverage-report]]

This file is a compact snapshot of the current fitness run.

## Current Score
- Total UCs mapped: `257`
- `#full`: `144`
- `#strong`: `113`
- `#partial`: `0`
- `#gap`: `0`

## What Changed in This Refresh
- Added first-class schema modules for CRM (`crm_*`), quotes (`sales_quote_*`), receivables installments/autopay (`installment_*`, `billing_account_autopay_rules`, `autocollection_attempts`), wishlist (`wishlists`, `wishlist_items`), marketing performance (`marketing_audience_*`, `ad_spend_daily_facts`, `offline_conversion_pushes`), gift delivery (`gift_delivery_*`), and batch supply (`production_batches`, `production_batch_reservations`).
- Closed all previously partial UCs in Parts 34-36 and upgraded bakery/ad-feedback flows to full where new first-class tables now exist.
- Completed a composability hardening pass: unified contact identity usage through `crm_contacts` + `crm_contact_channels`, normalized quote-acceptance actors to contact/subject anchors, and replaced nullable combined uniqueness with split partial uniques for participant/membership anchors.

## Read This Next
1. [[booking-schema-v0-coverage-report]]
2. [[booking-schema-definitive-guide-v0-eli5]]
3. [[booking-use-cases-v3]]
