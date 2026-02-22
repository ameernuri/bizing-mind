#!/bin/bash
set -euo pipefail

API_URL="${API_URL:-http://localhost:6129/api/v1/agent/testing/run-loop}"
DEFAULT_CONFIG="/Users/ameer/projects/bizing-mind/workspace/agent-fitness-loop-v0.json"
CONFIG_FILE="${1:-$DEFAULT_CONFIG}"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file not found: $CONFIG_FILE"
  exit 1
fi

echo "=== Agent Fitness Loop ==="
echo "API: $API_URL"
echo "Config: $CONFIG_FILE"
echo ""

RESULT=$(curl -s -X POST "$API_URL" -H "content-type: application/json" -d @"$CONFIG_FILE")

echo "$RESULT" | jq -r '
  "RunId: \(.summary.runId)",
  "Success: \(.summary.success)",
  "DurationMs: \(.summary.durationMs)",
  "Suites: \(.summary.totals.suites) (\(.summary.totals.suitesPassed) passed, \(.summary.totals.suitesFailed) failed)",
  "Checks: \(.summary.totals.checks) (\(.summary.totals.checksPassed) passed, \(.summary.totals.checksFailed) failed)"
'

echo ""
echo "Suite Breakdown:"
echo "$RESULT" | jq -r '
  .suites[]
  | " - \(.name) [\(.kind)]: \(.passed)/\(.total) passed (success=\(.success))"
'

ISSUES=$(echo "$RESULT" | jq -r '.issues | length')
if [ "$ISSUES" -gt 0 ]; then
  echo ""
  echo "Issues:"
  echo "$RESULT" | jq -r '
    .issues[]
    | " - [\(.classification)] \(.suiteName): \(.message)"
  '
fi

echo ""
echo "Markdown Report Preview:"
echo "$RESULT" | jq -r '.report.markdown' | sed -n '1,80p'
