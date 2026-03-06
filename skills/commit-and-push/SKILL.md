---
name: commit-and-push
description: Run commit-local-changes, then push to remote. Use instead of commit-local-changes when the user wants to push.
disable-model-invocation: true
allowed-tools: Bash(bash *), Bash(git *), Read, Edit
---

# Commit and Push

Run the commit-local-changes skill, then push to remote.

## Steps

1. Execute the **commit-local-changes** skill (all phases: analyze, handle unpushed, review, stage, commit).

2. Push the commit(s):
   ```bash
   git push
   ```
   If no upstream is configured:
   ```bash
   git push -u origin <branch>
   ```
   If the commit was amended (squash), **ask the user for confirmation first**, then:
   ```bash
   git push --force-with-lease
   ```

## Rules

- All commit-local-changes rules apply
- NEVER force push to `main` or `master`
- Always ask the user for confirmation before force pushing
