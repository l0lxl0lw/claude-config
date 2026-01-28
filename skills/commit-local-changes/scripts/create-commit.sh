#!/bin/bash
# Create a git commit with the given message
# Usage: create-commit.sh <message> [--amend]

set -e

if [[ -z "$1" ]]; then
    echo "Usage: $0 <message> [--amend]"
    echo ""
    echo "Options:"
    echo "  --amend    Amend the previous commit instead of creating new"
    exit 1
fi

MESSAGE="$1"
AMEND=""

if [[ "$2" == "--amend" ]]; then
    AMEND="--amend"
    echo "Amending previous commit..."
else
    echo "Creating new commit..."
fi

# Check if there are staged changes
if git diff --cached --quiet; then
    echo "ERROR: No staged changes to commit"
    echo ""
    echo "Stage files first with:"
    echo "  git add <files>"
    echo "  or: bash ~/.claude/skills/commit-local-changes/scripts/stage-files.sh --all"
    exit 1
fi

# Create commit using heredoc for message (handles multi-line)
git commit $AMEND -m "$MESSAGE"

echo ""
echo "=== COMMIT CREATED ==="
git log --oneline -1
echo ""
echo "=== CURRENT STATUS ==="
git status --short

# Remind about push
UPSTREAM=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo "")
if [[ -n "$UPSTREAM" ]]; then
    UNPUSHED=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo "0")
    echo ""
    echo "You have $UNPUSHED unpushed commit(s). Push when ready with: git push"
fi
