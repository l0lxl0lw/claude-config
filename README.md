# Claude Config

Global Claude Code configuration repository - custom skills and agents synced across machines.

## Structure

```
claude-config/
├── CLAUDE.md           # Global instructions (imported by ~/.claude/CLAUDE.md)
├── skills/             # Custom skills (symlinked to ~/.claude/skills)
│   ├── commit-local-changes/    # Analyze & commit uncommitted changes
│   ├── make-resume/             # Generate tailored resume from job description
│   ├── readme/                  # Read README and execute instructions
│   ├── update-diagram/          # Scan & update diagram files
│   ├── notion/                  # Interact with Notion workspace
│   └── elevenlabs/              # Generate speech, audio, music & manage AI agents
├── agents/             # Specialized AI agent personas
│   ├── tech-stack-researcher.md
│   ├── system-architect.md
│   ├── backend-architect.md
│   ├── frontend-architect.md
│   ├── requirements-analyst.md
│   ├── refactoring-expert.md
│   ├── performance-engineer.md
│   ├── security-engineer.md
│   ├── technical-writer.md
│   ├── learning-guide.md
│   ├── deep-research-agent.md
│   └── notion.md
├── prompts/            # System prompts collection (reference)
│   ├── Anthropic/      # Claude prompts
│   ├── Google/         # Gemini prompts
│   ├── OpenAI/         # GPT/o-series prompts
│   ├── Perplexity/
│   ├── Proton/
│   ├── xAI/            # Grok prompts
│   └── Misc/
└── context/            # Additional context files
```

## Skills

| Skill | Description | Model Invocable |
|-------|-------------|-----------------|
| `/commit-local-changes` | Analyze uncommitted changes and create a commit | No |
| `/make-resume` | Generate tailored resume and cover letter from job description | Yes |
| `/readme` | Read README in current directory and execute instructions | Yes |
| `/update-diagram` | Scan codebase and update existing diagram files | Yes |
| `/notion` | Search, read, create, and manage Notion workspace content | Yes |
| `/elevenlabs` | Generate speech, sound effects, music, clone voices, transcribe audio, manage AI agents | Yes |

## Agents

Specialized AI agent personas that provide focused expertise for different development tasks.

### Architecture & Planning

| Agent | Purpose |
|-------|---------|
| `tech-stack-researcher` | Technology choice recommendations with trade-offs analysis |
| `system-architect` | Scalable system architecture design |
| `backend-architect` | Backend systems with data integrity and security focus |
| `frontend-architect` | Performant, accessible UI architecture |
| `requirements-analyst` | Transform ideas into concrete specifications |

### Code Quality

| Agent | Purpose |
|-------|---------|
| `refactoring-expert` | Systematic refactoring and clean code practices |
| `performance-engineer` | Measurement-driven optimization |
| `security-engineer` | Vulnerability identification and security standards |

### Documentation & Research

| Agent | Purpose |
|-------|---------|
| `technical-writer` | Clear, comprehensive documentation |
| `learning-guide` | Teaching programming concepts progressively |
| `deep-research-agent` | Comprehensive research with adaptive strategies |

### Integrations

| Agent | Purpose |
|-------|---------|
| `notion` | Search and interact with Notion workspace via MCP |

## How It Works

1. **Auto-sync**: Pulls from GitHub daily via `~/dotfiles/zsh/zshrc.conf`
2. **Global context**: `~/.claude/CLAUDE.md` imports this repo's `CLAUDE.md` using `@path` syntax
3. **Skills**: `~/.claude/skills` symlinks to this repo's `skills/`
4. **Agents**: Invoked automatically by Claude Code when specialized tasks match their descriptions

## Setup

1. Clone this repo to `~/workspace/claude-config`
2. Add to `~/.claude/CLAUDE.md`:
   ```markdown
   @~/workspace/claude-config/CLAUDE.md
   ```
3. Symlink skills:
   ```bash
   ln -s ~/workspace/claude-config/skills ~/.claude/skills
   ```

## Adding Content

- **Instructions**: Edit `CLAUDE.md` with global preferences
- **Skills**: Add a directory to `skills/<skill-name>/SKILL.md` with frontmatter:
  ```yaml
  ---
  name: skill-name
  description: What this skill does and when to use it
  disable-model-invocation: true  # Optional: prevents Claude from auto-invoking
  allowed-tools: Read, Grep       # Optional: restrict available tools
  ---

  Your skill instructions here...
  ```
- **Agents**: Add `.md` files to `agents/` with frontmatter:
  ```yaml
  ---
  name: agent-name
  description: When to use this agent
  category: analysis|quality|planning
  ---
  ```
- **Context files**: Add to `context/` and import with `@~/workspace/claude-config/context/filename.md`

## Useful References

| Resource | Description |
|----------|-------------|
| [Claude Usage Tracker](https://github.com/hamed-elfayome/Claude-Usage-Tracker) | Native macOS menu bar app to monitor Claude AI usage limits in real-time — tracks session, weekly, and Opus-specific consumption |
