
# brew
if command -v /opt/homebrew/bin/brew 1>/dev/null 2>&1; then eval "$(/opt/homebrew/bin/brew shellenv)"; fi

# pyenv
if command -v pyenv 1>/dev/null 2>&1; then eval "$(pyenv init --path)"; fi
