---
description: Analyze codebase and generate/update README with accurate documentation
---

# README Update

Comprehensively analyze the current project's codebase and generate or update the README.md to accurately reflect the project's structure, features, and usage.

## Instructions

### Phase 1: Codebase Analysis

1. **Identify project type and root files**:
   - Check for `package.json`, `requirements.txt`, `Cargo.toml`, `go.mod`, `pom.xml`, `Gemfile`, etc.
   - Read the main config files to understand dependencies and scripts
   - Check for existing `README.md` to understand current state

2. **Map folder structure**:
   - Use Glob to get an overview of all directories and key files
   - Identify the hierarchy: `src/`, `lib/`, `app/`, `components/`, `pages/`, `api/`, `functions/`, `supabase/`, `prisma/`, etc.
   - Note any unconventional or project-specific directories

3. **Identify architecture components**:
   - **Frontend**: React, Vue, Next.js, Nuxt, Svelte, etc. (check for components, pages, styles)
   - **Backend/API**: Express, FastAPI, serverless functions, API routes
   - **Database**: Look for schemas, migrations, models (`prisma/`, `supabase/migrations/`, `drizzle/`, SQL files, ORM models)
   - **Infrastructure**: Docker files, terraform, serverless.yml, vercel.json, fly.toml, etc.
   - **Testing**: Test directories, jest.config, pytest.ini, etc.

4. **Understand code flow**:
   - Find entry points (main.ts, index.js, app.py, etc.)
   - Trace key imports and module dependencies
   - Identify core business logic locations

### Phase 2: Extract Key Information

5. **Tech Stack**:
   - List all major frameworks and libraries with versions from config files
   - Identify language(s) used
   - Note any notable tools (ESLint, Prettier, Husky, etc.)

6. **Features**:
   - Read through main modules/components to understand what the app does
   - Check route handlers, API endpoints, and page components
   - Look for feature flags, config options, or environment variables

7. **Environment & Configuration**:
   - Check for `.env.example`, `.env.template`, or documented env vars
   - Identify required API keys, database connections, third-party services
   - Note any secrets management approach

8. **Deployment**:
   - Check for deployment configs (Vercel, Netlify, Railway, Fly.io, Docker, etc.)
   - Look at CI/CD files (`.github/workflows/`, `gitlab-ci.yml`, etc.)
   - Identify build commands and deployment scripts from package.json or config

### Phase 3: Generate README

9. **Structure the README** with these sections (include only what's relevant):

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

### Phase 4: Write or Update

10. **If README exists**:
    - Preserve any custom sections (Contributing, License, badges, etc.)
    - Update technical sections with accurate current info
    - Ask user if they want to overwrite or show diff first

11. **If no README exists**:
    - Create a comprehensive new README.md
    - Inform user of the generated file

## Important Notes

- Be thorough but concise - don't pad with unnecessary info
- Only include sections that are relevant to the project
- Use actual values from the codebase, don't guess or use placeholders
- If deployment method is unclear, either omit the section or note it needs to be filled in
- Preserve existing badges, links, and custom sections when updating
