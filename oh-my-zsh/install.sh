#!/bin/sh
#
# oh-my-zsh
#
# Clones oh-my-zsh into ~/.oh-my-zsh if not already present.
# Theme and plugins are configured in oh-my-zsh/config.zsh.

set -e

OMZ_DIR="$HOME/.oh-my-zsh"

if [ -d "$OMZ_DIR" ]; then
  echo "  oh-my-zsh already installed at $OMZ_DIR — skipping."
  exit 0
fi

echo "  Installing oh-my-zsh into $OMZ_DIR"
git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$OMZ_DIR"
