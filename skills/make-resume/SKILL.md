---
name: make-resume
description: Generate a tailored resume and cover letter based on a job description.
disable-model-invocation: true
---

# Make Resume

Generate a tailored resume and cover letter based on a job description.

## Steps

### Phase 1: Gather Information
1. User should paste the job description in this conversation
2. Ask for company name if not obvious from the job description
3. Read master resume from `/Users/azulee/workspace/private/resume/master-resume.md`

### Phase 2: Analyze Job Description
4. Identify from the job description:
   - Required skills and technologies
   - Role type (Data Engineering, ML/AI, Backend, Full-Stack, etc.)
   - Key responsibilities
   - Company values/culture signals

### Phase 3: Generate Tailored Resume
5. Create tailored resume (`resume.md`):
   - Keep header/contact info unchanged
   - Rewrite Profile section to align with the role
   - Reorder/emphasize skills matching the JD
   - Highlight relevant experience bullets
   - May reorganize experience order if beneficial
   - Keep education and side projects unless space-constrained

### Phase 4: Generate Cover Letter
6. Create cover letter (`cover-letter.md`):
   - Professional greeting (use hiring manager name if in JD)
   - Opening: Express interest and mention how you found the role
   - Body: 2-3 paragraphs connecting your experience to their needs
   - Closing: Call to action, enthusiasm for interview
   - Professional sign-off

### Phase 5: Save and Convert
7. Create output folder: `/Users/azulee/workspace/private/resume/tailored/<company-name>/`
8. Write `resume.md` and `cover-letter.md` to the folder
9. Convert to PDF using pandoc with weasyprint and custom CSS:
   ```bash
   cd /Users/azulee/workspace/private/resume/tailored/<company-name>/
   pandoc resume.md -o resume.pdf --pdf-engine=weasyprint --css=/Users/azulee/workspace/private/resume/resume.css
   pandoc cover-letter.md -o cover-letter.pdf --pdf-engine=weasyprint --css=/Users/azulee/workspace/private/resume/resume.css
   ```

### Phase 6: Track Application
10. Read `/Users/azulee/workspace/private/resume/applications.md` (create if doesn't exist)
11. Append new entry to the table:
    ```markdown
    | <company-name> | <role-title> | <YYYY-MM-DD> | Applied | - |
    ```

### Phase 7: Summary
12. Report:
    - Files created and their locations
    - Key customizations made
    - Any suggestions for manual review

## Rules

- ALWAYS read the master resume first before generating anything
- NEVER fabricate experience or skills - only reorganize and emphasize existing content
- Keep resume to 1 page when possible (prioritize recent/relevant experience)
- Use professional, confident tone in cover letter
- Match the resume markdown format from master resume
- If md2pdf fails, inform user and keep markdown files
- applications.md format (create with header if file doesn't exist):
  ```markdown
  # Job Applications

  | Company | Role | Date | Status | Notes |
  |---------|------|------|--------|-------|
  ```
