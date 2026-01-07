---
description: Resume a previous thinking session
---

# Resume Thinking Session

Resume a previous thinking session by following these steps:

1. **List all saved sessions**: Scan the `thoughts/` directory (`/Users/azulee/workspace/claude-config/thoughts/`) and its subdirectories for all `.md` files.

2. **Present sessions to user**: Display the available sessions organized by category, showing:
   - Category name
   - Session title (from frontmatter or filename)
   - Date saved (from frontmatter)

3. **Let user select**: Ask the user which session they want to resume.

4. **Load context**: Read the selected markdown file completely to understand:
   - The summary of what was discussed
   - The full conversation history
   - Any key decisions or action items

5. **Resume conversation**: Acknowledge what was previously discussed and ask how the user would like to continue.

Tip: After resuming, use `/think-save` to save progress with updates.
