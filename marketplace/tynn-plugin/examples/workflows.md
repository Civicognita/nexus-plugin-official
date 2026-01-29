# Tynn Workflow Examples

Real-world examples of using Tynn with Claude Code.

## Example 1: Starting a New Feature

### Scenario
You want to add user authentication to your app.

### Workflow

**1. Plan the work**
```
/tynn:plan
```

> "I need to add user authentication with email/password and OAuth."

Tynn helps you break it down:
```
Story: User Authentication
├── Task: Set up auth database schema
├── Task: Implement email/password login
├── Task: Add OAuth providers (Google, GitHub)
├── Task: Create login/register UI
└── Task: Write auth middleware
```

**2. Start building**
```
/tynn:ship
```

> "What's my first task?"

Tynn shows: `t101 - Set up auth database schema`

**3. Work on the task**

Write your migrations, models, etc. When done:

```bash
git commit -m "Add user and session tables closes t101"
```

Tynn automatically moves t101 to QA.

**4. Continue to next task**

Tynn suggests: `t102 - Implement email/password login`

---

## Example 2: Handling a Bug Report

### Scenario
User reports: "Login fails when password has special characters"

### Workflow

**1. Capture the bug**
```
/tynn:capture login doesn't accept special characters in password
```

Tynn creates a wish:
> Fix: Login — doesn't accept special characters in password

**2. Check if it's urgent**

If urgent, use triage mode:
```
/tynn:triage
```

**3. Fix and track**
```
/tynn:ship
```

Work on the fix, commit:
```bash
git commit -m "Escape special chars in password validation fixes t150"
```

---

## Example 3: Security Audit

### Scenario
Before launch, you need a security review.

### Workflow

**1. Start the audit**
```
/tynn:secure
```

**2. Tynn systematically reviews:**
- Authentication mechanisms
- Token lifecycle
- Authorization checks
- File upload handling
- Third-party integrations

**3. Get findings**

```markdown
### [HIGH] SQL Injection in Search

**Impact**: Attacker can read/modify database

**Evidence**: src/controllers/SearchController.php:45

**Fix**: Use parameterized queries

**Verify**: Run sqlmap against /api/search
```

**4. Capture as tasks**

> "Want me to create tasks for these findings?"

Tynn creates:
```
Story: Security Audit Remediation
├── Task: [CRITICAL] Fix SQL injection in search
├── Task: [HIGH] Add rate limiting to auth endpoints
├── Task: [MEDIUM] Implement token rotation
└── Task: [LOW] Add security headers
```

---

## Example 4: Demo Mode Workflow

### Scenario
You're evaluating Tynn without an account.

### Workflow

**1. Start demo mode**
```
/tynn:setup
```
> "use demo mode"

**2. Create tasks locally**
```
/tynn:plan
```
> "I need to build a todo app"

Tasks saved to `.tynn/tasks.json` and visible in `TYNN.md`.

**3. Work and update**
```
/tynn:ship
```

Update task status — changes sync to `TYNN.md`.

**4. Ready to upgrade?**
```
/tynn:sync
```

Migrates your local tasks and wishes to your new Tynn account.

---

## Example 5: Scope Creep Prevention

### Scenario
You're working on t101 (auth schema) but notice the API could use refactoring.

### Workflow

**1. Tynn assistant notices**

> [Tynn] You're editing files outside t101's scope.
> → Capture as wish to stay focused?

**2. Capture without losing context**
```
/tynn:capture API controller needs refactoring for consistency
```

**3. Continue original task**

The refactoring is captured for later. You stay focused on auth schema.

---

## Example 6: Session Handoff

### Scenario
You finished some tasks, need to wrap up for the day.

### Workflow

**1. Document your session**
```
/tynn:handoff
```

Tynn generates a structured handoff:
```
## Session Handoff

### Done
- t101 — Auth database schema
- t102 — Email/password login

### In Progress
- t103 — OAuth providers (branch: feature/oauth, 60% done)

### Blockers
- None

### Next Steps
1. Finish Google OAuth integration in t103
2. Start t104 — Login/register UI
3. Review the auth middleware approach
```

**2. Teammate picks up**

Next day, they run:
```
/tynn:status
```

Tynn shows the full project pulse with handoff context.

---

## Quick Reference

| Want to... | Command |
|------------|---------|
| Plan new work | `/tynn:plan` |
| Start coding | `/tynn:ship` |
| Capture idea | `/tynn:capture <description>` |
| Handle hotfix | `/tynn:triage` |
| Security review | `/tynn:secure` |
| Project pulse | `/tynn:status` |
| Wrap up session | `/tynn:handoff` |
| New to project | `/tynn:onboard` |
| Migrate to Tynn | `/tynn:sync` |
