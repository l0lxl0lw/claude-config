# Commit Local Changes

Analyze uncommitted changes and create a commit.

## Steps

1. Run `git status` to see current state
2. Run `git diff` for unstaged changes
3. Run `git diff --cached` for staged changes
4. Run `git log --oneline -5` to match existing commit style
5. Summarize changes to the user
6. Stage all relevant files with `git add`
7. Create commit with a concise message

## Rules

- NEVER include "Co-Authored-By" lines
- NEVER run `git push` - user pushes manually
- Keep commit messages short and focused on the "why"
- Use conventional commit style if the repo uses it
