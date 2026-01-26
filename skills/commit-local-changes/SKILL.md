---
name: commit-local-changes
description: Analyze uncommitted changes and create a commit, with options to squash or stack on existing unpushed commits.
disable-model-invocation: true
---

# Commit Local Changes

Analyze uncommitted changes and create a commit.

## Steps

1. Run `git status` to see current state
2. Check if there are unpushed commits ahead of the remote (look for "Your branch is ahead of")
3. If there are existing unpushed commits, ask the user:
   - **Squash**: Merge new changes into the existing commit(s) as one commit
   - **Stack**: Add a new commit on top of existing commits
   - **Other**: Let user specify what they want to do
4. Run `git diff` for unstaged changes
5. Run `git diff --cached` for staged changes
6. Run `git log --oneline -5` to match existing commit style
7. Summarize changes to the user
8. Check if README.md exists in the repository root
9. If README exists, read it and compare against the changes being committed
10. Determine if the README needs updating (e.g., new features, changed structure, updated commands, removed functionality)
11. If README update is needed, make the necessary changes to keep it accurate
12. Stage all relevant files with `git add` (including README if updated)
13. Create commit (or amend existing commit if user chose Squash)

## Rules

- NEVER include "Co-Authored-By" lines
- NEVER run `git push` - user pushes manually
- When squashing, use `git commit --amend` to combine changes into the previous commit
- Keep commit messages short and focused on the "why"
- Use conventional commit style if the repo uses it
- Only update README when changes meaningfully affect documented content
- Do not add to README for minor fixes, refactors, or internal changes
