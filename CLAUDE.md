# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

Global Claude Code configuration — custom skills, agent personas, hooks, and a system prompts reference collection. Synced across machines via the [dotfiles](https://github.com/l0lxl0lw/dotfiles) repo, which clones/pulls this repo and symlinks its contents into `~/.claude/`.

## Architecture

```
claude-config/
├── CLAUDE.md              # Global instructions (imported by ~/.claude/CLAUDE.md via @path)
├── skills/                # Custom skills (symlinked to ~/.claude/skills)
│   └── <skill-name>/SKILL.md   # Each skill has frontmatter + markdown instructions
├── agents/                # Agent personas (.md files with frontmatter)
├── hooks/                 # Shell hooks (e.g., statusline.sh for context window progress bar)
├── prompts/               # Read-only reference collection of system prompts (Anthropic, Google, OpenAI, etc.)
└── context/               # Additional context files importable via @path
```

**Integration flow**: `~/dotfiles` → pulls this repo → symlinks `skills/` to `~/.claude/skills` → `~/.claude/CLAUDE.md` imports this file via `@~/workspace/claude-config/CLAUDE.md`.

## Adding Content

### Skills

Create `skills/<skill-name>/SKILL.md` with YAML frontmatter:

```yaml
---
name: skill-name
description: What this skill does and when to use it
disable-model-invocation: true  # Optional: user-only invocation
allowed-tools: Bash, Read       # Optional: restrict tool access
---
```

Skills can include helper scripts in `skills/<skill-name>/scripts/`.

### Agents

Create `agents/<agent-name>.md` with YAML frontmatter:

```yaml
---
name: agent-name
description: When to use this agent
category: engineering|analysis|quality|planning
---
```

### Context Files

Add to `context/` and import with `@~/workspace/claude-config/context/filename.md`.

## Conventions

- Skill names use kebab-case directories; agent names use kebab-case `.md` files
- The `prompts/` directory is a reference archive — organized by provider (Anthropic, Google, OpenAI, xAI, Perplexity, Misc). Read-only, not loaded by Claude Code
- The commit-local-changes skill enforces: no "Co-Authored-By" lines, no `git push` (user pushes manually), conventional commit style when the repo uses it
- The commit-and-push skill extends commit-local-changes with a push step; no force push to main/master
- `.env` and `.google-credentials.json` are gitignored

# currentDate
Today's date is 2026-03-01.
