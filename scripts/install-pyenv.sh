#!/bin/sh

# reference: https://github.com/pyenv/pyenv#installation

brew update
brew install pyenv
brew install pyenv-virtualenv

echo 'if command -v pyenv 1>/dev/null 2>&1; then eval "$(pyenv init -)"; fi' >> ~/.zprofile
echo 'if command -v pyenv 1>/dev/null 2>&1; then eval "$(pyenv init --path)"; fi' >> ~/.zshrc
