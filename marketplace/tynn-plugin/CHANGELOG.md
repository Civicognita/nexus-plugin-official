# Changelog

All notable changes to the Tynn plugin for Claude Code.

## [0.2.0] - 2025-01-28

### Added
- **VIP Mode** (`/tynn vip`) — Hotfix mode for urgent unscoped work
  - Batch task operations
  - Transition validation
  - Streamlined VIP version management
- **Audit Mode** (`/tynn audit`) — Security review mode
  - Systematic audit process
  - Severity-ranked findings (CRITICAL/HIGH/MEDIUM/LOW)
  - Integration for tracking remediation
- **Post-commit hook** — Auto-update tasks from commit messages
  - Detects task references (t123, #123, task-123)
  - Keywords: closes/fixes → QA, wip/start → doing
- **Tynn Assistant agent** — Proactive workflow guidance
  - Completed work detection
  - Scope creep warnings
  - Focus encouragement

## [0.1.0] - 2025-01-28

### Added
- **Core plugin structure**
  - Plugin manifest with MCP server configuration
  - Tynn fox persona across all skills
- **Setup skill** (`/tynn setup`) — Onboarding wizard
  - API key configuration
  - Demo mode initialization
- **Think skill** (`/tynn think`) — Planning mode
  - Create versions, stories, tasks, features, domains
  - Guardrail: no code writing
- **Build skill** (`/tynn build`) — Execution mode
  - Implement and track progress
  - Guardrail: no creating new work
- **Wish skill** (`/tynn wish`) — Quick idea capture
  - Enhancement, fix, chore, docs, security, deprecation types
- **Sync skill** (`/tynn sync`) — Demo mode migration
  - Export local data to Tynn account
- **Session-start hook** — Auto-load project context
- **Demo mode** — Local storage without Tynn account
  - `.tynn/` JSON storage
  - `TYNN.md` human-readable markdown
  - storage.sh bash utilities
