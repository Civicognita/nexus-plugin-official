# Tynn Plugin for Claude Code

> "Done is the engine of more." — Cult of Done Manifesto

Plan, ship, and track your work with **Tynn** — the clever fox who keeps you moving.

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
/tynn:setup
```

This will guide you through:
- Connecting your Tynn account (API key)
- Or starting in **demo mode** (no account needed)

### 3. Start Working

```
/tynn:plan       # Organize roadmap and work items
/tynn:ship       # Execute tasks and ship code
/tynn:capture    # Capture ideas quickly
```

## Commands

### Mode Skills

| Command | Purpose |
|---------|---------|
| `/tynn:plan` | Planning mode — create versions, stories, tasks |
| `/tynn:ship` | Execution mode — implement and update status |
| `/tynn:capture` | Quick capture — ideas, bugs, chores |
| `/tynn:triage` | Hotfix mode — urgent VIP work |
| `/tynn:secure` | Security review — systematic audit |

### Lifecycle Skills

| Command | Purpose |
|---------|---------|
| `/tynn:setup` | Configure connection or start demo mode |
| `/tynn:sync` | Migrate demo data to Tynn account |

### Context Skills

| Command | Purpose |
|---------|---------|
| `/tynn:status` | Project pulse — active work, git state, next steps |
| `/tynn:handoff` | Session continuity — document progress for later |
| `/tynn:onboard` | Contributor orientation — project walkthrough |

## Demo Mode

Don't have a Tynn account? No problem! Demo mode lets you:

- Track versions, stories, tasks, wishes, and features locally in `.tynn/`
- See your work in human-readable `TYNN.md`
- Migrate to Tynn when you're ready

```
/tynn:setup
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
│                        PLAN                                  │
│   Organize work: versions → stories → tasks                 │
│   /tynn:plan                                                │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                        SHIP                                  │
│   Execute: backlog → doing → qa → done                      │
│   /tynn:ship                                                │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                       CAPTURE                                │
│   Catch discoveries without losing focus                    │
│   /tynn:capture "login should support OAuth"                │
└─────────────────────────────────────────────────────────────┘
```

## Modes

### Plan Mode (Planning)
Create and organize work. **Cannot write code** — keeps you in planning mindset.

### Ship Mode (Execution)
Implement tasks and track progress. **Cannot create new work** — keeps you focused.

### Triage Mode (Hotfixes)
Handle urgent VIP work that can't wait. Streamlined interface for speed.

### Secure Mode (Security)
Systematic security review with severity-ranked findings.

## Configuration

### Environment Variables

| Variable | Purpose |
|----------|---------|
| `TYNN_API_KEY` | Your Tynn API key |
| `TYNN_API_URL` | Custom API URL (optional) |

## Requirements

- Claude Code
- Tynn account (or use demo mode)
- `jq` for demo mode (JSON processing)

## Links

- [Tynn.ai](https://tynn.ai) — Sign up for Tynn
- [Documentation](https://docs.tynn.ai) — Full Tynn docs
- [GitHub](https://github.com/Civicognita/nexus-plugin-official) — Source code

## License

MIT
