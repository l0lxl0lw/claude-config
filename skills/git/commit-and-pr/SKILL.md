---
name: commit-and-pr
description: Commit changes on a feature branch and create a GitHub pull request with a well-summarized description. Use when the user wants to commit and open a PR.
disable-model-invocation: true
allowed-tools: Bash(bash *), Bash(git *), Bash(gh *), Read, Edit
---

# Commit and PR

Commit local changes on a feature branch and create a GitHub pull request.

## Scripts

This skill includes helper scripts in `~/.claude/skills/commit-and-pr/scripts/`:

| Script | Purpose |
|--------|---------|
| `analyze-changes.sh` | Full repo analysis: status, branch info, diffs, recent commits, PR template check |
| `stage-files.sh [files\|--all]` | Stage files with sensitive file warnings |
| `create-commit.sh <msg> [--amend]` | Create commit or amend previous |

## Steps

### Phase 1: Analyze Repository State

1. Run the analysis script **from the repo root**:
   ```bash
   bash -c 'cd "$(git rev-parse --show-toplevel)" && bash ~/.claude/skills/commit-and-pr/scripts/analyze-changes.sh'
   ```

   This outputs:
   - Git status and branch info
   - Default branch detection
   - Staged/unstaged changes and diffs
   - Untracked files
   - Recent commits (for style reference)
   - Commits ahead of default branch (if on feature branch)
   - README and PR template existence

### Phase 2: Ensure Feature Branch

2. If currently on the default branch (`main`/`master`):
   - Generate a short, descriptive branch name based on the changes (kebab-case, e.g., `add-auth-middleware`)
   - Propose the branch name to the user and ask for confirmation or alternative
   - Create and switch to the new branch:
     ```bash
     git checkout -b <branch-name>
     ```

3. If already on a feature branch, continue as-is.

### Phase 3: Review and Summarize

4. Summarize the changes for the user:
   - What files changed
   - What the changes do
   - Suggested commit message

5. If README.md exists, check if changes affect documented content:
   - New features need documenting
   - Changed commands/structure
   - Removed functionality
   - Update README if needed

### Phase 4: Stage and Commit

6. Stage files:
   ```bash
   bash ~/.claude/skills/commit-and-pr/scripts/stage-files.sh --all
   ```
   Or stage specific files:
   ```bash
   bash ~/.claude/skills/commit-and-pr/scripts/stage-files.sh file1.js file2.js
   ```

7. Create commit:
   ```bash
   bash ~/.claude/skills/commit-and-pr/scripts/create-commit.sh "commit message here"
   ```

### Phase 5: Prepare PR

8. Gather the full diff between the base branch and current branch:
   ```bash
   git log --oneline $(git merge-base <base> HEAD)..HEAD
   git diff <base>...HEAD --stat
   ```

9. Write a PR title and description:
   - **Title**: Short (under 70 chars), descriptive of the change purpose
   - **Body**: Use this structure (or the repo's PR template if one exists):
     ```
     ## Summary
     <1-3 bullet points explaining what changed and why>

     ## Changes
     <Grouped list of specific changes — e.g., by file or area>

     ## Test plan
     <How to verify these changes work — manual steps, test commands, etc.>
     ```

### Phase 6: Confirm, Push, and Create PR

10. Show the user:
    - The branch name
    - The PR title
    - The full PR description
    - Ask for confirmation before proceeding

11. Once confirmed, push and create the PR:
    ```bash
    git push -u origin $(git branch --show-current)
    ```
    ```bash
    gh pr create --title "<title>" --body "$(cat <<'EOF'
    ## Summary
    ...

    ## Changes
    ...

    ## Test plan
    ...
    EOF
    )"
    ```

12. Output the PR URL so the user can see it.

## Rules

- NEVER push or create the PR without asking the user for confirmation first
- NEVER include "Co-Authored-By" lines in commits
- NEVER force push to `main` or `master`
- NEVER create a PR from the default branch — always use a feature branch
- Use conventional commit style if the repo uses it
- The PR description must accurately reflect ALL commits being included, not just the latest one
- If the diff is large, group changes by area/component in the Changes section
- Keep the Summary section focused on the "why" — motivation and impact
- Keep the Changes section focused on the "what" — specific modifications
- The stage-files.sh script warns about sensitive files (.env, .pem, .key, etc.)
- Only update README when changes meaningfully affect documented content
- Do not add draft flag unless the user asks for a draft PR
- NEVER include "Generated with Claude Code" or any AI attribution lines in the PR body
