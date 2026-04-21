# AGENTS.md — dotfiles

Personal macOS dotfiles, forked in spirit from [holman/dotfiles](https://github.com/holman/dotfiles). Structure is topical: each top-level folder (`git/`, `zsh/`, `node/`, `python/`, `docker/`, `macos/`, `homebrew/`, `vscode/`, `fabric-ai/`, `dotnet/`, `go/`, `nvm/`, `system/`, `vim/`, `xcode/`, `editorconfig/`) owns its own config, aliases, install step, and path setup.

## How the pieces wire together

The whole system runs off three conventions — follow them when adding anything new:

1. **`*.symlink` files** get symlinked into `$HOME` as `.<basename>` by [script/bootstrap](script/bootstrap#L128-L138) (searches maxdepth 2, so put them at `topic/foo.symlink`).
   - Examples: [zsh/zshrc.symlink](zsh/zshrc.symlink) → `~/.zshrc`, [git/gitconfig.symlink](git/gitconfig.symlink) → `~/.gitconfig`, [vim/vimrc.symlink](vim/vimrc.symlink) → `~/.vimrc`.
2. **`*.zsh` files** anywhere in the tree are auto-sourced by [zsh/zshrc.symlink](zsh/zshrc.symlink#L16-L29). `path.zsh` files load first, then everything else, then `completion.zsh` last. Name accordingly.
3. **`install.sh` files** are discovered and run by [script/install](script/install#L14), which is itself invoked by [bin/dot](bin/dot#L23). Keep them idempotent.

## The two entry points

- **[script/bootstrap](script/bootstrap)** — one-time setup: prompts for git identity, writes [git/gitconfig.local.symlink](git/gitconfig.local.symlink.example), creates all symlinks, then runs `bin/dot`.
- **[bin/dot](bin/dot)** — periodic refresh: applies macOS defaults, installs/upgrades Homebrew, runs `script/install` (which runs `brew bundle` against the [Brewfile](Brewfile) plus any topical `install.sh`), and finally runs `brew bundle cleanup` to prompt about removing anything not in the Brewfile.

**The [Brewfile](Brewfile) is the source of truth for installed packages.** `bin/dot` will offer to uninstall anything that's installed but missing from it. When adding a new CLI or app, add it to the Brewfile — don't `brew install` ad-hoc.

## Conventions when editing

- **New tool/language setup?** Create a new topic folder. Put aliases in `aliases.zsh`, path exports in `path.zsh`, one-time install steps in `install.sh`, dotfile configs as `*.symlink`.
- **New package?** Edit [Brewfile](Brewfile) (alphabetized within `brew`/`cask` groups, tap lines at top).
- **New git alias?** Add to [git/aliases.zsh](git/aliases.zsh) for shell aliases, or [git/gitconfig.symlink](git/gitconfig.symlink) under `[alias]` for git-native aliases. Scripts prefixed `git-*` in [bin/](bin/) are invoked as `git <name>` subcommands.
- **Private/machine-specific config** goes in `~/.localrc` (sourced by [zsh/zshrc.symlink:10-13](zsh/zshrc.symlink#L10-L13)) or `~/.gitconfig.local` (included by [git/gitconfig.symlink:2-3](git/gitconfig.symlink#L2-L3)). Never commit secrets — [git/gitconfig.local.symlink](git/gitconfig.local.symlink) is gitignored.
- **`bin/`** holds standalone executables on PATH. Git helper scripts live here and are exposed as git subcommands.
- **`functions/`** holds zsh autoloaded functions (loaded via [zsh/fpath.zsh](zsh/fpath.zsh) and [zsh/config.zsh:4-6](zsh/config.zsh#L4-L6)). One function per file, filename = function name.

## Things that are gitignored (don't commit)

See [.gitignore](.gitignore): `git/gitconfig.local.symlink`, `Brewfile.lock.json`, `.vscode/*`, Atom cache dirs.

## Platform

macOS only. The bootstrap script checks `uname -s == Darwin` before running Homebrew bits. There's a vestigial Linuxbrew branch in [homebrew/install.sh](homebrew/install.sh) but the rest of the repo (`defaults write`, casks, etc.) assumes Mac.
