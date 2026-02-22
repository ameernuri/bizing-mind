---
date: 2026-02-11
tags: 
  - session
  - log
  - mindsync
  - hard-mindsync
---

# 📝 Session: CODESYNC & MINDSYNC Levels Definition

> *HARD MINDSYNC: Major terminology definition across ALL mind files*

## Participants

- **Ameer** — Human
- **Pac** — AI Assistant

## Context

Defined critical new terminology for the development workflow: CODESYNC and MINDSYNC levels (SOFT/HARD).

## What We Did

### 1. Defined CODESYNC

**Command:** When user says "codesync"

**Process:**
```
Type Check → Run Tests → IF ALL PASS → Commit → Push → Create PR
```

**Steps:**
1. `tsc --noEmit` — Zero type errors
2. `vitest run` — All unit tests pass
3. `playwright test` — All E2E tests pass
4. **IF ALL PASS:**
   - Commit with code + mind changes
   - Push to feature branch
   - Create PR
5. **IF ANY FAIL:** — DO NOT COMMIT

**CODESYNC = Check → Test → Commit → Push → PR (all or nothing)**

### 2. Defined MINDSYNC Levels

#### SOFT MINDSYNC (Every Change)
Light update after every work session:
- [[symbiosis/feedback]] — Learnings
  - rules
- [[symbiosis/standup]] — Status if changed
- Brief notes if significant

#### HARD MINDSYNC (Big Events / Explicit)
Extensive update for:
- Major features completed
- Workflow changes (THIS SESSION)
- Architecture updates
- Explicit "mindsync" command

**Includes:**
- [[symbiosis/feedback]] — Detailed learnings
- [[symbiosis/standup]] — Task status
  - blockers
- [[memory/sessions/YYYY-MM-DD]] — Full session log
- [[knowledge/]] files — Architecture patterns
- [[MAP]] — If structure changed
- [[backlog]] — Kanban updates
- Any other relevant files

### 3. Updated ALL Mind Files (HARD MINDSYNC)

**Files Modified:**

#### symbiosis/feedback.md
- ✅ Added CODESYNC definition and process
- ✅ Updated Rules to Remember (now 12 rules)
- ✅ Clarified SOFT vs HARD mindsync

#### MIND-FRAMEWORK.md
- ✅ Added CODESYNC section before MINDSYNC
- ✅ Updated MINDSYNC with SOFT/HARD levels
- ✅ Updated quick checklist with mindsync levels

#### skills/workflow/documentation-standards.md
- ✅ Replaced MINDSYNC section with CODESYNC + levels
- ✅ Added CODESYNC process with steps
- ✅ Added MINDSYNC checklist

#### .templates/session-log.md
- ✅ Added MINDSYNC Level checklist
- ✅ Added CODESYNC checklist

## Decisions Made

1. **CODESYNC standardizes the commit process** — Check → Test → Commit → Push → PR
2. **SOFT MINDSYNC for routine updates** — Feedback + standup if changed
3. **HARD MINDSYNC for major events** — All relevant files
4. **Every change gets SOFT MINDSYNC** — Routine context preservation
5. **Explicit "mindsync" triggers HARD MINDSYNC** — Comprehensive update

## Learnings

- CODESYNC ensures testing discipline before commit
- SOFT mindsync keeps lightweight context with every change
- HARD mindsync ensures comprehensive documentation for major events
- Clear terminology prevents confusion

## Files Changed

### Mind Files
- [x] [[symbiosis/feedback]] — CODESYNC + mindsync levels documented
- [x] [[MIND-FRAMEWORK]] — CODESYNC + SOFT/HARD mindsync sections
- [x] [[skills/workflow/documentation-standards]] — Complete rewrite with new terms
- [x] [[.templates/session-log]] — MINDSYNC + CODESYNC checklists
- [x] Session log created (this file)

### Documentation Work
- [x] CODESYNC defined with step-by-step process
- [x] MINDSYNC levels defined (SOFT/HARD)
- [x] Pre-commit checklist updated
- [x] Cross-references added
- [x] **Mindful links created** — Connected CODESYNC to [[MIND-FRAMEWORK]]
  - [[skills/workflow/documentation-standards]]
  - [[.templates/session-log]]

### Link Strategy Applied
- CODESYNC linked to [[MIND-FRAMEWORK]] — Workflow context
- MINDSYNC levels linked to [[skills/workflow/documentation-standards]] — Detailed guide
- Session template linked to [[.templates/session-log]] — Template reference
- Related concepts connected across files for discovery

### Git Workflow
- [x] Feature branch: N/A (mind-only update)
- [x] Mind files committed together

### Testing
- [x] Type check — N/A (markdown only)
- [x] Unit tests — N/A
- [x] E2E tests — N/A

## 💡 Key Insight

**CODESYNC transforms "hoping tests pass" into "knowing tests pass before commit." SOFT mindsync keeps context light but present. HARD mindsync ensures comprehensive preservation for major milestones.**

---

*HARD MINDSYNC complete. All terminology updated across mind files.*

<!-- Associated via ensures from association-2026-02-20-06-40-03.md -->
