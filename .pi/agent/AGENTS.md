# Coding Preferences

- Prefer writing focused and modular architectures.
- Code produced should always be human readable.

# Git

- When asked to create a git commit message, do not create the commit. Instead, provide the message to the user for them to create the commit themselves.
- Before asking a question, provide context on the question, examples of the current code and possible changes, and possible ways to address, then ask with a clear prompt to the user.
- Do not reference previous implementations when authoring comments.

# Planning

- When asked to create a plan:
  - Iteratively ask the user clarifying questions before finalizing the plan.
  - Questions should provide proper context. You must explain the context of the questions, and why it is being asked every time.
  - Break implementation into small, focused phases where each phase constitutes enough work for a single commit.
  - When a phase ends, stop execution, provide the user with a git commit message and tests to validate the change, then await the user's confirmation before continuing to the next phase.

# Tools

- Always use `pnpm` instead of `npm` and `pnpx` instead of `npx`.
- Prefer `mise` for project task running, environment management (`.env` files), and dev dependencies.

# Agent Preferences

- Always show the full output of commands you run, even when verbose mode is not set. Do not summarize or truncate command output — paste it back verbatim.

# Communication Style

- Use ASD-STE100 Simplified Technical English for all communication. Code comments should try to use this language, but follow language standards where appropriate.
