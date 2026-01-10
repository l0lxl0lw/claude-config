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
├── agents/             # Specialized AI agents (organized by input type)
│   ├── file/           # Agents that work with local files
│   │   ├── code/       # Code-related agents
│   │   │   ├── codebase-analyst.md
│   │   │   ├── code-review-resolver.md
│   │   │   ├── extended-planner.md
│   │   │   ├── feature-developer.md
│   │   │   ├── git-handler.md
│   │   │   └── principal-code-reviewer.md
│   │   ├── text/       # Text processing agents (reserved)
│   │   └── video/      # Video processing agents
│   │       ├── video-frame-extractor.md
│   │       └── video-transcriber.md
│   ├── orchestrator/   # Agents that coordinate other agents
│   │   ├── docs-orchestrator.md
│   │   └── youtube-video-orchestrator.md
│   └── url/            # Agents that work with URLs/web content
│       ├── documentations/  # Documentation fetching agents
│       │   ├── doc-fetcher.md
│       │   └── docs-tree-crawler.md
│       └── video/      # Video URL processing agents
│           └── youtube-video-downloader.md
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

Agents are organized by input type: `file/` (local files), `url/` (web content), and `orchestrator/` (coordination).

### File Processing Agents

#### Code (`file/code/`)
| Agent | Model | Purpose |
|-------|-------|---------|
| `codebase-analyst` | opus | Deep-scan and understand entire codebases |
| `code-review-resolver` | - | Resolve code review feedback |
| `extended-planner` | - | Extended planning for complex features |
| `feature-developer` | - | Develop features end-to-end |
| `git-handler` | - | Handle git operations |
| `principal-code-reviewer` | opus | Thorough code review of git changes |

#### Video (`file/video/`)
| Agent | Model | Purpose |
|-------|-------|---------|
| `video-frame-extractor` | haiku | Extract frames from video files (1 fps) |
| `video-transcriber` | haiku | Transcribe video/audio files using Whisper |

### URL Processing Agents

#### Documentation (`url/documentations/`)
| Agent | Model | Purpose |
|-------|-------|---------|
| `doc-fetcher` | sonnet | Fetch and answer questions from documentation URLs |
| `docs-tree-crawler` | sonnet | Extract navigation structures and build topic trees |

#### Video (`url/video/`)
| Agent | Model | Purpose |
|-------|-------|---------|
| `youtube-video-downloader` | haiku | Download YouTube videos at 240p quality |

### Orchestrator Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| `docs-orchestrator` | opus | Coordinate doc-fetcher and docs-tree-crawler for shallow tree fetching |
| `youtube-video-orchestrator` | sonnet | Coordinate download, frame extraction, transcription, and summarization pipeline |

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
