#!/usr/bin/env bash
#
# Symlink VS Code's settings and keybindings into place.
#
# VS Code reads from ~/Library/Application Support/Code/User/, a nested path
# the repo's *.symlink convention can't reach (see ghostty/install.sh for the
# same problem). Backs up any pre-existing real file before symlinking, since
# unlike a fresh terminal config, VS Code settings accumulate real value over
# time.
#
# Run automatically by script/install (via bin/dot).

set -e

SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$HOME/Library/Application Support/Code/User"

mkdir -p "$CONFIG_DIR"

link_if_needed() {
  local src=$1 dst=$2

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    return
  fi

  if [ -e "$dst" ]; then
    mv "$dst" "${dst}.backup"
  fi

  ln -s "$src" "$dst"
}

link_if_needed "$SOURCE_DIR/settings.json" "$CONFIG_DIR/settings.json"
link_if_needed "$SOURCE_DIR/keybindings.json" "$CONFIG_DIR/keybindings.json"
