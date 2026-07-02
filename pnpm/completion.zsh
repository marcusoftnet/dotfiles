# pnpm shell completion.
#
# Named `completion.zsh` so zshrc sources it *after* `compinit` runs — the
# generated script below calls `compdef`, which isn't available before then.
#
# The completion itself lives in `pnpm-completion.sh` (generated via
# `pnpm completion zsh`, see https://pnpm.io/completion). Regenerate it with
# `pnpm/install.sh` or by re-running `bin/dot`.
completion="$DOTFILES/pnpm/pnpm-completion.sh"

if command -v pnpm > /dev/null && test -f $completion
then
  source $completion
fi
