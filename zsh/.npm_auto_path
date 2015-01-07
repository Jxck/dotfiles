ORIG_PATH=$PATH
function npm_auto_path() {
  if [[ -d node_modules  ]]; then
    export PATH=$(npm bin):$ORIG_PATH
  else
    export PATH=$ORIG_PATH
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd npm_auto_path
