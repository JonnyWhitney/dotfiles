## Setup 

To checkout the repo on a new machine, run:

```sh
alias cf='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
echo ".dotfiles" >>.gitignore
git clone --bare <git-repo-url >$HOME/.dotfiles
cf checkout
chmod +x "$HOME"/.config/scripts/git-hooks/setup-git-hooks.sh
./"$HOME"/.config/scripts/git-hooks/setup-git-hooks.sh
```

This will pull the repo down, checkout the config, then run a script to commit an updated package list on every commit.

On macOS, also switch to the platform branch after checkout:

```sh
cf switch macos # checks out the single squashed macOS patch atop main
```

If `cf fetch` does not populate `origin/*` remote-tracking branches, the remote configuration is missing a fetch refspec. Add one and re-fetch:

```sh
cf config --add remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
cf fetch origin
```

## Branch workflow

### Branch purposes

- **`main`** — Linux + cross-platform base. All configuration that applies to every machine, plus Linux-specific defaults (e.g. `copy_command "wl-copy"` in `zellij/config.kdl`).
- **`macos`** — macOS-only additions layered on top of `main` as a single squashed patch. Includes aerospace, sketchybar, hammerspoon, macOS-only ghostty/zshrc tweaks, and platform overrides (e.g. `copy_command "pbcopy"`).

### Invariant

`macos` is `main` plus a single squashed commit containing all macOS-only configuration. Branches are never merged. `macos` is rebased onto `main` whenever `main` advances; the squashed patch is re-created on top (Recipe 2).

Per-commit history on `macos` is not preserved — only the cumulative patch matters.
