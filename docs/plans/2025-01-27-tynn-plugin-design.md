# Tynn Claude Code Plugin Design

## Overview

A Claude Code marketplace plugin that integrates Tynn project management into the AI coding workflow. Targets both existing Tynn customers and new users discovering Tynn through Claude Code.

## Package Contents

```
tynn-plugin/
├── plugin.json                 # Plugin manifest
├── .mcp.json                   # MCP server config (Tynn API or local demo)
├── skills/
│   ├── setup.md                # /tynn setup - onboarding wizard
│   ├── think.md                # /tynn think - planning mode
│   ├── build.md                # /tynn build - execution mode
│   ├── vip.md                  # /tynn vip - hotfix mode
│   ├── audit.md                # /tynn audit - security review
│   ├── wish.md                 # /tynn wish - quick idea capture
│   └── sync.md                 # /tynn sync - migrate demo → Tynn
├── hooks/
│   ├── session-start.md        # Auto-load project context
│   └── post-commit.md          # Auto-update task status
├── agents/
│   └── tynn-assistant.md       # Proactive workflow guidance
└── lib/
    └── demo-mode/
        ├── server.js           # Mini MCP server for local storage
        └── storage.js          # JSON + markdown sync logic
```

## Operating Modes

### Connected Mode
Full Tynn MCP integration with live sync when API key is configured.

### Demo Mode
Local storage for users without Tynn accounts:
- **Storage**: `.tynn/` directory (JSON) + `TYNN.md` (human-readable markdown)
- **Features**: Wishes + tasks with basic status (backlog/doing/done)
- **Migration**: `/tynn sync` exports to Tynn when user signs up

## Skills (Slash Commands)

### /tynn setup
Interactive onboarding wizard:
1. Detect if API key exists
2. If not, offer demo mode or guide to tynn.ai signup
3. Configure `.mcp.json` with credentials
4. Verify connection and load project context

### /tynn think
Planning mode - maps to Tynn's Think guide:
- Create versions, stories, tasks, features, domains
- Organize roadmap and break down work
- **Guardrail**: No code writing allowed
- **Persona**: Tynn fox - decisive, encouraging, pragmatic

### /tynn build
Execution mode - maps to Tynn's Build guide:
- Fetch work item before starting
- Implement code and tests
- Keep Tynn updated with status changes
- **Guardrail**: No creating new work items (use `iwish` for discoveries)
- **Persona**: Tynn fox - focused on doing, not planning

### /tynn vip
Hotfix mode - maps to Tynn's VIP guide:
- Streamlined interface for urgent work
- Manage active VIP version
- Batch task updates
- **Guardrail**: Cannot create VIP versions (UI only)

### /tynn audit
Security review mode - maps to Tynn's Audit guide:
- Comprehensive security audit
- Findings with file paths and line numbers
- Prioritized by severity (CRITICAL/HIGH/MEDIUM/LOW)
- **Guardrail**: Findings only, no code modifications

### /tynn wish
Quick idea capture using natural language:
- Enhancement: "I wish [X] had [Y]"
- Fix: "I wish [X] didn't [Y] when [Z]"
- Chore: "I wish [X] needs [Y]"
- Docs: "I wish [X] was explained"
- Security: "I wish [X] was more secure"

### /tynn sync
Demo mode migration:
- Export local `.tynn/` data to Tynn account
- Guide through signup if needed
- Map local tasks/wishes to Tynn entities

## Hooks

### SessionStart Hook
Triggers on every Claude Code session:
1. Check for API key configuration
2. If configured: call `next()` and `project()` to load context
3. If not configured: show demo mode status or setup prompt
4. Inject project context into conversation

### PostCommit Hook
Triggers after git commits:
1. Parse commit message for task references (t44, s11)
2. Auto-update referenced tasks to QA or done based on keywords
3. Add commit SHA as comment on task

## Demo Mode Storage

### .tynn/wishes.json
```json
{
  "wishes": [
    {
      "id": "local-1",
      "type": "enhancement",
      "title": "Login form",
      "description": "Support for OAuth2 providers",
      "created_at": "2025-01-27T12:00:00Z"
    }
  ]
}
```

### .tynn/tasks.json
```json
{
  "tasks": [
    {
      "id": "local-1",
      "title": "Implement login form",
      "status": "doing",
      "created_at": "2025-01-27T12:00:00Z"
    }
  ]
}
```

### TYNN.md
Human-readable markdown synced with JSON:
```markdown
# Project Tasks

## Doing
- [ ] Implement login form

## Backlog
- [ ] Add OAuth support

---

# Wishes
- **Enhancement**: Login form - Support for OAuth2 providers
```

## Authentication

API key-based authentication:
1. User signs up at tynn.ai
2. Gets API key from settings
3. Runs `/tynn setup` to configure
4. Key stored in Claude Code settings (not in repo)

## Tynn Persona

All skills use the Tynn fox persona:
- **Voice**: Clever, crisp, kinetic - doesn't linger
- **Decisive**: "Let's nail this down so you can start building."
- **Encouraging**: "That's rough — but it's progress. Keep going."
- **Playfully Stern**: "Thinking about it doesn't count. Say it out loud."
- **Pragmatic**: "That sounds like three projects. Pick one."
- **Optimistic**: "Confusion is just clarity loading."

> "Done is the engine of more." — Cult of Done Manifesto

## Implementation Phases

### Phase 1: Core Plugin
- [ ] plugin.json manifest
- [ ] Basic skills: setup, think, build, wish
- [ ] SessionStart hook for context loading
- [ ] MCP server configuration

### Phase 2: Demo Mode
- [ ] Local storage (JSON + markdown sync)
- [ ] Demo mode detection and fallback
- [ ] /tynn sync migration tool

### Phase 3: Advanced Features
- [ ] VIP and Audit skills
- [ ] PostCommit hook for auto-status
- [ ] Tynn assistant agent

### Phase 4: Marketplace
- [ ] Package for Claude marketplace
- [ ] Documentation and examples
- [ ] Onboarding flow polish
