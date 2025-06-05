export NVM_DIR=~/.nvm
if [ -e "$(brew --prefix nvm)/nvm.sh" ]; then
  source $(brew --prefix nvm)/nvm.sh
  nvm use node --silent
fi

