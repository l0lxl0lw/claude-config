---
name: commit-and-push
description: Analyze uncommitted changes, create a commit, and push to remote. Like commit-local-changes but includes git push.
disable-model-invocation: true
allowed-tools: Bash(bash *), Bash(git *), Read, Edit
---

# Commit and Push

Analyze uncommitted changes, create a commit, and push to remote.

## Scripts

This skill reuses helper scripts from `~/.claude/skills/commit-local-changes/scripts/` and adds its own:

| Script | Source | Purpose |
|--------|--------|---------|
| `analyze-changes.sh` | commit-local-changes | Full repo analysis: status, unpushed, diffs, recent commits |
| `stage-files.sh [files\|--all]` | commit-local-changes | Stage files with sensitive file warnings |
| `create-commit.sh <msg> [--amend]` | commit-local-changes | Create commit or amend previous |
| `push-changes.sh [--force]` | **this skill** | Push to remote with force-push protection |

## Steps

### Phase 1: Analyze Repository State

1. Run the analysis script to get full picture:
   ```bash
   bash ~/.claude/skills/commit-local-changes/scripts/analyze-changes.sh
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
   bash ~/.claude/skills/commit-local-changes/scripts/stage-files.sh --all
   ```
   Or stage specific files:
   ```bash
   bash ~/.claude/skills/commit-local-changes/scripts/stage-files.sh file1.js file2.js
   ```

6. Create commit:
   ```bash
   bash ~/.claude/skills/commit-local-changes/scripts/create-commit.sh "commit message here"
   ```
   Or amend previous commit (for squash):
   ```bash
   bash ~/.claude/skills/commit-local-changes/scripts/create-commit.sh "updated message" --amend
   ```

### Phase 5: Push to Remote

7. Push the commit(s):
   ```bash
   bash ~/.claude/skills/commit-and-push/scripts/push-changes.sh
   ```
   If the commit was amended (squash), use force-with-lease — **ask the user for confirmation first**:
   ```bash
   bash ~/.claude/skills/commit-and-push/scripts/push-changes.sh --force
   ```

## Rules

- Continue to the next phase automatically if the current phase completes without errors
- NEVER include "Co-Authored-By" lines
- Keep commit messages short and focused on the "why"
- Use conventional commit style if the repo uses it
- Only update README when changes meaningfully affect documented content
- Do not add to README for minor fixes, refactors, or internal changes
- The stage-files.sh script warns about sensitive files (.env, .pem, .key, etc.)
- NEVER force push to `main` or `master` — warn the user and refuse
- Always ask the user for confirmation before using `--force` (amended/squashed commits)
- If no upstream is configured, push with `-u origin <branch>` to set it up
