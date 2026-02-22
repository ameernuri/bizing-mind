#!/bin/bash
set -euo pipefail

# Persona UC test runner (UC-21..UC-35).
# Regenerates persona scenario files each run so IDs/slugs are always fresh.

WORKSPACE_DIR="/Users/ameer/projects/bizing-mind/workspace"
API_URL="${API_URL:-http://localhost:6129/api/v1/agent/scenarios/run}"

echo "=== Persona UC Test Runner ==="
echo "API: $API_URL"
echo ""

node "$WORKSPACE_DIR/generate-persona-tests.js" >/tmp/persona-gen.log
echo "Regenerated persona scenario files."

run_one() {
  local uc=$1
  local file="$WORKSPACE_DIR/agent-api-uc${uc}-persona.json"

  if [ ! -f "$file" ]; then
    echo "UC-$uc: scenario file not found: $file"
    return 1
  fi

  local result
  result=$(curl -s -X POST "$API_URL" -H "content-type: application/json" -d @"$file")

  local total succeeded pct
  total=$(echo "$result" | jq -r '.total // 0')
  succeeded=$(echo "$result" | jq -r '.succeeded // 0')
  if [ "$total" -eq 0 ]; then
    pct=0
  else
    pct=$((succeeded * 100 / total))
  fi

  local icon="➡️"
  [ "$pct" -eq 100 ] && icon="✅"
  printf "%s UC-%2d: %2d/%2d passed (%3d%%)\n" "$icon" "$uc" "$succeeded" "$total" "$pct"

  echo "$result" | jq -r '.results[] | select(.success == false) | "  FAIL: \(.id) - \(.error)"'
}

if [ $# -gt 0 ]; then
  run_one "$1"
  exit 0
fi

total_passed=0
total_scenarios=0

for uc in $(seq 21 35); do
  file="$WORKSPACE_DIR/agent-api-uc${uc}-persona.json"
  result=$(curl -s -X POST "$API_URL" -H "content-type: application/json" -d @"$file")
  total=$(echo "$result" | jq -r '.total // 0')
  succeeded=$(echo "$result" | jq -r '.succeeded // 0')
  total_passed=$((total_passed + succeeded))
  total_scenarios=$((total_scenarios + total))
  pct=$(( total == 0 ? 0 : (succeeded * 100 / total) ))

  icon="➡️"
  [ "$pct" -eq 100 ] && icon="✅"
  printf "%s UC-%2d: %2d/%2d passed (%3d%%)\n" "$icon" "$uc" "$succeeded" "$total" "$pct"
  echo "$result" | jq -r '.results[] | select(.success == false) | "  FAIL: \(.id) - \(.error)"'
done

echo ""
echo "=== SUMMARY ==="
overall_pct=$(( total_scenarios == 0 ? 0 : (total_passed * 100 / total_scenarios) ))
echo "Total: $total_passed/$total_scenarios scenarios passed ($overall_pct%)"
