# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Project Overview

Tynn Claude Tooling — Claude Code plugins and marketplace integrations for Tynn.ai project management.

## Repository Structure

```
tynn-claude-tooling/
├── marketplace/
│   └── tynn-plugin/          # Main Tynn plugin for Claude marketplace
│       ├── plugin.json       # Plugin manifest
│       ├── skills/           # Slash commands (/tynn think, /tynn build, etc.)
│       ├── hooks/            # Event hooks (session-start, post-commit)
│       └── agents/           # Proactive agents (future)
└── docs/
    └── plans/                # Design documents
```

## Plugin Development

### Testing the Plugin Locally

1. Symlink or copy `marketplace/tynn-plugin` to your Claude Code plugins directory
2. Ensure `TYNN_API_KEY` is set in your environment or Claude Code settings
3. Restart Claude Code to load the plugin

### Skills

| Skill | Command | Purpose |
|-------|---------|---------|
| setup | `/tynn setup` | Configure Tynn connection or demo mode |
| think | `/tynn think` | Planning mode — create/organize work |
| build | `/tynn build` | Execution mode — implement and track |
| wish | `/tynn wish` | Quick idea/bug/chore capture |
| sync | `/tynn sync` | Migrate demo mode data to Tynn |
| vip | `/tynn vip` | Hotfix mode — urgent unscoped work |
| audit | `/tynn audit` | Security review — findings and recommendations |

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

1. **Map to Tynn guides** — Skills mirror Tynn MCP resources (think-guide, build-guide)
2. **Preserve persona** — The Tynn fox personality stays consistent
3. **Respect guardrails** — Think mode can't write code; Build mode can't create work
4. **Demo mode fallback** — Works locally without Tynn account
5. **Keep momentum** — Every response should end with a next action

## Implementation Phases

- [x] Phase 1: Core plugin (manifest, setup/think/build/wish skills, session-start hook)
- [x] Phase 2: Demo mode (local storage, TYNN.md sync, migration)
- [x] Phase 3: Advanced (VIP, Audit skills, post-commit hook, tynn-assistant agent)
- [ ] Phase 4: Marketplace (packaging, docs, polish)
