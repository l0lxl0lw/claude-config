# Claude Config

Global Claude Code configuration repository - custom skills, agents, and thinking sessions synced across machines.

## Structure

```
claude-config/
├── CLAUDE.md           # Global instructions (imported by ~/.claude/CLAUDE.md)
├── skills/             # Custom skills (symlinked to ~/.claude/skills)
│   ├── commit-local-changes/    # Analyze & commit uncommitted changes
│   ├── make-resume/             # Generate tailored resume from job description
│   └── update-diagram/          # Scan & update diagram files
├── agents/             # Specialized AI agents (organized by hierarchy: Task → Worker → Manager → Director → Executive → Chief)
│   ├── 1_task/        # Task-level agents (atomic operations, no subagents)
│   │   ├── file/       # File-based tasks
│   │   │   ├── code/   # Code-related tasks
│   │   │   │   ├── codebase-analyst.md
│   │   │   │   ├── code-review-resolver.md
│   │   │   │   ├── git-handler.md
│   │   │   │   └── principal-code-reviewer.md
│   │   │   ├── text/   # Text processing tasks
│   │   │   │   └── text-summarizer.md
│   │   │   └── video/  # Video processing tasks
│   │   │       ├── video-frame-extractor.md
│   │   │       └── video-transcriber.md
│   │   └── url/        # URL-based tasks
│   │       ├── docs/   # Documentation fetching tasks
│   │       │   ├── doc-fetcher.md
│   │       │   └── docs-tree-crawler.md
│   │       └── video/  # Video URL processing tasks
│   │           ├── youtube-thumbnail-downloader.md
│   │           ├── youtube-transcript-fetcher.md
│   │           └── youtube-video-downloader.md
│   ├── 2_worker/       # Worker-level agents (call tasks)
│   │   └── file/
│   │       └── code/
│   │           └── extended-planner.md  # Calls codebase-analyst task
│   ├── 3_manager/      # Manager-level agents (coordinate workers/tasks)
│   │   ├── file/
│   │   │   └── code/
│   │   │       └── feature-developer.md  # Coordinates extended-planner worker + tasks
│   │   └── url/
│   │       ├── docs/
│   │       │   └── docs-orchestrator.md  # Coordinates doc-fetcher + docs-tree-crawler tasks
│   │       └── video/
│   │           └── youtube-video-orchestrator.md  # Coordinates multiple video tasks
│   ├── 4_director/     # Director-level agents (coordinate managers) - empty, reserved for future use
│   ├── 5_executive/    # Executive-level agents (coordinate directors) - empty, reserved for future use
│   └── 6_chief/        # Chief-level agents (coordinate executives) - empty, reserved for future use
├── thoughts/           # Saved thinking/research sessions
│   └── business/
│       ├── ideas/
│       │   ├── 1_discover/      # Initial exploration
│       │   ├── 2_explore_deeper/# Deep-dive research
│       │   └── 3_pursue/        # Ready to build
│       └── research/
└── context/            # Additional context files
```

## Skills

| Skill | Description | Model Invocable |
|-------|-------------|-----------------|
| `/commit-local-changes` | Analyze uncommitted changes and create a commit | No |
| `/make-resume` | Generate tailored resume and cover letter from job description | No |
| `/update-diagram` | Scan codebase and update existing diagram files | Yes |

## Agents

Agents are organized by hierarchy level: **Task → Worker → Manager → Director → Executive → Chief**, then by domain (file/url) and type (code/video/docs/text). Folders are numbered (1_task, 2_worker, etc.) to ensure proper ordering in file browsers.

### 1. Task-Level Agents (Atomic Operations)

Tasks are single-purpose agents that perform atomic operations without calling other agents.

#### File Tasks

**Code (`task/file/code/`)**
| Agent | Model | Purpose |
|-------|-------|---------|
| `codebase-analyst` | opus | Deep-scan and understand entire codebases |
| `code-review-resolver` | opus | Resolve code review feedback |
| `git-handler` | sonnet | Handle git operations |
| `principal-code-reviewer` | opus | Thorough code review of git changes |

**Text (`task/file/text/`)**
| Agent | Model | Purpose |
|-------|-------|---------|
| `text-summarizer` | sonnet | Summarize large text documents into structured format |

**Video (`task/file/video/`)**
| Agent | Model | Purpose |
|-------|-------|---------|
| `video-frame-extractor` | haiku | Extract frames from video files (1 fps) |
| `video-transcriber` | haiku | Transcribe video/audio files using Whisper |

#### URL Tasks

**Documentation (`task/url/docs/`)**
| Agent | Model | Purpose |
|-------|-------|---------|
| `doc-fetcher` | sonnet | Fetch and answer questions from documentation URLs |
| `docs-tree-crawler` | sonnet | Extract navigation structures and build topic trees |

**Video (`task/url/video/`)**
| Agent | Model | Purpose |
|-------|-------|---------|
| `youtube-thumbnail-downloader` | haiku | Download YouTube video thumbnails |
| `youtube-transcript-fetcher` | haiku | Fetch transcripts from YouTube API |
| `youtube-video-downloader` | haiku | Download YouTube videos at 240p quality |

### 2. Worker-Level Agents (Call Tasks)

Workers coordinate multiple tasks in sequence or parallel.

**Code (`worker/file/code/`)**
| Agent | Model | Purpose |
|-------|-------|---------|
| `extended-planner` | opus | Extended planning for complex features (calls `codebase-analyst`) |

### 3. Manager-Level Agents (Coordinate Workers/Tasks)

Managers coordinate multiple workers and/or tasks to complete complex workflows.

### 4. Director-Level Agents (Coordinate Managers)

Directors coordinate multiple managers to handle enterprise-level workflows. Currently empty, reserved for future use.

### 5. Executive-Level Agents (Coordinate Directors)

Executives coordinate multiple directors to handle organization-wide workflows. Currently empty, reserved for future use.

### 6. Chief-Level Agents (Coordinate Executives)

Chief agents coordinate multiple executives to handle strategic, organization-wide initiatives. Currently empty, reserved for future use.

**Code (`manager/file/code/`)**
| Agent | Model | Purpose |
|-------|-------|---------|
| `feature-developer` | opus | Complete feature development workflow (coordinates `extended-planner` worker + code review/git tasks) |

**Documentation (`manager/url/docs/`)**
| Agent | Model | Purpose |
|-------|-------|---------|
| `docs-orchestrator` | opus | Coordinate doc-fetcher and docs-tree-crawler for shallow tree fetching |

**Video (`manager/url/video/`)**
| Agent | Model | Purpose |
|-------|-------|---------|
| `youtube-video-orchestrator` | sonnet | Complete YouTube video processing pipeline (coordinates download, frame extraction, transcript fetching, thumbnail download, and summarization) |

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
  tools: Tool1, Tool2, Tool3
  ---
  ```
- **Context files**: Add to `context/` and import with `@~/workspace/claude-config/context/filename.md`
