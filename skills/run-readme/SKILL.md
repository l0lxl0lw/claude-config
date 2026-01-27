---
name: readme
description: Read the README file in the current directory and execute the instructions or tasks described within it.
---

# Run README

Read the README file in the current directory and understand what needs to be done, then execute it.

## Steps

### Phase 1: Find and Read README

1. Look for a README file in the current working directory:
   - Check for: `README.md`, `README`, `readme.md`, `readme.txt`, `README.txt`
   - If multiple exist, prefer `README.md`
   - If none found, inform the user and stop

2. Read the README file completely

### Phase 2: Analyze Content

3. Analyze the README to understand:
   - **Project type:** What kind of project is this (library, CLI tool, web app, script, etc.)
   - **Setup instructions:** Any installation, dependency, or environment setup steps
   - **Build/run commands:** How to build, test, or run the project
   - **Tasks/TODOs:** Any explicit tasks, todos, or action items mentioned
   - **Usage instructions:** How to use the project

4. Identify what actions are needed:
   - Are there setup steps that need to be run?
   - Are there explicit tasks or todos to complete?
   - Does the user need to run specific commands?

### Phase 3: Confirm and Execute

5. Present a summary to the user:
   - What the project is about
   - What actions/tasks were identified
   - Which actions you plan to take

6. Ask the user which actions to execute if multiple options exist

7. Execute the confirmed actions:
   - Run setup commands if needed
   - Complete identified tasks
   - Follow any specific instructions

### Phase 4: Report

8. Report what was done:
   - Commands executed and their results
   - Tasks completed
   - Any issues encountered
   - Suggested next steps

## Rules

- ALWAYS read the entire README before taking any action
- NEVER execute destructive commands without explicit user confirmation
- If the README contains ambiguous instructions, ask for clarification
- If setup requires credentials or secrets, prompt the user rather than guessing
- Respect any warnings or prerequisites mentioned in the README
- If the README references other documentation, inform the user but don't automatically follow those links
- For projects with package managers, prefer the documented method (npm, pip, cargo, etc.)
- If no actionable tasks are found, summarize the README content and ask what the user wants to do
