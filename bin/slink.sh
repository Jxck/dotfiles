dotfiles="
  .gemrc
  .gitattributes
  .gitconfig
  .gitignore_global
  .hyper.js
  .npmrc
  .tmux.conf
  .vim
  .vimrc
  .zprofile
  .zshrc
"

for dotfile in $dotfiles
do
  \rm -rf $HOME/$dotfile
  ln -s "$HOME/dotfiles/$dotfile" "$HOME/$dotfile"
done

# .claude/ と .codex/ の中身を ~/. 以下に slink
for dir in .claude .codex; do
  src="$HOME/dotfiles/$dir"
  dst="$HOME/$dir"
  if [[ -d "$src" ]]; then
    mkdir -p "$dst"
    for file in "$src"/*; do
      name=$(basename "$file")
      \rm -rf "$dst/$name"
      ln -s "$file" "$dst/$name"
    done
  fi
done

cargo_config="$HOME/dotfiles/.cargo/config.toml"
if [[ -f "$cargo_config" ]]; then
  mkdir -p $HOME/.cargo
  \rm -rf $HOME/.cargo/config.toml
  ln -s "$cargo_config" $HOME/.cargo/config.toml
fi