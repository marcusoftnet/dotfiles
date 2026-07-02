#!/bin/bash
#
# Regenerate pnpm's zsh completion script. Idempotent: overwrites the checked-in
# `pnpm-completion.sh` with fresh output whenever pnpm is installed.
# See https://pnpm.io/completion

set -e

if command -v pnpm > /dev/null
then
  cd "$(dirname "$0")"
  pnpm completion zsh > pnpm-completion.sh
  echo "✅ Regenerated pnpm zsh completion."
fi
