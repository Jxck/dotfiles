#!/usr/bin/env zsh

# brew install oven-sh/bun/bun
curl -fsSL https://bun.sh/install | bash


# zsh
# if [[ -d "$HOME/.bun" ]]; then
#   # completions
#   [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

#   export BUN_INSTALL="$HOME/.bun"
#   addToPath $BUN_INSTALL/bin:$PATH
# fi