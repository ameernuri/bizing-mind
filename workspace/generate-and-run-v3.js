#!/usr/bin/env node
/**
 * Generate 20 fresh UC test files with current timestamp KSUIDs
 * and run them against the API
 */

const fs = require('fs');
const path = require('path');

// Parse fresh KSUIDs from file
const ksuidContent = fs.readFileSync('/tmp/fresh-ksuids.txt', 'utf8');

const freshKsuidMap = {};
let currentUC = 0;

ksuidContent.split('\n').forEach(line => {
  const ucMatch = line.match(/UC-(\d+):/);
  if (ucMatch) {
    currentUC = parseInt(ucMatch[1]);
    freshKsuidMap[currentUC] = {};
  }
  
  const idMatch = line.match(/\s+(biz|loc|res|cal|ofr):\s+(\S+)/);
  if (idMatch && currentUC > 0) {
    freshKsuidMap[currentUC][idMatch[1]] = idMatch[2];
  }
});

console.log('Parsed fresh KSUIDs:', JSON.stringify(freshKsuidMap, null, 2));

// Helper to extract old ID patterns from v2 file content
function extractOldIds(content) {
  const ids = {};
  
  // Extract bizId from defaults.scope
  const bizIdMatch = content.match(/"bizId":\s*"([^"]+)"/);
  if (bizIdMatch) ids.biz = bizIdMatch[1];
  
  // Extract other IDs from prompts - find all ID patterns
  const allIds = [...content.matchAll(/(?:id\s*=\s*|id\s*=\s*|where\s+id\s*=\s*|biz_id\s*=\s*|location_id\s*=\s*|calendar_id\s*=\s*|offer_id\s*=\s*|service_group_id\s*=\s*)"?([a-z]+_[A-Za-z0-9]+)"?/g)];
  
  allIds.forEach(match => {
    const id = match[1];
    const prefix = id.split('_')[0];
    if (!ids[prefix]) {
      ids[prefix] = id;
    }
  });
  
  return ids;
}

// Generate v3 file for a UC
function generateV3File(ucNum, freshIds) {
  const v2Path = path.join('/Users/ameer/projects/bizing-mind/workspace', `agent-api-uc${ucNum}-fresh-v2.json`);
  const v3Path = path.join('/Users/ameer/projects/bizing-mind/workspace', `agent-api-uc${ucNum}-fresh-v3.json`);
  
  let content = fs.readFileSync(v2Path, 'utf8');
  
  // Extract old IDs
  const oldIds = extractOldIds(content);
  console.log(`UC${ucNum} old IDs:`, oldIds);
  
  // Create mapping of old -> new
  const idMapping = {};
  
  // Map biz
  if (oldIds.biz && freshIds.biz) {
    idMapping[oldIds.biz] = freshIds.biz;
  }
  
  // Map other entity types
  ['loc', 'res', 'cal', 'ofr', 'ven', 'sg', 'svc', 'ov', 'ar'].forEach(type => {
    if (oldIds[type] && freshIds[type]) {
      idMapping[oldIds[type]] = freshIds[type];
    }
  });
  
  console.log(`UC${ucNum} ID mapping:`, idMapping);
  
  // Replace all occurrences
  Object.entries(idMapping).forEach(([oldId, newId]) => {
    // Create a global regex for the old ID
    const regex = new RegExp(oldId.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'g');
    content = content.replace(regex, newId);
  });
  
  // Write v3 file
  fs.writeFileSync(v3Path, content);
  console.log(`Generated: ${v3Path}`);
  
  return v3Path;
}

// Generate all 20 files
const generatedFiles = [];
for (let i = 1; i <= 20; i++) {
  if (freshKsuidMap[i]) {
    const filePath = generateV3File(i, freshKsuidMap[i]);
    generatedFiles.push(filePath);
  }
}

console.log(`\nGenerated ${generatedFiles.length} v3 files`);
console.log('Files:', generatedFiles.join('\n'));

// Export for use in API testing
module.exports = { generatedFiles, freshKsuidMap };

// Run API tests if executed directly
if (require.main === module) {
  runAllTests();
}

async function runAllTests() {
  console.log('\n=== Running API Tests ===\n');
  
  const results = [];
  
  for (let i = 1; i <= 20; i++) {
    const v3Path = path.join('/Users/ameer/projects/bizing-mind/workspace', `agent-api-uc${i}-fresh-v3.json`);
    
    if (!fs.existsSync(v3Path)) {
      console.log(`Skipping UC${i} - file not found`);
      continue;
    }
    
    const testData = JSON.parse(fs.readFileSync(v3Path, 'utf8'));
    
    console.log(`\n--- UC${i}: ${testData.scenarios?.[0]?.name || 'Unknown'} ---`);
    
    try {
      const response = await fetch('http://localhost:6129/api/v1/agent/scenarios/run', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(testData),
      });
      
      const responseData = await response.json();
      
      const result = {
        uc: i,
        status: response.status,
        ok: response.ok,
        scenarioCount: testData.scenarios?.length || 0,
        error: responseData.error || null,
        summary: responseData.summary || null,
      };
      
      results.push(result);
      
      if (response.ok) {
        console.log(`✅ UC${i}: ${response.status} - ${testData.scenarios?.length || 0} scenarios`);
      } else {
        console.log(`❌ UC${i}: ${response.status} - ${responseData.error || 'Unknown error'}`);
      }
    } catch (err) {
      console.log(`💥 UC${i}: ERROR - ${err.message}`);
      results.push({
        uc: i,
        status: 'ERROR',
        ok: false,
        error: err.message,
      });
    }
  }
  
  // Summary
  console.log('\n=== TEST SUMMARY ===');
  console.log(`Total: ${results.length}`);
  console.log(`Passed: ${results.filter(r => r.ok).length}`);
  console.log(`Failed: ${results.filter(r => !r.ok).length}`);
  
  console.log('\nDetailed Results:');
  results.forEach(r => {
    const status = r.ok ? '✅' : '❌';
    console.log(`${status} UC${r.uc}: ${r.status} - ${r.scenarioCount || 0} scenarios ${r.error ? '- ' + r.error : ''}`);
  });
  
  // Save results
  const resultsPath = path.join('/Users/ameer/projects/bizing-mind/workspace', 'uc-test-results-v3.json');
  fs.writeFileSync(resultsPath, JSON.stringify(results, null, 2));
  console.log(`\nResults saved to: ${resultsPath}`);
}

// Run tests
runAllTests().catch(console.error);
