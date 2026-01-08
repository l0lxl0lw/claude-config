---
description: Generate short made-up words and check domain availability
---

# Domain Lookup

Generate short, catchy, made-up words that are easy to pronounce and check their domain availability.

## Instructions

1. **Ask user for preferences** using the AskUserQuestion tool with these three questions:
   - **Extensions**: Which domain extensions to check? (multiSelect: true)
     - .com
     - .io
     - .ai
     - .co
   - **Quantity**: How many domain names to generate and check?
     - 5
     - 10
     - 20
     - 50
   - **Requirements**: Any specific requirements for the names? (user can select or provide custom input)
     - "Tech/modern vibe" - sleek, futuristic sounding
     - "Friendly/approachable" - warm, inviting sounds
     - "No preference" - generate variety
     - (User can also type custom requirements like: "must start with S", "include 'io' sound", "Latin feel", etc.)

2. **Generate made-up words** following these rules:
   - **Apply user's requirements first** - if they specified a vibe, starting letter, sound, or theme, prioritize that
   - Length: 4-6 characters
   - Easy to pronounce (use common syllable patterns)
   - Patterns like: CVCV, CVCCV, CVCVC (C=consonant, V=vowel)
   - Examples of good patterns: "klio", "pulso", "wayvo", "lumio", "sessio"
   - Use soft consonants (l, m, n, r, s, v, w) combined with clear vowels
   - Avoid confusing letter combos (gh, ph, qu, x, z)
   - Make them sound modern/tech-friendly

3. **Check availability** for each generated word + selected extensions:
   - Use WebFetch to check domain registrar sites (namecheap.com, etc.)
   - Fetch: `https://www.namecheap.com/domains/registration/results/?domain={word}`
   - Parse the results to determine if domain appears available or taken
   - Run ALL checks without asking for confirmation - batch them efficiently

4. **Present results** in a clean table format:
   ```
   | Word   | .com | .io  | .ai  | .co  |
   |--------|------|------|------|------|
   | klio   | X    | OK   | OK   | X    |
   | pulso  | OK   | OK   | X    | OK   |
   ```
   - OK = likely available
   - X = taken
   - ? = couldn't determine

5. **Highlight the best options**: Words with the most available extensions across user's selected TLDs.

## Important
- Do NOT ask "should I check this domain?" for each one - check ALL automatically
- Generate fresh, unique words each time (don't repeat common startup names)
- Prioritize truly novel combinations that are unlikely to be registered
