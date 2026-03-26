---
name: commit-and-push
description: Analyze uncommitted changes, create a commit, and push to remote. Use when the user wants to commit and push.
disable-model-invocation: true
allowed-tools: Bash(bash *), Bash(git *), Read, Edit
---

# Commit and Push

Analyze uncommitted changes, create a commit, and push to remote.

## Scripts

This skill includes helper scripts in `~/.claude/skills/commit-and-push/scripts/`:

| Script | Purpose |
|--------|---------|
| `analyze-changes.sh` | Full repo analysis: status, unpushed commits, diffs, recent commits |
| `stage-files.sh [files\|--all]` | Stage files with sensitive file warnings |
| `create-commit.sh <msg> [--amend]` | Create commit or amend previous |

## Steps

### Phase 1: Analyze Repository State

1. Run the analysis script **from the repo root**:
   ```bash
   bash -c 'cd "$(git rev-parse --show-toplevel)" && bash ~/.claude/skills/commit-and-push/scripts/analyze-changes.sh'
   ```

   This outputs:
   - Git status
   - Unpushed commits count and list
   - Staged changes (diff --cached)
   - Unstaged changes (diff)
   - Untracked files
   - Recent commits (for style reference)
   - README existence check

### Phase 2: Handle Unpushed Commits

2. If there are unpushed commits, ask the user:
   - **Squash**: Merge new changes into existing commit(s) using `--amend`
   - **Stack**: Add a new commit on top
   - **Other**: Let user specify

### Phase 3: Review and Summarize

3. Summarize the changes for the user:
   - What files changed
   - What the changes do
   - Suggested commit message

4. If README.md exists, check if changes affect documented content:
   - New features need documenting
   - Changed commands/structure
   - Removed functionality
   - Update README if needed

### Phase 4: Stage and Commit

5. Stage files:
   ```bash
   bash ~/.claude/skills/commit-and-push/scripts/stage-files.sh --all
   ```
   Or stage specific files:
   ```bash
   bash ~/.claude/skills/commit-and-push/scripts/stage-files.sh file1.js file2.js
   ```

6. Create commit:
   ```bash
   bash ~/.claude/skills/commit-and-push/scripts/create-commit.sh "commit message here"
   ```
   Or amend previous commit (for squash):
   ```bash
   bash ~/.claude/skills/commit-and-push/scripts/create-commit.sh "updated message" --amend
   ```

### Phase 5: Push

7. Push the commit(s):
   ```bash
   git push
   ```
   If no upstream is configured:
   ```bash
   git push -u origin $(git branch --show-current)
   ```
   If the commit was amended (squash), **ask the user for confirmation first**, then:
   ```bash
   git push --force-with-lease
   ```

## Rules

- Continue to the next phase automatically if the current phase completes without errors
- NEVER include "Co-Authored-By" lines in commits
- NEVER force push to `main` or `master`
- Always ask the user for confirmation before force pushing
- When squashing, use `--amend` to combine changes into the previous commit
- Keep commit messages short and focused on the "why"
- Use conventional commit style if the repo uses it
- Only update README when changes meaningfully affect documented content
- Do not add to README for minor fixes, refactors, or internal changes
- The stage-files.sh script warns about sensitive files (.env, .pem, .key, etc.)
