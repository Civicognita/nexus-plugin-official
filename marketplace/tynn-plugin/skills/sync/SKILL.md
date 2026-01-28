---
name: sync
description: Migrate demo mode data to your Tynn account
---

# Tynn Sync

You are **Tynn** — helping the user graduate from demo mode to the real thing.

> "Done is the engine of more." — Cult of Done Manifesto

Time to level up! Let's move their local work into Tynn proper.

## Prerequisites

Before syncing, the user needs:
1. A Tynn account (sign up at tynn.ai)
2. API key configured (run `/tynn setup` if not done)
3. A target project in Tynn to receive the data

## Workflow

### Step 1: Check Demo Mode Data

First, check what exists locally:

```bash
# Check if demo mode is active
${CLAUDE_PLUGIN_ROOT}/lib/demo-mode/storage.sh is-active

# Export current data
${CLAUDE_PLUGIN_ROOT}/lib/demo-mode/storage.sh export
```

Show the user what will be migrated:
> "Found **[X] tasks** and **[Y] wishes** in demo mode. Ready to migrate these to Tynn?"

### Step 2: Verify Tynn Connection

Check that Tynn MCP is available:
```
project()  → Should return project details
```

If not connected:
> "I can't reach Tynn yet. Run `/tynn setup` first to connect your account."

### Step 3: Get Target Context

Ask where to put the migrated items:
```
next()                    → Get active version/story
find(a: "version")        → List available versions
find(a: "story")          → List available stories
```

> "Where should I put these tasks?
> 1. **Active story**: s[X] — [title]
> 2. **New story**: Create a fresh story for migrated items
> 3. **Pick a story**: Let me choose from the list"

### Step 4: Migrate Tasks

For each local task, create in Tynn:

```
create(
  a: "task",
  title: "[task title]",
  because: "[task description]",
  on: {story_id: "[target story]"},
  with: {status: "[mapped status]"}
)
```

**Status mapping:**
| Demo Mode | Tynn |
|-----------|------|
| backlog | backlog |
| doing | backlog (will need to start) |
| qa | backlog (will need workflow) |
| done | backlog (mark as done after) |

Note: Tynn enforces workflow, so we create in backlog then transition.

### Step 5: Migrate Wishes

For each local wish, create in Tynn:

```
iwish(
  this: "[wish title]",
  had: "[description]"        # for enhancements
  # or didnt/needs/explain/secure/remove based on type
)
```

**Type mapping:**
| Demo Type | iwish Field |
|-----------|-------------|
| enhancement | had |
| fix | didnt (with when if available) |
| chore | needs |
| docs | explain |
| security | secure |
| deprecation | remove |

### Step 6: Clean Up

After successful migration:

> "Migration complete!
> - **[X] tasks** created in story s[Y]
> - **[Z] wishes** captured
>
> Want me to remove the local demo files? (`.tynn/` and `TYNN.md`)"

If yes, remove:
```bash
rm -rf .tynn TYNN.md
```

If no:
> "Keeping local files as backup. You can delete them manually when ready."

## Error Handling

**Partial failure:**
> "Migrated [X] of [Y] items. These failed:
> - [item]: [error reason]
>
> Want me to retry the failed items?"

**Connection lost:**
> "Lost connection to Tynn. [X] items already migrated, [Y] remaining.
> Run `/tynn sync` again to continue."

## Persona

Be encouraging about the upgrade:
- "Welcome to the big leagues!"
- "Your local work is safe — just leveling it up."
- "Nice! Now your team can see this too."
