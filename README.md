## Setup 

To checkout the repo on a new machine, run:

```sh
alias cf='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
echo ".dotfiles" >>.gitignore
git clone --bare <git-repo-url> $HOME/.dotfiles
cf checkout
chmod +x "$HOME"/.config/scripts/git-hooks/setup-git-hooks.sh
./"$HOME"/.config/scripts/git-hooks/setup-git-hooks.sh
```

This will pull the repo down, checkout the config, then run a script to commit an updated package list on every commit.

On macOS, also switch to the platform branch after checkout:

```sh
cf switch macos
```

If `cf fetch` does not populate `origin/*` remote-tracking branches, the remote configuration is missing a fetch refspec. Add one and re-fetch:

```sh
cf config --add remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
cf fetch origin
```

## Branch workflow

### Branch purposes

- **`main`** — Linux + cross-platform base. All configuration that applies to every machine, plus Linux-specific defaults (e.g. `copy_command "wl-copy"` in `zellij/config.kdl`).
- **`macos`** — macOS-only additions layered on top of `main` via rebase. Includes aerospace, sketchybar, hammerspoon, macOS-only ghostty/zshrc tweaks, and platform overrides (e.g. `copy_command "pbcopy"`).

### Invariant

`macos` contains the commits of `main` followed by the macOS-only commits, in that order. Branches are never merged. `macos` is rebased onto `main` whenever `main` advances.

### Choosing the target branch for a change

At commit time, classify each change:

- Applies on every machine → `main`.
- Applies only to macOS → `macos`.
- Session contains both types → split into two commits on the appropriate branches (Recipe 3).

### Recipe 1: Uncommitted WIP on the wrong branch

Use when the entire diff belongs on the other branch.

1. `cf stash push -u -m "moving branches"`
2. `cf switch <target-branch>`
3. `cf stash pop`
4. `cf add <files>`
5. `cf commit -m "..."`
6. `cf push origin <target-branch>`
7. If `<target-branch>` is `main`, rebase `macos` on top:
   ```sh
   cf switch macos
   cf rebase origin/main
   cf push --force-with-lease origin macos
   ```

Note: the `-u` flag on `cf stash push` includes untracked files. The repo's gitignore ignores everything by default, so newly created files appear untracked until `cf add -f` is run.

### Recipe 2: Commit already made on the wrong branch

Copy the commit to the correct branch, then remove it from the incorrect branch.

1. `cf switch <target-branch>`
2. `cf cherry-pick <sha>`
3. `cf push origin <target-branch>`
4. `cf switch <source-branch>`
5. `cf rebase -i origin/<target-branch>`
6. In the rebase editor, delete the line beginning with `pick <sha>`. Save and close.
7. `cf push --force-with-lease origin <source-branch>`

### Recipe 3: Mixed WIP (cross-platform + macOS-only)

#### Split by file

Use when cross-platform and macOS-only changes are in distinct files.

1. `cf stash push -u -m "mixed wip"`
2. `cf switch main`
3. `cf stash pop`
4. `cf add <cross-platform files>`
5. `cf commit -m "..."`
6. `cf stash push -u -m "macos bits"`
7. `cf push origin main`
8. `cf switch macos`
9. `cf rebase origin/main`
10. `cf stash pop`
11. `cf add <macos-only files>`
12. `cf commit -m "..."`
13. `cf push --force-with-lease origin macos`

#### Split by hunk

Use when a single file contains both cross-platform and macOS-only changes.

1. `cf switch main`
2. `cf add -p <file>` — at each hunk prompt, press `y` to stage cross-platform hunks and `n` for macOS-only hunks.
3. `cf commit -m "..."`
4. `cf stash push -u -m "macos override"`
5. `cf push origin main`
6. `cf switch macos`
7. `cf rebase origin/main`
8. `cf stash pop`
9. `cf add <file>`
10. `cf commit -m "..."`
11. `cf push --force-with-lease origin macos`

### Verification

Confirm the invariant holds:

```sh
cf log --oneline origin/main..origin/macos
cf diff origin/main origin/macos --stat
```

The log lists only macOS-only commits. The diff shows only macOS-relevant files.
