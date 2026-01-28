# Tynn Plugin for Claude Code

> "Done is the engine of more." — Cult of Done Manifesto

Plan, build, and track your work with **Tynn** — the clever fox who keeps you moving.

## What is Tynn?

Tynn is a project management system designed for AI-assisted development. This plugin brings Tynn directly into Claude Code, letting you:

- **Plan work** without leaving your editor
- **Track progress** automatically as you code
- **Capture ideas** without breaking flow
- **Stay focused** with proactive guidance

## Quick Start

### 1. Install the Plugin

Add this plugin to your Claude Code configuration.

### 2. Connect to Tynn

```
/tynn setup
```

This will guide you through:
- Connecting your Tynn account (API key)
- Or starting in **demo mode** (no account needed)

### 3. Start Working

```
/tynn think    # Plan and organize work
/tynn build    # Execute tasks and track progress
/tynn wish     # Capture ideas quickly
```

## Commands

| Command | Purpose |
|---------|---------|
| `/tynn setup` | Configure connection or start demo mode |
| `/tynn think` | Planning mode — create versions, stories, tasks |
| `/tynn build` | Execution mode — implement and update status |
| `/tynn wish` | Quick capture — ideas, bugs, chores |
| `/tynn sync` | Migrate demo data to Tynn account |
| `/tynn vip` | Hotfix mode — urgent unscoped work |
| `/tynn audit` | Security review — systematic audit |

## Demo Mode

Don't have a Tynn account? No problem! Demo mode lets you:

- Track tasks locally in `.tynn/` directory
- See your work in human-readable `TYNN.md`
- Migrate to Tynn when you're ready

```
/tynn setup
> "use demo mode"
```

## Automatic Features

### Session Context
When you start Claude Code, Tynn automatically loads your project context — active version, current story, and prioritized tasks.

### Commit Sync
Reference tasks in your commit messages and Tynn updates automatically:

```bash
git commit -m "Fix login validation t123"     # Starts task
git commit -m "Implement auth closes t124"    # Moves to QA
```

### Assistant Nudges
The Tynn assistant watches for:
- Completed work (suggests marking done)
- Scope creep (suggests capturing as wish)
- Long silences (offers to help if blocked)

## The Tynn Workflow

```
┌─────────────────────────────────────────────────────────────┐
│                        THINK                                 │
│   Plan work: versions → stories → tasks                     │
│   /tynn think                                               │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                        BUILD                                 │
│   Execute: backlog → doing → qa → done                      │
│   /tynn build                                               │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                        WISH                                  │
│   Capture discoveries without losing focus                  │
│   /tynn wish "login should support OAuth"                   │
└─────────────────────────────────────────────────────────────┘
```

## Modes

### Think Mode (Planning)
Create and organize work. **Cannot write code** — keeps you in planning mindset.

### Build Mode (Execution)
Implement tasks and track progress. **Cannot create new work** — keeps you focused.

### VIP Mode (Hotfixes)
Handle urgent work that can't wait. Streamlined interface for speed.

### Audit Mode (Security)
Systematic security review with severity-ranked findings.

## Configuration

### Environment Variables

| Variable | Purpose |
|----------|---------|
| `TYNN_API_KEY` | Your Tynn API key |
| `TYNN_API_URL` | Custom API URL (optional) |

### Settings

```json
{
  "tynn.autoCommitSync": true,
  "tynn.assistant.enabled": true
}
```

## Requirements

- Claude Code
- Tynn account (or use demo mode)
- `jq` for demo mode (JSON processing)

## Links

- [Tynn.ai](https://tynn.ai) — Sign up for Tynn
- [Documentation](https://docs.tynn.ai) — Full Tynn docs
- [GitHub](https://github.com/Renaissance-Analytics/tynn-claude-tooling) — Source code

## License

MIT
