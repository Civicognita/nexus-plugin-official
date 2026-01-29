#!/usr/bin/env bash
set -euo pipefail

# Tynn Demo Mode Storage
# Manages local .tynn/ JSON files and TYNN.md markdown sync
#
# Usage:
#   storage.sh init                          - Initialize demo mode storage
#   storage.sh add-task "title" "desc"       - Add a task
#   storage.sh add-wish "title" "type" "desc" - Add a wish
#   storage.sh add-version "title" "number" "desc" - Add a version
#   storage.sh add-story "title" "desc"      - Add a story
#   storage.sh add-feature "title" "desc"    - Add a feature
#   storage.sh list-tasks                    - List all tasks as JSON
#   storage.sh list-wishes                   - List all wishes as JSON
#   storage.sh list-versions                 - List all versions as JSON
#   storage.sh list-stories                  - List all stories as JSON
#   storage.sh list-features                 - List all features as JSON
#   storage.sh update-task ID STATUS         - Update task status
#   storage.sh transition ID STATUS          - Generic status transition
#   storage.sh summary                       - Counts and active items
#   storage.sh session-log "message"         - Append to session log
#   storage.sh sync-markdown                 - Regenerate TYNN.md from JSON
#   storage.sh export                        - Export data for migration
#   storage.sh is-active                     - Check if demo mode is enabled

TYNN_DIR=".tynn"
TASKS_FILE="$TYNN_DIR/tasks.json"
WISHES_FILE="$TYNN_DIR/wishes.json"
VERSIONS_FILE="$TYNN_DIR/versions.json"
STORIES_FILE="$TYNN_DIR/stories.json"
FEATURES_FILE="$TYNN_DIR/features.json"
CONFIG_FILE="$TYNN_DIR/config.json"
SESSION_LOG="$TYNN_DIR/session.log"
MARKDOWN_FILE="TYNN.md"

# ─────────────────────────────────────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────────────────────────────────────

generate_id() {
    echo "local-$(date +%s)-$RANDOM"
}

timestamp() {
    date -u +"%Y-%m-%dT%H:%M:%SZ"
}

