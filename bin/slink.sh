dotfiles="
.vimrc
.vim
.gemrc
.gitconfig
.gitignore_global
.zshrc
.zprofile
.tmux.conf
.npmrc
.hyper.js
"

for dotfile in $dotfiles
do
  rm $HOME/$dotfile
  ln -s "$HOME/dotfiles/$dotfile" $HOME
done
