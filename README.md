# Claude Config

Global Claude-related context and commands, synced across machines.

## Structure

```
claude-config/
├── CLAUDE.md      # Global instructions (imported by ~/.claude/CLAUDE.md)
├── commands/      # Custom slash commands (symlinked to ~/.claude/commands)
└── context/       # Additional context files (import with @~/workspace/claude-config/context/file.md)
```

## How It Works

1. **Auto-sync**: Pulls from GitHub daily via `~/dotfiles/zsh/zshrc.conf`
2. **Global context**: `~/.claude/CLAUDE.md` imports this repo's `CLAUDE.md`
3. **Slash commands**: `~/.claude/commands` symlinks to this repo's `commands/`

## Adding Content

- **Instructions**: Edit `CLAUDE.md` with your global preferences
- **Slash commands**: Add `.md` files to `commands/` (e.g., `commands/review.md` becomes `/review`)
- **Context files**: Add to `context/` and import in CLAUDE.md with `@~/workspace/claude-config/context/filename.md`
