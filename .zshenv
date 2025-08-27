export TERM=foot
export VISUAL=nvim
export EDITOR=nvim
export BROWSER=/usr/share/applications/firefox-nightly.desktop
export MANPAGER='nvim +Man!'
export FZF_DEFAULT_COMMAND='fd -H'
export FZF_DEFAULT_OPTS="\
    --height 60% \
    --highlight-line \
    --info=inline-right \
    --ansi \
    --layout=reverse \
    --border=none
    --color=bg+:#2d3f76 \
    --color=bg:#1e2030 \
    --color=border:#589ed7 \
    --color=fg:#c8d3f5 \
    --color=gutter:#1e2030 \
    --color=header:#ff966c \
    --color=hl+:#65bcff \
    --color=hl:#65bcff \
    --color=info:#545c7e \
    --color=marker:#ff007c \
    --color=pointer:#ff007c \
    --color=prompt:#65bcff \
    --color=query:#c8d3f5:regular \
    --color=scrollbar:#589ed7 \
    --color=separator:#ff966c \
    --color=spinner:#ff007c \
    --preview='cat {+}' \
"

source "/home/jonny/.env"

## Package manager paths
# Luarocks path
eval "$(luarocks path --bin)"
if [[ ":$PATH:" != *":$HOME/.luarocks/bin"* ]]; then
    export PATH="$PATH:$HOME/.luarocks/bin"
fi
# Cargo Path
if [[ ":$PATH:" != *":$HOME/.cargo/bin"* ]]; then
    export PATH="$PATH:$HOME/.cargo/bin"
fi
# Bun Path
if [[ ":$PATH:" != *":$HOME/.bun/bin"* ]]; then
    export PATH="$PATH:$HOME/.bun/bin"
fi
export BUN_INSTALL="$HOME/.bun"
# Go Path
GOPATH_BIN=$(go env GOPATH)/bin
if [[ ":$PATH:" != *":$GOPATH_BIN"* ]]; then
    export PATH="$PATH:$GOPATH_BIN"
fi
# Dotnet Path
if [[ ":$PATH:" != *":$HOME/.dotnet/tools"* ]]; then
    export PATH="$PATH:$HOME/.dotnet/tools"
fi

# uv install location
export PATH="$PATH:/home/jonny/.local/bin"
