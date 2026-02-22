#!/bin/bash
set -euo pipefail

API_URL="${API_URL:-http://localhost:6129/api/v1/agent/lifecycle/run}"
DEFAULT_FILE="/Users/ameer/projects/bizing-mind/workspace/agent-api-uc1-lifecycle-v0.json"
INPUT_FILE="${1:-$DEFAULT_FILE}"

if [ ! -f "$INPUT_FILE" ]; then
  echo "Lifecycle file not found: $INPUT_FILE"
  exit 1
fi

echo "=== Lifecycle Test Runner ==="
echo "API: $API_URL"
echo "File: $INPUT_FILE"
echo ""

RESULT=$(curl -s -X POST "$API_URL" -H "content-type: application/json" -d @"$INPUT_FILE")

echo "$RESULT" | jq -r '
  "Success: \(.success)",
  "DryRun: \(.dryRun)",
  "Persisted: \(.persisted)",
  "DurationMs: \(.durationMs)",
  "Phases: \(.summary.totalPhases), Steps: \(.summary.totalSteps), Passed: \(.summary.passedSteps), Failed: \(.summary.failedSteps)",
  (if .fatalError then "FatalError: \(.fatalError)" else empty end)
'

echo ""
echo "Phase Summary:"
echo "$RESULT" | jq -r '
  .phaseSummaries[]
  | " - \(.phaseName): \(.passedSteps)/\(.totalSteps) passed"
'

FAILED=$(echo "$RESULT" | jq -r '.summary.failedSteps // 0')
if [ "$FAILED" -gt 0 ]; then
  echo ""
  echo "Issues:"
  echo "$RESULT" | jq -r '
    .issues[]
    | " - [\(.classification)] \(.phaseName) / \(.stepName): \(.message)"
  '
fi

echo ""
echo "Warnings:"
echo "$RESULT" | jq -r '.warnings[]?' | sed 's/^/ - /'

echo ""
echo "Variable snapshot keys:"
echo "$RESULT" | jq -r '.variables | keys[]'