ensure_file() {
    local file="$1"
    local key="$2"
    if [[ ! -f "$file" ]]; then
        echo "{\"$key\":[]}" > "$file"
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# Initialize
# ─────────────────────────────────────────────────────────────────────────────

init() {
    mkdir -p "$TYNN_DIR"

    ensure_file "$TASKS_FILE" "tasks"
    ensure_file "$WISHES_FILE" "wishes"
    ensure_file "$VERSIONS_FILE" "versions"
    ensure_file "$STORIES_FILE" "stories"
    ensure_file "$FEATURES_FILE" "features"

    if [[ ! -f "$CONFIG_FILE" ]]; then
        cat > "$CONFIG_FILE" <<EOF
{
    "mode": "demo",
    "initialized_at": "$(timestamp)",
    "version": "0.3.0"
}
EOF
    fi

    touch "$SESSION_LOG"

    sync_markdown
    echo "✅ Demo mode initialized"
}

# ─────────────────────────────────────────────────────────────────────────────
# Add entities
# ─────────────────────────────────────────────────────────────────────────────

add_task() {
    local title="$1"
    local description="${2:-}"
    local id=$(generate_id)
    local ts=$(timestamp)

    local task=$(cat <<EOF
{
    "id": "$id",
    "title": "$title",
    "description": "$description",
    "status": "backlog",
    "created_at": "$ts",
    "updated_at": "$ts"
}
EOF
)

    local data=$(cat "$TASKS_FILE")
    echo "$data" | jq --argjson item "$task" '.tasks += [$item]' > "$TASKS_FILE"

    sync_markdown
    echo "$id"
}

add_wish() {
    local title="$1"
    local type="$2"
    local description="$3"
    local id=$(generate_id)
    local ts=$(timestamp)

    local wish=$(cat <<EOF
{
    "id": "$id",
    "title": "$title",
    "type": "$type",
    "description": "$description",
    "created_at": "$ts"
}
EOF
)

    local data=$(cat "$WISHES_FILE")
    echo "$data" | jq --argjson item "$wish" '.wishes += [$item]' > "$WISHES_FILE"

    sync_markdown
    echo "$id"
}

add_version() {
    local title="$1"
    local number="${2:-}"
    local description="${3:-}"
    local id=$(generate_id)
    local ts=$(timestamp)

    local version=$(cat <<EOF
{
    "id": "$id",
    "title": "$title",
    "number": "$number",
    "description": "$description",
    "status": "draft",
    "created_at": "$ts",
    "updated_at": "$ts"
}
EOF
)

    local data=$(cat "$VERSIONS_FILE")
    echo "$data" | jq --argjson item "$version" '.versions += [$item]' > "$VERSIONS_FILE"

    sync_markdown
    echo "$id"
}

add_story() {
    local title="$1"
    local description="${2:-}"
    local id=$(generate_id)
    local ts=$(timestamp)

    local story=$(cat <<EOF
{
    "id": "$id",
    "title": "$title",
    "description": "$description",
    "status": "backlog",
    "created_at": "$ts",
    "updated_at": "$ts"
}
EOF
)

    local data=$(cat "$STORIES_FILE")
    echo "$data" | jq --argjson item "$story" '.stories += [$item]' > "$STORIES_FILE"

    sync_markdown
    echo "$id"
}

add_feature() {
    local title="$1"
    local description="${2:-}"
    local id=$(generate_id)
    local ts=$(timestamp)

    local feature=$(cat <<EOF
{
    "id": "$id",
    "title": "$title",
    "description": "$description",
    "created_at": "$ts"
}
EOF
)

    local data=$(cat "$FEATURES_FILE")
    echo "$data" | jq --argjson item "$feature" '.features += [$item]' > "$FEATURES_FILE"

    sync_markdown
    echo "$id"
}

# ─────────────────────────────────────────────────────────────────────────────
# List entities
# ─────────────────────────────────────────────────────────────────────────────

list_tasks() {
    cat "$TASKS_FILE"
}

list_wishes() {
    cat "$WISHES_FILE"
}

list_versions() {
    cat "$VERSIONS_FILE"
}

list_stories() {
    cat "$STORIES_FILE"
}

list_features() {
    cat "$FEATURES_FILE"
}

# ─────────────────────────────────────────────────────────────────────────────
# Update / Transition
# ─────────────────────────────────────────────────────────────────────────────

update_task() {
    local id="$1"
    local status="$2"
    local ts=$(timestamp)

    local data=$(cat "$TASKS_FILE")
    echo "$data" | jq --arg id "$id" --arg status "$status" --arg ts "$ts" \
        '(.tasks[] | select(.id == $id)) |= (.status = $status | .updated_at = $ts)' \
        > "$TASKS_FILE"

    sync_markdown
    echo "✅ Task $id updated to $status"
}

# Generic status transition for any entity type
transition() {
    local id="$1"
    local status="$2"
    local ts=$(timestamp)

    # Try each entity file
    local found=false

    for pair in "tasks:$TASKS_FILE" "wishes:$WISHES_FILE" "versions:$VERSIONS_FILE" "stories:$STORIES_FILE"; do
        local key="${pair%%:*}"
        local file="${pair#*:}"

        if [[ -f "$file" ]] && jq -e --arg id "$id" ".$key[] | select(.id == \$id)" "$file" > /dev/null 2>&1; then
            local data=$(cat "$file")
            echo "$data" | jq --arg id "$id" --arg status "$status" --arg ts "$ts" \
                "(.$key[] | select(.id == \$id)) |= (.status = \$status | .updated_at = \$ts)" \
                > "$file"
            found=true
            echo "✅ $id transitioned to $status"
            break
        fi
    done

    if [[ "$found" == false ]]; then
        echo "❌ Entity $id not found" >&2
        return 1
    fi

    sync_markdown
}

# ─────────────────────────────────────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────────────────────────────────────

summary() {
    local versions=0 stories=0 tasks=0 wishes=0 features=0
    local active_items=""

    if [[ -f "$VERSIONS_FILE" ]]; then
        versions=$(jq '.versions | length' "$VERSIONS_FILE")
        active_items+=$(jq -r '.versions[] | select(.status == "active") | "  📦 v\(.number) — \(.title)"' "$VERSIONS_FILE")
    fi

    if [[ -f "$STORIES_FILE" ]]; then
        stories=$(jq '.stories | length' "$STORIES_FILE")
        local in_progress
        in_progress=$(jq -r '.stories[] | select(.status == "in_progress") | "  📖 \(.title)"' "$STORIES_FILE")
        if [[ -n "$in_progress" ]]; then
            active_items+=$'\n'"$in_progress"
        fi
    fi

    if [[ -f "$TASKS_FILE" ]]; then
        tasks=$(jq '.tasks | length' "$TASKS_FILE")
        local doing
        doing=$(jq -r '.tasks[] | select(.status == "doing") | "  🔨 \(.title)"' "$TASKS_FILE")
        if [[ -n "$doing" ]]; then
            active_items+=$'\n'"$doing"
        fi
    fi

    if [[ -f "$WISHES_FILE" ]]; then
        wishes=$(jq '.wishes | length' "$WISHES_FILE")
    fi

    if [[ -f "$FEATURES_FILE" ]]; then
        features=$(jq '.features | length' "$FEATURES_FILE")
    fi

    cat <<EOF
{
    "versions": $versions,
    "stories": $stories,
    "tasks": $tasks,
    "wishes": $wishes,
    "features": $features,
    "total": $(( versions + stories + tasks + wishes + features ))
}
EOF

    if [[ -n "$active_items" ]]; then
        echo ""
        echo "Active items:"
        echo "$active_items"
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# Session Log
# ─────────────────────────────────────────────────────────────────────────────

session_log() {
    local message="$1"
    local ts=$(timestamp)
    echo "[$ts] $message" >> "$SESSION_LOG"
    echo "✅ Logged"
}

# ─────────────────────────────────────────────────────────────────────────────
# Sync JSON to Markdown
# ─────────────────────────────────────────────────────────────────────────────

sync_markdown() {
    local versions=$(cat "$VERSIONS_FILE" 2>/dev/null || echo '{"versions":[]}')
    local stories=$(cat "$STORIES_FILE" 2>/dev/null || echo '{"stories":[]}')
    local tasks=$(cat "$TASKS_FILE" 2>/dev/null || echo '{"tasks":[]}')
    local wishes=$(cat "$WISHES_FILE" 2>/dev/null || echo '{"wishes":[]}')
    local features=$(cat "$FEATURES_FILE" 2>/dev/null || echo '{"features":[]}')

    cat > "$MARKDOWN_FILE" <<EOF
# Tynn (Demo Mode)

Local project tracking. Run \`/tynn:sync\` to migrate to Tynn.

---

## Versions

EOF

    echo "$versions" | jq -r '.versions[] | "### v\(.number) — \(.title) (\(.status))\n\(if .description != "" then .description else "" end)\n"' >> "$MARKDOWN_FILE"

    cat >> "$MARKDOWN_FILE" <<EOF
---

## Stories

### In Progress
EOF

    echo "$stories" | jq -r '.stories[] | select(.status == "in_progress") | "- [ ] **\(.title)**\(if .description != "" then " — \(.description)" else "" end)"' >> "$MARKDOWN_FILE"

    cat >> "$MARKDOWN_FILE" <<EOF

### Backlog
EOF

    echo "$stories" | jq -r '.stories[] | select(.status == "backlog") | "- [ ] \(.title)\(if .description != "" then " — \(.description)" else "" end)"' >> "$MARKDOWN_FILE"

    cat >> "$MARKDOWN_FILE" <<EOF

### Done
EOF

    echo "$stories" | jq -r '.stories[] | select(.status == "done") | "- [x] ~~\(.title)~~"' >> "$MARKDOWN_FILE"

    cat >> "$MARKDOWN_FILE" <<EOF

---

## Tasks

### Doing
EOF

    echo "$tasks" | jq -r '.tasks[] | select(.status == "doing") | "- [ ] **\(.title)**\(if .description != "" then " — \(.description)" else "" end)"' >> "$MARKDOWN_FILE"

    cat >> "$MARKDOWN_FILE" <<EOF

### QA
EOF

    echo "$tasks" | jq -r '.tasks[] | select(.status == "qa") | "- [ ] **\(.title)**\(if .description != "" then " — \(.description)" else "" end)"' >> "$MARKDOWN_FILE"

    cat >> "$MARKDOWN_FILE" <<EOF

### Backlog
EOF

    echo "$tasks" | jq -r '.tasks[] | select(.status == "backlog") | "- [ ] \(.title)\(if .description != "" then " — \(.description)" else "" end)"' >> "$MARKDOWN_FILE"

    cat >> "$MARKDOWN_FILE" <<EOF

### Done
EOF

    echo "$tasks" | jq -r '.tasks[] | select(.status == "done") | "- [x] ~~\(.title)~~"' >> "$MARKDOWN_FILE"

    cat >> "$MARKDOWN_FILE" <<EOF

---

## Features

EOF

    echo "$features" | jq -r '.features[] | "- **\(.title)**\(if .description != "" then " — \(.description)" else "" end)"' >> "$MARKDOWN_FILE"

    cat >> "$MARKDOWN_FILE" <<EOF

---

## Wishes

EOF

    echo "$wishes" | jq -r '.wishes[] | "- **\(.type | ascii_upcase)**: \(.title) — \(.description)"' >> "$MARKDOWN_FILE"

    cat >> "$MARKDOWN_FILE" <<EOF

---

*Generated by Tynn Demo Mode*
EOF
}

# ─────────────────────────────────────────────────────────────────────────────
# Export
# ─────────────────────────────────────────────────────────────────────────────

export_data() {
    cat <<EOF
{
    "versions": $(cat "$VERSIONS_FILE" 2>/dev/null | jq '.versions' || echo '[]'),
    "stories": $(cat "$STORIES_FILE" 2>/dev/null | jq '.stories' || echo '[]'),
    "tasks": $(cat "$TASKS_FILE" 2>/dev/null | jq '.tasks' || echo '[]'),
    "wishes": $(cat "$WISHES_FILE" 2>/dev/null | jq '.wishes' || echo '[]'),
    "features": $(cat "$FEATURES_FILE" 2>/dev/null | jq '.features' || echo '[]'),
    "exported_at": "$(timestamp)"
}
EOF
}

# ─────────────────────────────────────────────────────────────────────────────
# Status check
# ─────────────────────────────────────────────────────────────────────────────

is_active() {
    [[ -d "$TYNN_DIR" ]] && echo "true" || echo "false"
}

# ─────────────────────────────────────────────────────────────────────────────
# Command dispatcher
# ─────────────────────────────────────────────────────────────────────────────

case "${1:-}" in
    init)
        init
        ;;
    add-task)
        add_task "${2:-Untitled}" "${3:-}"
        ;;
    add-wish)
        add_wish "${2:-Untitled}" "${3:-enhancement}" "${4:-}"
        ;;
    add-version)
        add_version "${2:-Untitled}" "${3:-}" "${4:-}"
        ;;
    add-story)
        add_story "${2:-Untitled}" "${3:-}"
        ;;
    add-feature)
        add_feature "${2:-Untitled}" "${2:-}"
        ;;
    list-tasks)
        list_tasks
        ;;
    list-wishes)
        list_wishes
        ;;
    list-versions)
        list_versions
        ;;
    list-stories)
        list_stories
        ;;
    list-features)
        list_features
        ;;
    update-task)
        update_task "$2" "$3"
        ;;
    transition)
        transition "$2" "$3"
        ;;
    summary)
        summary
        ;;
    session-log)
        session_log "${2:-}"
        ;;
    sync-markdown)
        sync_markdown
        ;;
    export)
        export_data
        ;;
    is-active)
        is_active
        ;;
    *)
        echo "Usage: storage.sh {init|add-task|add-wish|add-version|add-story|add-feature|list-tasks|list-wishes|list-versions|list-stories|list-features|update-task|transition|summary|session-log|sync-markdown|export|is-active}"
        exit 1
        ;;
esac
