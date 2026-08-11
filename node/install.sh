#!/bin/bash

export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"

if [ -e "$(brew --prefix nvm)/nvm.sh" ]; then
  # Load nvm
  . "$(brew --prefix nvm)/nvm.sh"

  # Get the last version number, strip spaces, arrows, and asterisks
  LATEST_NODE=$(nvm ls-remote --no-colors | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | tail -1)
  CURRENT_NODE=$(nvm version node)

  if [ "$CURRENT_NODE" != "$LATEST_NODE" ]; then
    echo "⬇️ Installing latest Node.js ($LATEST_NODE)..."
    nvm install node > /dev/null
    nvm use node > /dev/null
    echo "✅ Installed Node.js $LATEST_NODE."
  fi
fi