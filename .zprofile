export DEV=$HOME/develop

# if $HOMEBREW_PREFIX is not exported
if [[ -z $HOMEBREW_PREFIX ]]; then
  echo "$ brew shellenv"

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
