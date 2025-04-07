# Marcus dotfiles for Mac

These are my version of the legendary [Holman .dotfiles](http://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/). I use the Visual Studio Code as my main editor and I've been playing around with trying to install fonts as part of the install. Then, over time, I have continuously tweaked and changed it - so it now only look like the [original repo](https://github.com/holman/dotfiles) only in structure. 

## Installation

Run this:

```bash
git clone <https://github.com/marcusoftnet/dotfiles> ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
```

This will symlink the appropriate files in `.dotfiles` to your home directory. Everything is configured and tweaked within `~/.dotfiles`.

The main file you'll want to change right off the bat is `zsh/zshrc.symlink`, which sets up a few paths that'll be different on your particular machine.

`dot` is a simple script that installs some dependencies, sets sane macOS defaults, and so on. Tweak this script, and occasionally run`dot` from time to time to keep your environment fresh and up-to-date. You can find this script in `bin/`.
