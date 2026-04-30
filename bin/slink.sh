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

for dotfile in $dotfiles
do
  \rm -rf $HOME/$dotfile
  ln -s "$HOME/dotfiles/$dotfile" "$HOME/$dotfile"
done

# .claude/ と .codex/ の中身を ~/. 以下に slink
# ただし .codex/skills は codex が .system/ を auto-create するため、
# ディレクトリごと差し替えず per-skill symlink で扱う (下のループで処理)
for dir in .claude .codex; do
  src="$HOME/dotfiles/$dir"
  dst="$HOME/$dir"
  if [[ -d "$src" ]]; then
    mkdir -p "$dst"
    for file in "$src"/*; do
      name=$(basename "$file")
      if [[ "$dir" == ".codex" && "$name" == "skills" ]]; then
        continue
      fi
      \rm -rf "$dst/$name"
      ln -s "$file" "$dst/$name"
    done
  fi
done

# .codex/skills 配下に per-skill symlink を貼る (.system/ は触らない)
mkdir -p "$HOME/.codex/skills"
for skill_dir in "$HOME/dotfiles/.agents/skills"/*(/N); do
  link="$HOME/.codex/skills/$(basename "$skill_dir")"
  if [[ -e "$link" && ! -L "$link" ]]; then
    echo "skip $link (not a symlink)"
    continue
  fi
  ln -sfn "$skill_dir" "$link"
done

# linearmouse
linearmouse_config="$HOME/dotfiles/linearmouse/linearmouse.json"
if [[ -f "$linearmouse_config" ]]; then
  mkdir -p $HOME/.config/linearmouse
  \rm -rf $HOME/.config/linearmouse/linearmouse.json
  ln -s "$linearmouse_config" $HOME/.config/linearmouse/linearmouse.json
fi

cargo_config="$HOME/dotfiles/.cargo/config.toml"
if [[ -f "$cargo_config" ]]; then
  mkdir -p $HOME/.cargo
  \rm -rf $HOME/.cargo/config.toml
  ln -s "$cargo_config" $HOME/.cargo/config.toml
fi
