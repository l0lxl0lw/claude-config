---
description: Analyze codebase and generate/update README with accurate documentation
---

# README Update

Comprehensively analyze the current project's codebase and generate or update the README.md to accurately reflect the project's structure, features, and usage.

## Instructions

### Phase 1: Codebase Analysis

**Use the `codebase-analyst` agent to perform a deep scan of the entire project.**

The agent will analyze and return:
- Project type, tech stack, and dependencies
- Folder structure and architecture components
- Entry points and code flow
- Patterns, conventions, and external integrations
- Key components and their relationships

Also check for existing `README.md` to understand current state and preserve custom sections.

### Phase 2: Generate README

**Structure the README** with these sections (include only what's relevant):

```markdown
# Project Name

Brief description of what this project does.

## Tech Stack

- **Frontend**: [framework] + [key libraries]
- **Backend**: [framework/runtime]
- **Database**: [database + ORM if any]
- **Deployment**: [platform]

## Features

- Feature 1
- Feature 2
- ...

## Project Structure

```
├── src/
│   ├── components/     # React components
│   ├── pages/          # Page routes
│   └── ...
├── supabase/
│   └── migrations/     # Database migrations
└── ...
```

## Getting Started

### Prerequisites

- Node.js >= X.X
- [other requirements]

### Environment Setup

1. Clone the repository
2. Copy `.env.example` to `.env` and fill in values:
   - `DATABASE_URL`: ...
   - `API_KEY`: ...

### Installation

```bash
npm install  # or yarn, pnpm, etc.
```

### Development

```bash
npm run dev
```

## Deployment

[Instructions specific to the deployment platform found]

## Scripts

| Command | Description |
|---------|-------------|
| `npm run dev` | Start development server |
| `npm run build` | Build for production |
| ... | ... |
```

### Phase 3: Write or Update

**If README exists**:
    - Preserve any custom sections (Contributing, License, badges, etc.)
    - Update technical sections with accurate current info
    - Ask user if they want to overwrite or show diff first

**If no README exists**:
    - Create a comprehensive new README.md
    - Inform user of the generated file

## Important Notes

- Be thorough but concise - don't pad with unnecessary info
- Only include sections that are relevant to the project
- Use actual values from the codebase, don't guess or use placeholders
- If deployment method is unclear, either omit the section or note it needs to be filled in
- Preserve existing badges, links, and custom sections when updating
