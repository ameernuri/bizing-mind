#!/bin/bash
# UC Test Runner - Generates fresh IDs for each run
# Usage: ./run-uc-tests.sh [uc_number]

API_URL="http://localhost:6129/api/v1/agent/scenarios/run"
TS=$(date +%Y%m%d%H%M%S)

echo "=== UC Test Runner ==="
echo "Timestamp: $TS"
echo ""

# Generate fresh test file with KSUIDs
generate_uc_file() {
  local uc=$1
  local ts=$2
  local outfile=$3
  
  # Generate fresh KSUIDs
  cd /Users/ameer/projects/bizing/packages/db
  node -e "
    const KSUID = require('ksuid');
    function id(tag) { return tag + '_' + KSUID.randomSync().string; }
    
    const biz = id('biz');
    const loc = id('loc');
    const res = id('res');
    const cal = id('cal');
    
    const scenarios = [];
    
    // UC-specific scenarios
    if ($uc <= 10) {
      // Full scenarios for UC-1 to UC-10
      scenarios.push(
        { id: 'uc${uc}-01', name: 'Create business', prompt: 'insert into bizes id = ' + biz + ' name = Test Business UC${uc} slug = test-uc${uc}-' + '$ts' + ' status = active timezone = America/Los_Angeles' },
        { id: 'uc${uc}-02', name: 'Create location', prompt: 'insert into locations id = ' + loc + ' biz_id = ' + biz + ' name = Test Location slug = test-loc-${uc}-' + '$ts' + ' timezone = America/Los_Angeles' },
        { id: 'uc${uc}-03', name: 'Create resource', prompt: 'insert into resources id = ' + res + ' biz_id = ' + biz + ' location_id = ' + loc + ' type = host name = Test Resource slug = test-res-${uc}-' + '$ts' + ' timezone = America/Los_Angeles capacity = 1' },
        { id: 'uc${uc}-04', name: 'Create calendar', prompt: 'insert into calendars id = ' + cal + ' biz_id = ' + biz + ' name = Test Calendar timezone = America/Los_Angeles slot_duration_min = 60 status = active' },
        { id: 'uc${uc}-05', name: 'Verify', prompt: 'list bizes where id = ' + biz }
      );
    } else {
      // Simpler scenarios for UC-11 to UC-20
      scenarios.push(
        { id: 'uc${uc}-01', name: 'Create business', prompt: 'insert into bizes id = ' + biz + ' name = Test Business UC${uc} slug = test-uc${uc}-' + '$ts' + ' status = active timezone = America/Los_Angeles' },
        { id: 'uc${uc}-02', name: 'Create location', prompt: 'insert into locations id = ' + loc + ' biz_id = ' + biz + ' name = Test Location slug = test-loc-${uc}-' + '$ts' + ' timezone = America/Los_Angeles' },
        { id: 'uc${uc}-03', name: 'Create resource', prompt: 'insert into resources id = ' + res + ' biz_id = ' + biz + ' location_id = ' + loc + ' type = host name = Test Resource slug = test-res-${uc}-' + '$ts' + ' timezone = America/Los_Angeles capacity = 1' },
        { id: 'uc${uc}-04', name: 'Verify', prompt: 'list bizes where id = ' + biz }
      );
    }
    
    const json = {
      defaults: { dryRun: false, scope: { bizId: biz } },
      scenarios: scenarios
    };
    
    console.log(JSON.stringify(json, null, 2));
  " > "$outfile"
}

# Run single UC or all
if [ -n "$1" ]; then
  # Run specific UC
  uc=$1
  outfile="/tmp/uc${uc}-${TS}.json"
  echo "Generating fresh test file for UC-$uc..."
  generate_uc_file $uc $TS $outfile
  
  echo "Running UC-$uc..."
  result=$(curl -s -X POST $API_URL -H "content-type: application/json" -d @$outfile)
  total=$(echo $result | jq -r '.total // 0')
  succeeded=$(echo $result | jq -r '.succeeded // 0')
  pct=$((succeeded * 100 / total))
  echo "UC-$uc: $succeeded/$total passed ($pct%)"
  
  # Show failures
  echo "$result" | jq -r '.results[] | select(.success == false) | "  FAIL: \(.id) - \(.error)"'
  
  rm $outfile
else
  # Run all UCs
  total_passed=0
  total_scenarios=0
  
  for uc in $(seq 1 20); do
    outfile="/tmp/uc${uc}-${TS}.json"
    generate_uc_file $uc $TS $outfile
    
    result=$(curl -s -X POST $API_URL -H "content-type: application/json" -d @$outfile)
    total=$(echo $result | jq -r '.total // 0')
    succeeded=$(echo $result | jq -r '.succeeded // 0')
    total_passed=$((total_passed + succeeded))
    total_scenarios=$((total_scenarios + total))
    pct=$((succeeded * 100 / total))
    
    icon="➡️"
    [ "$pct" -eq 100 ] && icon="✅"
    printf "%s UC-%2d: %2d/%2d passed (%3d%%)\n" "$icon" $uc $succeeded $total $pct
    
    rm $outfile
  done
  
  echo ""
  echo "=== SUMMARY ==="
  overall_pct=$((total_passed * 100 / total_scenarios))
  echo "Total: $total_passed/$total_scenarios scenarios passed ($overall_pct%)"
fi
