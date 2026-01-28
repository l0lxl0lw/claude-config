---
name: commit-local-changes
description: Analyze uncommitted changes and create a commit, with options to squash or stack on existing unpushed commits.
disable-model-invocation: true
allowed-tools: Bash(bash *), Bash(git *), Read, Edit
---

# Commit Local Changes

Analyze uncommitted changes and create a commit.

## Scripts

This skill includes helper scripts in `~/.claude/skills/commit-local-changes/scripts/`:

| Script | Purpose |
|--------|---------|
| `analyze-changes.sh` | Full repo analysis: status, unpushed, diffs, recent commits |
| `stage-files.sh [files\|--all]` | Stage files with sensitive file warnings |
| `create-commit.sh <msg> [--amend]` | Create commit or amend previous |

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

## Rules

- Continue to the next phase automatically if the current phase completes without errors
- NEVER include "Co-Authored-By" lines
- NEVER run `git push` - user pushes manually
- When squashing, use `--amend` to combine changes into the previous commit
- Keep commit messages short and focused on the "why"
- Use conventional commit style if the repo uses it
- Only update README when changes meaningfully affect documented content
- Do not add to README for minor fixes, refactors, or internal changes
- The stage-files.sh script warns about sensitive files (.env, .pem, .key, etc.)
