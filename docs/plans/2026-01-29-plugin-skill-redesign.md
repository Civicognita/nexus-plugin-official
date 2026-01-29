# Plugin Skill Redesign

**Date:** 2026-01-29
**Status:** Approved

## Problem

The Tynn plugin has 7 skills (`think`, `build`, `vip`, `audit`, `wish`, `setup`, `sync`). Five of them (`think`, `build`, `vip`, `audit`, `wish`) collide with Tynn MCP server prompts that provide the same functionality. The plugin needs skills that complement the MCP layer using unique Claude Code capabilities, while still providing a full experience in demo/offline mode.

## Decisions

- **Full demo mode**: Plugin works standalone without Tynn MCP server. Skills route to MCP when connected, local `.tynn/` storage when not.
- **Action verb naming**: Skills use action verbs that don't collide with MCP prompt names.
- **10 skills total**: 5 mode skills + 2 lifecycle skills + 3 context skills.

## Skill Architecture

### Tier 1 — Mode Skills

Map to MCP prompts but use distinct names. Work in both connected and demo mode.

| Skill | Replaces MCP Prompt | Action |
|-------|---------------------|--------|
| `plan` | think | Organize roadmap, versions, stories, tasks. No code. |
| `ship` | build | Execute work, implement code, update status. No new work items. |
| `capture` | iWish | Quick idea/bug/chore capture. |
| `triage` | vip | Urgent hotfix management. |
| `secure` | audit | Security review with findings and recommendations. |

### Tier 2 — Lifecycle Skills

Unique to the plugin. Handle setup and migration.

| Skill | Action |
|-------|--------|
| `setup` | Configure Tynn connection or init demo mode. |
| `sync` | Migrate demo data to Tynn account. |

### Tier 3 — Context Skills

Leverage Claude Code's local awareness. Things the MCP server can't know.

| Skill | Action |
|-------|--------|
| `status` | Rich project overview: next() + git state + session context. |
| `handoff` | Session continuity notes for later pickup. |
| `onboard` | Project walkthrough for new contributors. |

## Mode Skill Behavior

### Entry Flow

1. Detect backend: check if Tynn MCP tools respond. Set `mode: connected` or `mode: demo`.
2. Load persona: Tynn fox personality, guardrails, mode-specific rules.
3. Load context: `next()` / `project()` if connected, or read `.tynn/` files if demo.
4. Execute mode-specific workflow.

### Connected Mode

The skill loads the corresponding MCP resource guide (e.g., `plan` loads `tynn-think-guide`) and orchestrates MCP tools directly. The skill is a thin wrapper that sets persona + guardrails, then delegates to MCP.

### Demo Mode

The skill uses `lib/demo-mode/storage.sh` for local CRUD operations on `.tynn/` JSON files. Same persona and workflow, stored locally. Markdown sync to `TYNN.md` happens automatically.

### Guardrails Per Mode

- **plan** — Can create/update work items. Cannot write code or modify repo files.
- **ship** — Can write code and update status. Cannot create new versions/stories/tasks. Discovers new work -> suggests `capture`.
- **capture** — Lightweight. Takes input, creates wish, done. No code, no planning.
- **triage** — Focused on active VIP version. Fix it, close it, move on.
- **secure** — Read-only codebase analysis. Findings only, no code modifications.

The persona voice stays identical across connected and demo modes.

## Context Skills Detail

### status

Quick project pulse. Combines:
- Tynn data: `next()` for active version, top story, prioritized tasks, stats
- Git state: current branch, uncommitted changes, recent commits
- Session awareness: what was worked on this session, any blockers hit
- Output: concise dashboard-style summary. Always ends with "Here's what to do next."
- Demo mode: reads `.tynn/` data + git state, same format

### handoff

Session continuity for async work. Generates:
- What was accomplished this session (tasks started/completed, code written)
- Current state of in-progress work (branch, uncommitted changes, open tasks)
- Blockers or decisions needed
- Suggested next steps
- Output: writes to comment on active story/task (connected) or appends to `TYNN.md` (demo)

### onboard

New contributor orientation. Walks through:
- Project vision and strategic themes (from `project()`)
- Tech stack and architecture (from `project(info: "technologies")`)
- Data model overview (from `schema(action: "get")`)
- Current version scope and active work (from `next()`)
- Key conventions from `ai_guidance`
- Demo mode: reads local context, focuses on repo structure and git history

All three use the fox persona in an informational tone.

## Demo Mode Storage

### Extended Storage Commands

New commands added to `lib/demo-mode/storage.sh`:
- `add-version`, `add-story`, `add-feature` — mirror Tynn entity hierarchy
- `transition <id> <status>` — generic status change with timestamp
- `summary` — returns counts and active items across all types
- `session-log <message>` — append to `.tynn/session.log`

### Storage Structure

```
.tynn/
├── versions.json
├── stories.json
├── tasks.json
├── wishes.json
├── features.json
├── session.log
└── config.json
```

`TYNN.md` sync renders a human-readable view of all entities.

## File Structure

```
marketplace/tynn-plugin/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   ├── plan/SKILL.md
│   ├── ship/SKILL.md
│   ├── capture/SKILL.md
│   ├── triage/SKILL.md
│   ├── secure/SKILL.md
│   ├── setup/SKILL.md
│   ├── sync/SKILL.md
│   ├── status/SKILL.md
│   ├── handoff/SKILL.md
│   └── onboard/SKILL.md
├── hooks/
│   └── hooks.json
├── agents/
│   └── tynn-assistant.md
└── lib/
    └── demo-mode/
        └── storage.sh
```

## Skill Invocation

```
/tynn:plan       — "Let's organize what's next."
/tynn:ship       — "Time to build."
/tynn:capture    — "Quick, before you forget."
/tynn:triage     — "What's on fire?"
/tynn:secure     — "Let's lock this down."
/tynn:setup      — "First time? Let's connect."
/tynn:sync       — "Ready to go live."
/tynn:status     — "Where are we?"
/tynn:handoff    — "Wrapping up for now."
/tynn:onboard    — "Welcome. Let me show you around."
```
