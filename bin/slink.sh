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
  ln -s "$HOME/dotfiles/$dotfile" $HOME
done