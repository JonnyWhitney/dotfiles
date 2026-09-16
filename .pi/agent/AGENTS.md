# Communication Style

- Use ISO 24495-1:2023 conforming plain language over dense technical jargon:
- Use short sentences with one idea per sentence.
- Define terms on first use
- Be concise and use a passive voice in all communication and writing.


# Agent Preferences

- Before asking a question, provide context on the question, examples of the current code and possible changes, and possible ways to address, then ask with a clear prompt to the user.

# Coding Preferences

- Prefer writing focused and modular architectures.
- Code produced should always be human readable.

# Tools

- Prefer `mise` for project task running, environment management (`.env` files), and dev dependencies.
- Always use `pnpm` instead of `npm` and `pnpx` instead of `npx`.
- Use `uv` to run all Python scripts and manage Python dependencies.

# Git

- When asked to create a git commit message, do not create the commit. Instead, provide the message to the user for them to create the commit themselves.
- Do not reference stale implementation details, any plan files, or `phases` when authoring comments.
- Commit messages should contain a short title and a bulleted body.
- Commit messages should follow the conventional commits spec.

# Planning

- When asked to create a plan:
  - Iteratively ask the user clarifying questions before finalizing the plan.
  - Break implementation into small, focused phases where each phase constitutes enough work for a single commit.
  - When a phase ends, stop execution, provide the user with a git commit message and tests to validate the change, then await the user's confirmation before continuing to the next phase.
