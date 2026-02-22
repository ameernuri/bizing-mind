#!/bin/bash
set -euo pipefail

API_URL="${API_URL:-http://localhost:6129/api/v1/agent/testing/run-loop}"
CONFIG_FILE="/Users/ameer/projects/bizing-mind/workspace/agent-fitness-loop-lifecycle-examples-v0.json"

echo "=== Lifecycle Examples Test Run ==="
echo "API: $API_URL"
echo "Config: $CONFIG_FILE"

RESULT=$(curl -sS -X POST "$API_URL" -H "content-type: application/json" -d @"$CONFIG_FILE")

echo "$RESULT" | jq -r '
  "RunId: \(.summary.runId)",
  "Success: \(.summary.success)",
  "DurationMs: \(.summary.durationMs)",
  "Suites: \(.summary.totals.suites) (\(.summary.totals.suitesPassed) passed, \(.summary.totals.suitesFailed) failed)",
  "Checks: \(.summary.totals.checks) (\(.summary.totals.checksPassed) passed, \(.summary.totals.checksFailed) failed)"
'

echo ""
echo "Suite Breakdown:"
echo "$RESULT" | jq -r '.suites[] | " - \(.name): \(.passed)/\(.total) passed (success=\(.success))"'

echo ""
echo "Detailed report:"
echo " - /Users/ameer/projects/bizing-mind/workspace/reports/lifecycle-examples-agent-fitness.json"
echo " - /Users/ameer/projects/bizing-mind/workspace/reports/lifecycle-examples-agent-fitness.md"
