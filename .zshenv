# if $HOMEBREW_PREFIX is not exported
if [[ -z $HOMEBREW_PREFIX ]]; then
  # Homebrew Apple Silicon
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  # Homebrew Intel
  if [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  # Linuxbrew
  if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
fi

# Mise (non-interactive only; interactive shells use `mise activate` in .zshrc)
if [[ ! -o interactive ]] && [[ -z $MISE_GLOBAL_CONFIG_FILE ]]; then
  export MISE_GLOBAL_CONFIG_FILE="/home/jxck/dotfiles/.mise.toml"
  export PATH="/home/jxck/.local/share/mise/shims:$PATH"
fi