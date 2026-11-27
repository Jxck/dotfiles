#!/usr/bin/env zsh

dotfiles=(
  .gitattributes
  .gitconfig
  .gitignore_global
  .ncurc.json
  .npmrc
  .tmux.conf
  .vim
  .vimrc
  .zprofile
  .zshenv
  .zshrc
)

# skill and agent links (link, target)
agent_links=(
  "$HOME/.agents/skills" "$HOME/dotfiles/.agents/skills"
  "$HOME/.claude/agents" "$HOME/dotfiles/.claude/agents"
  "$HOME/.codex/agents" "$HOME/dotfiles/.codex/agents"
)

# preflight: never remove or replace an existing real directory.
# check everything before the first change, and stop without changing anything.
errors=()
for link target in $agent_links
do
  [[ -d "$target" ]] || continue
  if [[ -L "$link" ]]; then
    if [[ "$(readlink "$link")" != "$target" ]]; then
      errors+=("$link is a link to $(readlink "$link") (expected $target)")
    fi
  elif [[ -e "$link" ]]; then
    errors+=("$link exists and is not a symlink")
  fi
done
for dir in .claude .codex
do
  for file in "$HOME/dotfiles/$dir"/*(N)
  do
    name=$(basename "$file")
    [[ "$name" == "agents" ]] && continue
    [[ "$dir" == ".codex" && "$name" == "skills" ]] && continue
    if [[ -d "$HOME/$dir/$name" && ! -L "$HOME/$dir/$name" ]]; then
      errors+=("$HOME/$dir/$name is a real directory")
    fi
  done
done
if [[ ${#errors} -gt 0 ]]; then
  echo "slink.sh: stop without changing anything" >&2
  for error in $errors
  do
    echo "  $error" >&2
  done
  exit 1
fi

for dotfile in $dotfiles
do
  \rm -rf $HOME/$dotfile
  ln -s "$HOME/dotfiles/$dotfile" "$HOME/$dotfile"
done

# .claude/ と .codex/ の中身を ~/. 以下に slink
# - agents は下の専用処理で扱う
# - .codex/skills は codex が .system/ を作る実 directory なので触らない
#   (user skill は ~/.agents/skills から読まれる)
for dir in .claude .codex; do
  src="$HOME/dotfiles/$dir"
  dst="$HOME/$dir"
  if [[ -d "$src" ]]; then
    mkdir -p "$dst"
    for file in "$src"/*; do
      name=$(basename "$file")
      if [[ "$name" == "agents" ]]; then
        continue
      fi
      if [[ "$dir" == ".codex" && "$name" == "skills" ]]; then
        continue
      fi
      \rm -rf "$dst/$name"
      ln -s "$file" "$dst/$name"
    done
  fi
done

# skill と agent の link を張る (preflight 済みなので、未作成のものだけ作る)
mkdir -p "$HOME/.agents"
for link target in $agent_links
do
  [[ -d "$target" ]] || continue
  [[ -L "$link" ]] && continue
  ln -s "$target" "$link"
done

# linearmouse
linearmouse_config="$HOME/dotfiles/linearmouse/linearmouse.json"
if [[ -f "$linearmouse_config" ]]; then
  mkdir -p $HOME/.config/linearmouse
  \rm -rf $HOME/.config/linearmouse/linearmouse.json
  ln -s "$linearmouse_config" $HOME/.config/linearmouse/linearmouse.json
fi

# cmux
cmux_config="$HOME/dotfiles/cmux/cmux.json"
if [[ -f "$cmux_config" ]]; then
  mkdir -p $HOME/.config/cmux
  \rm -rf $HOME/.config/cmux/cmux.json
  ln -s "$cmux_config" $HOME/.config/cmux/cmux.json
fi

# Cargo
cargo_config="$HOME/dotfiles/.cargo/config.toml"
if [[ -f "$cargo_config" ]]; then
  mkdir -p $HOME/.cargo
  \rm -rf $HOME/.cargo/config.toml
  ln -s "$cargo_config" $HOME/.cargo/config.toml
fi

# .ssh/config は macOS 専用で、既存があれば触らない
# 1Password の agent socket / colima / XQuartz の path を持つため、Linux に張ると
# IdentityAgent が存在しない socket を指し、転送された agent が使えなくなる
ssh_config="$HOME/dotfiles/.ssh/config"
if [[ `uname` == "Darwin" && -f "$ssh_config" ]]; then
  mkdir -p $HOME/.ssh
  if [[ -e "$HOME/.ssh/config" || -L "$HOME/.ssh/config" ]]; then
    echo "skip $HOME/.ssh/config (already exists)"
  else
    ln -s "$ssh_config" "$HOME/.ssh/config"
  fi
fi
