dotfiles=".vimrc .vim .gitconfig .gitignore_global .zshrc .tmux.conf .hgrc .npmrc"
for dotfile in $dotfiles
do
  ln -s "$HOME/dotfiles/$dotfile" $HOME
done
