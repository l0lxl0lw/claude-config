---
description: Save current conversation to a markdown file
---

# Save Thinking Session

Save the current conversation by following these steps:

1. **Ask for session title**: Ask the user what they want to name this session (this becomes the filename).

2. **Ask for category**:
   - List existing categories from `thoughts/` directory (`/Users/azulee/workspace/claude-config/thoughts/`)
   - Let user select an existing category or create a new one
   - If new, create the subdirectory

3. **Generate summary**: Create a concise summary of the key points discussed in this conversation.

4. **Save the file**: Write to `thoughts/<category>/<filename>.md` with this format:

```markdown
---
title: <session title>
category: <category name>
date: <YYYY-MM-DD>
tags: []
---

## Research Conclusions

<If the session reached research conclusions or findings, include them here at the top. This should contain the final synthesized results, key insights, frameworks, or answers discovered during the session. If no research conclusions were reached, omit this section.>

---

## Summary

<Generated summary of key discussion points, decisions, and action items>

---

## Full Conversation

<Complete conversation history>
```

5. **Confirm save**: Tell the user the file path where the session was saved.

Note: Use `/think-resume` to continue this session later.
