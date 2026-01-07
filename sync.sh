#!/bin/bash
# Claude Config Sync Script
# Syncs ~/.claude-config with GitHub repository

CLAUDE_CONFIG_DIR="$HOME/.claude-config"

claude_config_sync() {
    if [[ ! -d "$CLAUDE_CONFIG_DIR/.git" ]]; then
        return 0
    fi

    cd "$CLAUDE_CONFIG_DIR" || return 1

    # Fetch latest changes silently
    git fetch origin main --quiet 2>/dev/null

    # Check if we have local changes
    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
        # Auto-commit local changes
        git add -A
        git commit -m "Auto-sync: $(date '+%Y-%m-%d %H:%M:%S')" --quiet 2>/dev/null
    fi

    # Pull remote changes (rebase to keep history clean)
    git pull --rebase --quiet origin main 2>/dev/null

    # Push any local commits
    git push --quiet origin main 2>/dev/null

    cd - > /dev/null || return 1
}

# Run sync in background to not block shell startup
(claude_config_sync &) 2>/dev/null
