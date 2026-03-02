#!/bin/bash
# Push commits to remote with force-push protection
# Usage: push-changes.sh [--force]
#   --force: Use --force-with-lease (for amended commits)

set -e

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "ERROR: Not in a git repository"
    exit 1
fi

BRANCH=$(git branch --show-current 2>/dev/null)
if [[ -z "$BRANCH" ]]; then
    echo "ERROR: Not on any branch (detached HEAD?)"
    exit 1
fi

FORCE=""
if [[ "$1" == "--force" ]]; then
    if [[ "$BRANCH" == "main" || "$BRANCH" == "master" ]]; then
        echo "ERROR: Refusing to force push to '$BRANCH'. This is a protected branch."
        exit 1
    fi
    FORCE="--force-with-lease"
    echo "Using --force-with-lease (safe force push)"
fi

# Check for upstream
UPSTREAM=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo "")

echo "=== PRE-PUSH CHECK ==="
echo "Branch: $BRANCH"

if [[ -n "$UPSTREAM" ]]; then
    UNPUSHED=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo "0")
    echo "Upstream: $UPSTREAM"
    echo "Commits to push: $UNPUSHED"
    echo ""
    echo "--- Commits ---"
    git log --oneline @{u}..HEAD
    echo ""

    if [[ "$UNPUSHED" -eq 0 && -z "$FORCE" ]]; then
        echo "Nothing to push — already up to date."
        exit 0
    fi

    echo "=== PUSHING ==="
    git push $FORCE
else
    echo "Upstream: (none configured)"
    echo ""
    echo "=== PUSHING (setting upstream) ==="
    git push -u origin "$BRANCH"
fi

echo ""
echo "=== PUSH COMPLETE ==="
git log --oneline -1
echo "Remote is up to date."
