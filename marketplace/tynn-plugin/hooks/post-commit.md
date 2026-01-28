---
name: tynn-commit-sync
event: PostToolUse
tool: Bash
match_output: "\\[.*\\] .+"
description: Auto-update Tynn task status when commits reference task numbers
---

# Tynn Commit Sync

Automatically update task status when git commits reference Tynn tasks.

## Trigger Conditions

This hook triggers after a successful `git commit` command.

**Detection**: Look for git commit output patterns:
- `[branch abc1234] Commit message`
- Contains task references like `t123`, `#123`, `task-123`

## Task Reference Patterns

Detect these patterns in commit messages:

| Pattern | Example | Meaning |
|---------|---------|---------|
| `t123` | "Fix login bug t123" | Task #123 |
| `#123` | "Implement feature #123" | Task #123 |
| `task-123` | "Complete task-123" | Task #123 |
| `closes t123` | "closes t123" | Complete task |
| `fixes t123` | "fixes t123" | Complete task |
| `wip t123` | "wip t123" | Task in progress |

## Status Update Logic

Based on commit message keywords:

| Keywords | Action |
|----------|--------|
| `closes`, `fixes`, `completes`, `done` | Move to QA (testing) |
| `wip`, `working on`, `start` | Start task (starting) |
| (no keyword, just reference) | Add commit as comment |

## Implementation

### Step 1: Parse Commit Output

Extract from the bash output:
- Branch name
- Commit SHA (short)
- Commit message

### Step 2: Find Task References

```javascript
const patterns = [
  /\bt(\d+)\b/gi,           // t123
  /\b#(\d+)\b/g,            // #123
  /\btask-(\d+)\b/gi,       // task-123
];
```

### Step 3: Determine Action

```javascript
const closeKeywords = /\b(closes?|fixes?|completes?|done)\b/i;
const wipKeywords = /\b(wip|working on|starts?)\b/i;
```

### Step 4: Update Tynn

**If Tynn MCP available:**

```
# For "closes/fixes" keywords → Move to QA
testing(a: "task", number: 123, note: "Commit: abc1234")

# For "wip/start" keywords → Start task
starting(a: "task", number: 123, note: "Commit: abc1234")

# For reference only → Add comment
create(a: "comment", because: "Commit abc1234: [message]", on: {type: "task", number: 123})
```

**If demo mode:**

```bash
${CLAUDE_PLUGIN_ROOT}/lib/demo-mode/storage.sh update-task "local-123" "qa"
```

### Step 5: Report

Output a brief confirmation:

```
Tynn: t123 → QA (commit abc1234)
```

Or for multiple tasks:

```
Tynn: t123, t124 → QA (commit abc1234)
```

## Edge Cases

**Task not found**:
```
Tynn: t999 not found, skipping
```

**Invalid transition**:
```
Tynn: t123 already done, skipping
```

**No Tynn connection**:
```
Tynn: Commit references t123 but not connected. Run /tynn setup.
```

## Configuration

Users can disable this hook by setting in their Claude Code settings:

```json
{
  "tynn.autoCommitSync": false
}
```

## Minimal Output

Keep output brief — this runs on every commit. One line per update, no verbosity unless there's an error.
