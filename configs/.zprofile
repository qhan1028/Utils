# brew
if command -v /opt/homebrew/bin/brew 1>/dev/null 2>&1; then eval "$(/opt/homebrew/bin/brew shellenv)"; fi

# pyenv
if command -v pyenv 1>/dev/null 2>&1; then eval "$(pyenv init --path)"; fi

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
