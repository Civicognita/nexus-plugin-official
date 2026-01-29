# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Project Overview

Tynn Claude Tooling — Claude Code plugins and marketplace integrations for Tynn.ai project management.

## Repository Structure

```
tynn-claude-tooling/
├── marketplace/
│   └── tynn-plugin/          # Main Tynn plugin for Claude marketplace
│       ├── .claude-plugin/
│       │   └── plugin.json   # Plugin manifest (v0.3.0)
│       ├── skills/           # Slash commands (/tynn:plan, /tynn:ship, etc.)
│       │   ├── plan/         # Planning mode
│       │   ├── ship/         # Execution mode
│       │   ├── capture/      # Quick idea capture
│       │   ├── triage/       # Hotfix mode
│       │   ├── secure/       # Security review
│       │   ├── setup/        # Connection wizard
│       │   ├── sync/         # Demo→Tynn migration
│       │   ├── status/       # Project pulse
│       │   ├── handoff/      # Session continuity
│       │   └── onboard/      # Contributor orientation
│       ├── hooks/            # Event hooks (session-start, post-commit)
│       ├── agents/           # Proactive agents (tynn-assistant)
│       ├── lib/demo-mode/    # Demo mode storage utilities
│       └── examples/         # Workflow examples
└── docs/
    └── plans/                # Design documents
```

## Plugin Development

### Testing the Plugin Locally

1. Symlink or copy `marketplace/tynn-plugin` to your Claude Code plugins directory
2. Ensure `TYNN_API_KEY` is set in your environment or Claude Code settings
3. Restart Claude Code to load the plugin

### Skills (v0.3.0)

**Mode Skills** — core work modes with guardrails

| Skill | Command | Purpose |
|-------|---------|---------|
| plan | `/tynn:plan` | Planning mode — create versions, stories, tasks, features |
| ship | `/tynn:ship` | Execution mode — implement code and update status |
| capture | `/tynn:capture` | Quick idea/bug/chore capture |
| triage | `/tynn:triage` | Hotfix mode — urgent VIP work (connected only) |
| secure | `/tynn:secure` | Security review — systematic audit with findings |

**Lifecycle Skills** — setup and migration

| Skill | Command | Purpose |
|-------|---------|---------|
| setup | `/tynn:setup` | Configure Tynn connection or demo mode |
| sync | `/tynn:sync` | Migrate demo mode data to Tynn account |

**Context Skills** — awareness and continuity

| Skill | Command | Purpose |
|-------|---------|---------|
| status | `/tynn:status` | Project pulse — active work, git state, next steps |
| handoff | `/tynn:handoff` | Session continuity — document progress for later |
| onboard | `/tynn:onboard` | Contributor orientation — project walkthrough |

### Hooks

| Hook | Event | Purpose |
|------|-------|---------|
| session-start | SessionStart | Auto-load project context |
| post-commit | PostToolUse | Auto-update tasks from commit messages |

### Agents

| Agent | Purpose |
|-------|---------|
| tynn-assistant | Proactive workflow guidance, scope creep detection |

## Design Principles

1. **Action-verb naming** — Skills use action verbs (plan, ship, capture) to avoid collision with MCP server prompts
2. **Colon namespace** — All commands use `/tynn:<skill>` syntax for plugin namespace clarity
3. **Preserve persona** — The Tynn fox personality stays consistent across all skills
4. **Respect guardrails** — Plan mode can't write code; Ship mode can't create work
5. **Demo mode fallback** — Works locally without Tynn account (except triage, which requires connection)
6. **Keep momentum** — Every response should end with a next action
7. **Entry flow pattern** — All mode skills detect connected vs. demo mode automatically

## Implementation Phases

- [x] Phase 1: Core plugin (manifest, setup/think/build/wish skills, session-start hook)
- [x] Phase 2: Demo mode (local storage, TYNN.md sync, migration)
- [x] Phase 3: Advanced (VIP, Audit skills, post-commit hook, tynn-assistant agent)
- [x] Phase 4: Marketplace (packaging, docs, polish)
- [x] Phase 5: Skill redesign v0.3.0 (10 skills, colon syntax, context skills, extended demo storage)
