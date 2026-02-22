# Workspace

Central workspace for Bizing testing, documentation, and utilities.

## Structure

```
workspace/
├── testing/           # All test files and scenarios
│   ├── scenarios/     # UC-based scenario tests (UC-1 to UC-35)
│   ├── lifecycle/     # Full lifecycle test packs
│   ├── fitness/       # Fitness loop configs and smoke tests
│   └── personas/      # Extended persona test files
├── documentation/     # Guides, explainers, and specifications
├── reports/           # Test results and analysis reports
├── scripts/           # Shell scripts and utilities
└── config/            # Configuration files (MCP, etc.)
```

## Quick Reference

### Testing

| Folder | Purpose | Example Files |
|--------|---------|---------------|
| `testing/scenarios/` | Individual UC scenario tests | `uc1-solo-consultant.json`, `uc21-therapist.json` |
| `testing/lifecycle/` | End-to-end lifecycle packs | `slot-booking-lifecycle.json`, `queue-walkin-lifecycle.json` |
| `testing/fitness/` | Combined test suites | `fitness-loop-v0.json`, `scenario-smoke.json` |
| `testing/personas/` | Extended persona tests | `uc21-therapist.json` to `uc35-it-support.json` |

### Documentation

| File | Description |
|------|-------------|
| `booking-use-cases-v3.md` | Comprehensive use case definitions (UC-1 to UC-168) |
| `booking-schema-definitive-guide-v0.md` | Schema documentation |
| `agent-testing-workflow-definitive-v0.md` | Testing workflow guide |
| `agent-testing-infra-combo-guide.md` | Infrastructure guide |
| `schema-hardening-plan-v0-to-10.md` | Schema evolution roadmap |
| `tester-personas.md` | 42 tester personas |

### Reports

| File | Description |
|------|-------------|
| `final-test-report-100-percent.md` | 100% pass rate achievement |
| `extended-persona-report.md` | UC-21 to UC-35 test results |
| `uc-testing-report-uc1-20.md` | Initial UC test results |
| `latest-agent-fitness.json` | Most recent fitness run |

### Scripts

| Script | Purpose |
|--------|---------|
| `run-uc-tests.sh` | Dynamic UC test runner with fresh IDs |
| `run-agent-fitness-loop.sh` | Execute fitness test loops |
| `run-lifecycle-examples.sh` | Run lifecycle scenario packs |
| `generate-persona-tests.js` | Generate persona test files |

## Usage

### Run UC Tests

```bash
# Run all UCs (UC-1 to UC-20)
./scripts/run-uc-tests.sh

# Run specific UC
./scripts/run-uc-tests.sh 5
```

### Run Lifecycle Tests

```bash
# Run all lifecycle examples
./scripts/run-lifecycle-examples.sh

# Or with specific config
./scripts/run-agent-fitness-loop.sh testing/fitness/agent-fitness-loop-lifecycle-examples-v0.json
```

### Run Fitness Loop

```bash
./scripts/run-agent-fitness-loop.sh testing/fitness/agent-fitness-loop-v0.json
```

## File Naming Conventions

### Test Files
- `uc{N}-{description}.json` — Individual UC scenarios
- `{scenario}-lifecycle.json` — Lifecycle packs
- `fitness-loop-{version}.json` — Fitness loop configs

### Documentation
- `{topic}-{version}.md` — Main documentation
- `{topic}-{version}-tts.txt` — TTS-friendly versions

### Reports
- `{test-name}-report.md` — Human-readable reports
- `{test-name}-results.json` — Machine-readable results

---

*Last organized: 2026-02-22*
