# Claude Config

Global Claude Code configuration repository - custom slash commands, agents, and thinking sessions synced across machines.

## Structure

```
claude-config/
├── CLAUDE.md           # Global instructions (imported by ~/.claude/CLAUDE.md)
├── commands/           # Custom slash commands (symlinked to ~/.claude/commands)
│   ├── domain-lookup.md    # Generate & check domain availability
│   ├── readme-update.md    # Analyze codebase & update README
│   ├── think-new.md        # Start new thinking session
│   ├── think-resume.md     # Resume saved session
│   └── think-save.md       # Save current conversation
├── agents/             # Specialized AI agents
│   ├── code-reviewer.md    # Code review agent
│   ├── codebase-analyst.md       # Codebase analysis agent
│   └── documentation-analyst.md  # Documentation analysis agent
├── thoughts/           # Saved thinking/research sessions
│   └── business/
│       ├── ideas/
│       │   ├── 1_discover/      # Initial exploration
│       │   ├── 2_explore_deeper/# Deep-dive research
│       │   └── 3_pursue/        # Ready to build
│       └── research/
└── context/            # Additional context files
```

## Commands

| Command | Description |
|---------|-------------|
| `/think-new` | Start a categorized thinking/brainstorming session |
| `/think-resume` | Resume a previously saved thinking session |
| `/think-save` | Save current conversation to markdown with metadata |
| `/domain-lookup` | Generate made-up words and check domain availability |
| `/readme-update` | Analyze codebase and generate/update README.md |

## Agents

| Agent | Tools | Purpose |
|-------|-------|---------|
| `codebase-analyst` | Read, Grep, Glob, Bash, LSP | Deep-scan and understand entire codebases |
| `documentation-analyst` | WebFetch, WebSearch, Read, Write | Deep-scan and understand documentation from URLs |
| `code-reviewer` | Read, Grep, Glob, Bash | Review code for quality, security, best practices |

## How It Works

1. **Auto-sync**: Pulls from GitHub daily via `~/dotfiles/zsh/zshrc.conf`
2. **Global context**: `~/.claude/CLAUDE.md` imports this repo's `CLAUDE.md` using `@path` syntax
3. **Slash commands**: `~/.claude/commands` symlinks to this repo's `commands/`
4. **Agents**: Invoked automatically by Claude Code when specialized tasks match their descriptions

## Setup

1. Clone this repo to `~/workspace/claude-config`
2. Add to `~/.claude/CLAUDE.md`:
   ```markdown
   @~/workspace/claude-config/CLAUDE.md
   ```
3. Symlink commands:
   ```bash
   ln -s ~/workspace/claude-config/commands ~/.claude/commands
   ```

## Adding Content

- **Instructions**: Edit `CLAUDE.md` with global preferences
- **Slash commands**: Add `.md` files to `commands/` with frontmatter:
  ```yaml
  ---
  description: Brief description for command list
  ---
  ```
- **Agents**: Add `.md` files to `agents/` with frontmatter:
  ```yaml
  ---
  name: agent-name
  description: When to use this agent
  tools: Tool1, Tool2, Tool3
  ---
  ```
- **Context files**: Add to `context/` and import with `@~/workspace/claude-config/context/filename.md`

## Thinking Sessions

The thinking system uses a staged idea pipeline:

| Stage | Path | Purpose |
|-------|------|---------|
| Discovery | `thoughts/*/ideas/1_discover/` | Broad exploration of many ideas |
| Deep Dive | `thoughts/*/ideas/2_explore_deeper/` | Detailed research on promising ideas |
| Pursue | `thoughts/*/ideas/3_pursue/` | Validated ideas ready to build |
