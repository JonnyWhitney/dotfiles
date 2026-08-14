# Communication Style

- Use ASD-STE100 Simplified Technical English for all communication. Code comments should try to use this language, but follow language standards where appropriate.

# Agent Preferences

- Before asking a question, provide context on the question, examples of the current code and possible changes, and possible ways to address, then ask with a clear prompt to the user.

# Coding Preferences

- Prefer writing focused and modular architectures.
- Code produced should always be human readable.

# Tools

- Always use `pnpm` instead of `npm` and `pnpx` instead of `npx`.
- Prefer `mise` for project task running, environment management (`.env` files), and dev dependencies.

# Git

- When asked to create a git commit message, do not create the commit. Instead, provide the message to the user for them to create the commit themselves.
- Do not reference stale implementation details when authoring comments.
- Commit messages should contain a short title and a bulleted body.

# Planning

- When asked to create a plan:
  - Iteratively ask the user clarifying questions before finalizing the plan.
  - Break implementation into small, focused phases where each phase constitutes enough work for a single commit.
  - When a phase ends, stop execution, provide the user with a git commit message and tests to validate the change, then await the user's confirmation before continuing to the next phase.
