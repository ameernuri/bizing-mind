---
date: 2026-02-21
tags:
  - schema
  - guide
  - definitive
  - education
  - programs
  - certification
  - v0
---

# Definitive Guide: Education + Program Setup (v0)

Source links:
- Base guide: [[booking-schema-definitive-guide-v0-eli5]]
- Use cases: [[booking-use-cases-v3]]
- Coverage: [[booking-schema-v0-coverage-report]]

---

## 0) Latest Schema Notes (2026-02-21)

- Coverage rerun remains complete (`257/257` UC lines mapped), with overall totals now `#full = 144`, `#strong = 113`.
- Contact identity is now centralized in `crm_contacts` and `crm_contact_channels`, which improves learner/contact portability across education, CRM, and messaging journeys.
- Anchor-based uniqueness constraints were hardened for conversation and audience membership models, reducing duplicate active-participant/member edge cases.

---

## 1) Who This Is For

Use this setup for:
- cohort learning and scheduled sessions,
- attendance and grading,
- requirement gating and progression,
- certification outcomes with auditability.

ELI5:
Teach people, measure what they learned, and show trustworthy proof.

---

## 2) Core Backbone

1. Program structure
- `programs`
- `program_cohorts`
- `program_cohort_sessions`

2. Participation and attendance
- `cohort_enrollments`
- `session_attendance_records`

3. Requirement graph
- `requirement_sets`, `requirement_nodes`, `requirement_edges`
- `requirement_evaluations`, `requirement_evidence_links`

4. Assessment pipeline
- `assessment_templates`, `assessment_items`
- `assessment_attempts`, `assessment_responses`, `assessment_results`
- `grading_events`

5. Certification lifecycle
- `certification_templates`
- `certification_awards`

---

## 3) Setup Playbook

1. Define progression graph first
- model prerequisites and unlock paths before launching cohorts.

2. Attach assessment evidence to requirements
- every pass/fail should map to explicit evidence links.

3. Use append-style grading events
- avoid overwriting decisions; preserve grading timeline.

4. Keep commerce and education separate but linked
- sell with `sellables`/orders, learn with education/progression tables.

5. Issue certifications from deterministic state
- only award when requirement evaluations and assessments agree.

---

## 4) High-Value Patterns

- Multi-path progression through graph edges instead of rigid stage columns.
- Mixed auto/manual grading with full event trails.
- Attendance as structured evidence for progression decisions.
- Program-level and session-level analytics from reporting facts.

---

## 5) Common Mistakes

- Mixing enrollment state with competency state in one column.
- Replacing scores without event history.
- Encoding prerequisite rules in opaque blobs.
- Treating certification as a UI-only badge.

---

## 6) Health Checklist

- Every requirement decision has evidence rows.
- Every attempt references a template/item context.
- Every certificate is anchored to evaluated outcomes.
- Attendance and assessment can be joined for audits.
