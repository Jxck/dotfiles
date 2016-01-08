dotfiles=".vimrc .vim .gitconfig .zshrc .tmux.conf .hgrc"
for dotfile in $dotfiles
do
  ln -s "$DOTFILES/$dotfile" $HOME
done

ln -s "$DOTFILES/bin/.gobrew" "$HOME/.gobrew"
