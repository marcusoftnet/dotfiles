export NVM_DIR=~/.nvm
if [ -e "$(brew --prefix nvm)/nvm.sh" ]; then
  source $(brew --prefix nvm)/nvm.sh
  if command -v npm >/dev/null 2>&1; then
    nvm use node --silent
  fi
fi

