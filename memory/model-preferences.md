---
date: 2026-02-22
tags:
  - configuration
  - model-selection
  - preferences
---

# Model Selection Preferences

**Primary:** Kimi (kimi-coding/k2p5)
- Used for: General tasks, analysis, planning, communication

**Coding:** Codex (openai-codex/gpt-5.3-codex or gpt-5.2-codex)
- Used for: Code generation, refactoring, debugging, schema changes

## Implementation

When spawning sub-agents:
- Default (most tasks): `kimi-coding/k2p5`
- Coding tasks: `openai-codex/gpt-5.3-codex`

## Examples

```javascript
// General task - use Kimi
sessions_spawn({
  task: "Analyze requirements...",
  model: "kimi-coding/k2p5"
})

// Coding task - use Codex  
sessions_spawn({
  task: "Fix the schema migration...",
  model: "openai-codex/gpt-5.3-codex"
})
```

Set by Ameer on 2026-02-22.
