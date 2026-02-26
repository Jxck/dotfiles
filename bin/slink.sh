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

cargo_config="$HOME/dotfiles/.cargo/config.toml"
if [[ -f "$cargo_config" ]]; then
  mkdir -p $HOME/.cargo
  \rm -rf $HOME/.cargo/config.toml
  ln -s "$cargo_config" $HOME/.cargo/config.toml
fi

for dotfile in $dotfiles
do
  \rm -rf $HOME/$dotfile
  ln -s "$HOME/dotfiles/$dotfile" $HOME
done