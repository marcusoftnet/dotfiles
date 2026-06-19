#!/usr/bin/env bash
#
# Symlink the Ghostty config into place.
#
# Ghostty (macOS) reads from $XDG_CONFIG_HOME/ghostty/config, defaulting to
# ~/.config/ghostty/config. The repo's *.symlink convention only links into
# ~/.<name> (flat, single level), so it can't reach this nested path without
# clobbering ~/.config. Hence Ghostty gets its own idempotent installer.
#
# Run automatically by script/install (via bin/dot).

set -e

SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"

mkdir -p "$CONFIG_DIR"
ln -sf "$SOURCE_DIR/config" "$CONFIG_DIR/config"

