---
name: make-resume
description: Generate a tailored resume and cover letter based on a job description.
disable-model-invocation: false
allowed-tools: Bash(bash *), Read, Write, Edit
---

# Make Resume

Generate a tailored resume and cover letter based on a job description.

## Scripts

This skill includes helper scripts in `~/.claude/skills/make-resume/scripts/`:

| Script | Purpose |
|--------|---------|
| `setup-company.sh <name>` | Create company folder structure |
| `convert-to-pdf.sh <path>` | Convert markdown to PDF with pandoc |
| `track-application.sh <company> <role> [status] [notes]` | Log application to applications.md |

## Steps

### Phase 1: Gather Information

1. Read `/Users/azulee/workspace/private/resume/README.md` for folder structure and workflow
2. User should paste the job description in this conversation
3. Ask for company name if not obvious from the job description
4. Set up company folder:
   ```bash
   bash ~/.claude/skills/make-resume/scripts/setup-company.sh "<company-name>"
   ```
5. **Save the job description** to `tailored/<company-name>/job-description.md` (for future reference)
6. Read master resume from `/Users/azulee/workspace/private/resume/master-resume.md`

### Phase 2: Analyze Job Description

7. Identify from the job description:
   - Required skills and technologies
   - Role type (Data Engineering, ML/AI, Backend, Full-Stack, etc.)
   - Key responsibilities
   - Company values/culture signals

### Phase 3: Generate Tailored Resume

8. Create tailored resume (`resume.md`):
   - Keep header/contact info unchanged
   - Rewrite Profile section to align with the role
   - Reorder/emphasize skills matching the JD
   - Highlight relevant experience bullets
   - May reorganize experience order if beneficial
   - Keep education and side projects unless space-constrained

### Phase 4: Generate Cover Letter

9. Create cover letter (`cover-letter.md`) in a **conversational, human tone**:
   - Greeting: "Hi," or "Hi [Name]," (use hiring manager name if in JD)
   - Opening: What caught your attention about this specific role (not generic interest)
   - Body: 2-3 short paragraphs with specific projects that relate to their needs
   - Be upfront about any gaps (e.g., "my primary languages are X, not Y")
   - Closing: Casual call to action like "Would love to chat more about what you're building."
   - Sign-off: "Thanks," or "Cheers,"

   **Avoid corporate AI-speak:**
   - NO "I am writing to express my interest..."
   - NO "I am excited about the opportunity to..."
   - NO "Thank you for considering my application"
   - NO overly formal language or generic phrases

### Phase 5: Save and Convert

10. Write `resume.md` and `cover-letter.md` to the company folder
11. Convert to PDF:
    ```bash
    bash ~/.claude/skills/make-resume/scripts/convert-to-pdf.sh "/Users/azulee/workspace/private/resume/tailored/<company-name>"
    ```

### Phase 6: Track Application

12. Log the application:
    ```bash
    bash ~/.claude/skills/make-resume/scripts/track-application.sh "<company-name>" "<role-title>"
    ```

### Phase 7: Summary

13. Report:
    - Files created and their locations
    - Key customizations made
    - Any suggestions for manual review

## Rules

- **Markdown line breaks:** Use two newlines (blank line) for any content that needs to appear on separate lines in the PDF. A single newline in markdown becomes a space, not a line break. This is especially important for sign-offs (e.g., "Thanks," and "Azu" must have a blank line between them).
- ALWAYS save the job description to `job-description.md` before generating tailored materials
- ALWAYS read the master resume first before generating anything
- NEVER fabricate experience or skills - only reorganize and emphasize existing content
- Keep resume to 1 page when possible (prioritize recent/relevant experience)
- Write cover letters in conversational, human tone—NOT corporate AI-speak
- Match the resume markdown format from master resume
- If pandoc fails, inform user and keep markdown files
