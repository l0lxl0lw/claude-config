# Claude Config

Global Claude Code configuration repository - custom skills and agents synced across machines.

> **Pulled by**: [`~/dotfiles`](https://github.com/l0lxl0lw/dotfiles) — the dotfiles repo clones/pulls this repo and loads its agents and skills into the shell environment.

## Structure

```
claude-config/
├── CLAUDE.md              # Global instructions (imported by ~/.claude/CLAUDE.md)
├── skills/                # Custom skills (symlinked to ~/.claude/skills)
│   ├── commit-and-push/           # Commit and push to remote
│   ├── commit-and-pr/             # Commit and create GitHub PR
│   ├── commit-local-changes/      # Analyze & commit uncommitted changes
│   ├── excalidraw-diagram-generator/  # Generate Excalidraw diagrams
│   ├── plan/                      # Strategic planning workflow
│   ├── ralph/                     # Iterative task completion loop
│   ├── ralplan/                   # Multi-agent planning consensus
│   ├── frontend-design/           # Frontend design (+ 7 reference docs)
│   ├── adapt/ animate/ arrange/   # ┐
│   ├── audit/ bolder/ clarify/    # │ Impeccable design skills
│   ├── colorize/ critique/        # │ (20 skills for UI polish,
│   ├── delight/ distill/ extract/ # │  accessibility, typography,
│   ├── harden/ normalize/         # │  animation, and more)
│   ├── onboard/ optimize/         # │
│   ├── overdrive/ polish/         # │
│   ├── quieter/ teach-impeccable/ # │
│   ├── typeset/                   # ┘
│   ├── humanizer/                 # Remove AI-generated writing markers
│   ├── load-memory/ save-memory/  # Session memory persistence
│   ├── notion/                    # Interact with Notion workspace
│   ├── elevenlabs/                # Generate speech, audio, music
│   ├── remotion/                  # Remotion video creation
│   ├── readme/                    # Read README and execute instructions
│   └── update-diagram/            # Scan & update diagram files
├── agents/                # Specialized AI agent personas
├── prompts/               # System prompts collection (reference)
│   ├── Anthropic/ Google/ OpenAI/
│   ├── Perplexity/ Proton/ xAI/ Misc/
└── context/               # Additional context files
```

## Skills

### Core

| Skill | Description | Model Invocable |
|-------|-------------|-----------------|
| `/commit-and-push` | Commit and push to remote (extends commit-local-changes) | No |
| `/commit-and-pr` | Commit changes on a feature branch and create a GitHub PR | No |
| `/commit-local-changes` | Analyze uncommitted changes and create a commit | No |
| `/make-resume` | Generate tailored resume and cover letter from job description | Yes |
| `/readme` | Read README in current directory and execute instructions | Yes |
| `/update-diagram` | Scan codebase and update existing diagram files | Yes |
| `/notion` | Search, read, create, and manage Notion workspace content | Yes |
| `/elevenlabs` | Generate speech, sound effects, music, clone voices, transcribe audio, manage AI agents | Yes |
| `/remotion` | Best practices for Remotion video creation in React | Yes |
| `/humanizer` | Remove signs of AI-generated writing from text | Yes |
| `/load-memory` | Restore working memory from MEMORY.md at session start | Yes |
| `/save-memory` | Save working memory from the current session into MEMORY.md | Yes |
| `/plan` | Strategic planning with optional interview workflow | Yes |
| `/ralph` | Self-referential loop until task completion with configurable reviewer | Yes |
| `/ralplan` | Iterative planning with Planner, Architect, and Critic agents | Yes |
| `/excalidraw-diagram-generator` | Generate Excalidraw diagrams from natural language descriptions | Yes |

### Frontend Design — [Impeccable](https://github.com/pbakaus/impeccable)

Design-focused skills for building polished, production-grade interfaces.

| Skill | Description |
|-------|-------------|
| `/frontend-design` | Create distinctive frontend interfaces with high design quality (includes 7 reference docs) |
| `/adapt` | Adapt designs across screen sizes, devices, and platforms |
| `/animate` | Enhance features with purposeful animations and micro-interactions |
| `/arrange` | Improve layout, spacing, and visual rhythm |
| `/audit` | Comprehensive interface quality audit with severity ratings |
| `/bolder` | Amplify safe designs to be more visually impactful |
| `/clarify` | Improve UX copy, error messages, and microcopy |
| `/colorize` | Add strategic color to monochromatic interfaces |
| `/critique` | Evaluate design effectiveness with actionable UX feedback |
| `/delight` | Add moments of joy and personality to interfaces |
| `/distill` | Strip designs to their essence, removing unnecessary complexity |
| `/extract` | Extract reusable components and design tokens into a design system |
| `/harden` | Improve resilience: error handling, i18n, text overflow, edge cases |
| `/normalize` | Normalize design to match your design system |
| `/onboard` | Design onboarding flows, empty states, and first-time experiences |
| `/optimize` | Improve interface performance: loading, rendering, animations, bundle size |
| `/overdrive` | Push interfaces past conventional limits with ambitious implementations |
| `/polish` | Final quality pass — alignment, spacing, consistency, and details |
| `/quieter` | Tone down overly bold or visually aggressive designs |
| `/teach-impeccable` | One-time setup to gather and persist design context for your project |
| `/typeset` | Improve typography: font choices, hierarchy, sizing, and readability |

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

## Global vs. Project-Specific

| Scope | Location | Purpose |
|-------|----------|---------|
| **Global** | `~/dotfiles` → `~/.claude/skills` & `~/.claude/agents` | Shared across all projects (this repo) |
| **Project-specific** | `.claude/skills/` & `.claude/agents/` within a project | Scoped to that project only |

The [`dotfiles`](https://github.com/l0lxl0lw/dotfiles) repo pulls this `claude-config` repo and loads its global agents/skills into the shell. For project-specific customizations, add skills and agents directly inside the project:

```
my-project/
├── .claude/
│   ├── skills/       # Project-specific skills
│   └── agents/       # Project-specific agents
└── ...
```

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

## Skill Sources

Some skills in this repo were sourced from open-source projects:

| Source | Skills | Description |
|--------|--------|-------------|
| [pbakaus/impeccable](https://github.com/pbakaus/impeccable) | `frontend-design`, `adapt`, `animate`, `arrange`, `audit`, `bolder`, `clarify`, `colorize`, `critique`, `delight`, `distill`, `extract`, `harden`, `normalize`, `onboard`, `optimize`, `overdrive`, `polish`, `quieter`, `teach-impeccable`, `typeset` | Design-focused skills for building polished frontend interfaces |
| [github/awesome-copilot](https://github.com/github/awesome-copilot) | `excalidraw-diagram-generator` | Generate Excalidraw diagrams from natural language descriptions |
| [blader/humanizer](https://github.com/blader/humanizer) | `humanizer` | Remove signs of AI-generated writing from text |
| [oh-my-claudecode](https://github.com/anthropics/oh-my-claudecode) | `plan`, `ralph`, `ralplan` | Planning and iterative task completion agents |

## Useful References

| Resource | Description |
|----------|-------------|
| [Claude Usage Tracker](https://github.com/hamed-elfayome/Claude-Usage-Tracker) | Native macOS menu bar app to monitor Claude AI usage limits in real-time — tracks session, weekly, and Opus-specific consumption |
| [Context Window Progress Bar](https://gist.github.com/davidamo9/764415aff29959de21f044dbbfd00cd9) | Custom status line script showing real-time context window usage with color-coded progress bar, session cost, model indicator, and git branch |
