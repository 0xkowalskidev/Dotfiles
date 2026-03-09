My nix flake dotfiles.

These are my dev tenets for AI agents
Tenets order reversed due to AI "Lost in the middle" concept

## Developer Tenets

### Conflict Resolution
When tenets conflict, apply in this priority order (highest first):
1. **Fail Loudly** — Safety and correctness are non-negotiable
2. **Log Transparently** — Behavior must be traceable via logs
3. **Secure by Default** — Never introduce vulnerabilities
4. **Ask, Don't Assume** — Clarify scope and intent before building
5. **Run and Verify** — Ensure code works before considering it done
6. **Simplicity Over Cleverness** — Code and tooling must be obvious and minimal
7. **Locality of Behavior** — Keep related logic together
8. **Verbose Naming & Clear Interfaces** — Names reveal purpose, interfaces are intuitive and consistent
9. **Right-Sized Abstraction** — Abstract at the right time, not before or after
10. **Document the Non-Obvious** — Comments explain what code alone cannot

---

### 10. Document the Non-Obvious
**Rules:**
- Use comments to explain **why**, never to restate **what**
- Never write comments that duplicate function signatures or restate what is obvious

**When comments are justified:**
- **Decision rationale** — why this approach over alternatives
- **Warnings/gotchas** — "don't remove this, it prevents X"
- **Looks wrong but intentional** — "yes, this should be >= not >"
- **Workarounds** — "workaround for bug #123 in libfoo, remove after v2.0"
- **External references** — links to specs, RFCs, tickets, or docs that explain context
- **Non-obvious dependencies** — "must run after X" or "changing this requires updating Y"
- **Business/regulatory context** — "GDPR requires X" or "client specifically requested Y"
- **Complex patterns** — explain what a regex or magic string matches

**Violation:** `// increment i by 1` or `// This function gets a user by ID` above `getUserById()`.

---

### 9. Right-Sized Abstraction
**Rules:**
- Do not create abstractions (classes, utilities, helpers) for single-use cases
- Wait until a pattern appears **three times** before extracting it
- Duplicated code is acceptable if abstraction would obscure intent
- When your task changes conditions (e.g., 1 service → 2 services), re-evaluate existing structure
- Understand why code is structured the way it is before modifying
- Delete unused code rather than commenting it out — trust version control

**Violation:** Creating a generic `BaseService<T>` when only one service exists, OR adding a second service by copy-pasting rather than extracting the now-justified abstraction.

---

### 8. Verbose Naming & Clear Interfaces
**Rules:**
- Use descriptive names that reveal purpose (`getUserById` not `get`)
- Follow existing naming conventions in the codebase
- Consistency across the codebase takes priority over local preferences
- Design interfaces that are intuitive and hard to misuse
- Provide sane defaults — code and configuration should work out of the box with minimal setup
- Use consistent response structures and error formats across all APIs
- Make operations idempotent where possible — safe to retry without side effects

**Violation:** Using `data`, `info`, `tmp`, or single-letter variables outside of trivial loop indices. Requiring extensive configuration before anything works.

---

### 7. Locality of Behavior
**Rules:**
- Related logic should be co-located in the same file/module
- Avoid scattering related functionality across distant parts of the codebase
- A reader should not need to jump between many files to understand a feature

**Conflicts with:** Right-Sized Abstraction — abstractions may spread code across files; prefer locality unless abstraction is clearly justified.

**Violation:** Splitting a simple feature across 5 files for "separation of concerns" when one file would suffice.

---

### 6. Simplicity Over Cleverness
**Rules:**
- Write straightforward, linear code paths over clever one-liners
- Avoid magic values, hidden state, or implicit conversions
- Prefer explicit function parameters over global/ambient state
- Avoid nested ternaries, complex comprehensions, or dense expressions
- If code requires significant mental parsing, refactor it into explicit steps
- Make control flow and data transformations traceable by reading the code linearly
- Follow language/framework conventions unless they conflict with these tenets
- Prefer minimal dependencies — don't add a framework when a library suffices
- Minimize build complexity — avoid elaborate pipelines when simpler tools work
- Design for easy deployment — if it's hard to deploy, it's too complex

**Violation:** `return x ? (y ? a : b) : (z ? c : d);` or using a global variable to pass data between functions. Adding React for a basic web app when HTMX would suffice.

---

### 5. Run and Verify
**Rules:**
- Check project configuration (flake.nix, package.json, Makefile, etc.) to understand available scripts and commands
- Run the code after making changes
- Read the log output to verify behavior — logs are your primary verification tool
- If behavior is unclear from logs, add more logging (per tenet #2) and run again
- Run existing tests if they exist, but do not write new tests unless explicitly asked

**Violation:** Considering a task complete without running the code and reading the logs.

---

### 4. Ask, Don't Assume
**Rules:**
- When scope is unclear, ask before building
- When unsure if something matters (performance, edge cases, etc.), ask the user
- When context (prototype vs production, throwaway vs long-lived) isn't stated, ask
- Do not make assumptions about what the user wants — clarify first
- If a solution seems disproportionate to the problem, confirm the approach
- Propose simplifications to working systems, but get user approval before removing functional code

**Violation:** Building an elaborate caching system when the user just wanted a simple script, because you assumed performance mattered.

---

### 3. Secure by Default
**Rules:**
- Validate and sanitize all external input (user input, API responses, file contents)
- Use parameterized queries — never concatenate user input into SQL
- Escape output appropriately for context (HTML, URL, shell, etc.)
- Never hardcode secrets, credentials, or API keys

**Violation:** `query = "SELECT * FROM users WHERE id = " + userId` or storing passwords in plaintext.

---

### 2. Log Transparently
**Rules:**
- If the project lacks structured logging, set it up before adding features
- Log key operations and state transitions so behavior is traceable
- Use consistent, grep-able patterns (e.g., `[operation] result: details`)
- Include context: function name, relevant IDs, outcome
- Clearly distinguish success from failure in log messages
- Use appropriate log levels (debug for verbose output, info for significant events)
- Support toggling verbose logging via environment variable (e.g., `DEBUG=1`)
- Avoid noise — log what matters, not every variable

**Violation:** A function that performs multiple steps but produces no log output on success. Inconsistent log formats that are hard to parse.

---

### 1. Fail Loudly
**Rules:**
- Throw or propagate errors rather than swallowing them silently
- Error messages must be specific and actionable (include what failed and why)
- Never return null/undefined to signal an error condition when exceptions are appropriate

**Violation:** Catching an exception and logging it without re-throwing or taking corrective action.
