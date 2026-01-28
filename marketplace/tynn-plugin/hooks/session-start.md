---
name: tynn-context-loader
event: SessionStart
description: Automatically load Tynn project context at session start
---

# Tynn Context Loader

Load project context when a Claude Code session starts.

## Behavior

### If Tynn MCP is Available

1. Call `next()` to get current work context
2. Call `project()` to get project details and ai_guidance
3. Inject context summary into the session

**Context injection format:**
```
Tynn project loaded: **[project name]**
- Active version: [version number] — [title]
- Current story: s[number] — [title] ([status])
- Top tasks: [count] tasks in progress

Run `/tynn think` to plan or `/tynn build` to execute.
```

### If Tynn MCP is NOT Available

Check for demo mode:

```bash
${CLAUDE_PLUGIN_ROOT}/lib/demo-mode/storage.sh is-active
```

**If demo mode is active** (returns "true"):

Get counts:
```bash
TASKS=$(${CLAUDE_PLUGIN_ROOT}/lib/demo-mode/storage.sh list-tasks | jq '.tasks | length')
WISHES=$(${CLAUDE_PLUGIN_ROOT}/lib/demo-mode/storage.sh list-wishes | jq '.wishes | length')
```

Output:
```
Tynn (demo mode): [TASKS] tasks, [WISHES] wishes tracked locally.
Run `/tynn setup` to connect to Tynn, or `/tynn sync` to migrate.
```

**If demo mode is NOT active** (returns "false"):

```
Tynn plugin installed but not configured.
Run `/tynn setup` to connect your account or start demo mode.
```

## Implementation

This hook should be lightweight — just load context and inject a brief summary. Don't start conversations or ask questions.

### Success Criteria
- Context loads in under 2 seconds
- Summary is 3-5 lines max
- Graceful fallback if Tynn unavailable

### Error Handling
- If `next()` fails: try `project()` alone
- If both fail: show "Tynn connection issue" message
- Never block session start on Tynn errors
