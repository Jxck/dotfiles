dotfiles=".vimrc .vim .gitconfig .gitignore_global .zshrc .tmux.conf .hgrc .npmrc"
for dotfile in $dotfiles
do
  ln -s "$DOTFILES/$dotfile" $HOME
done

ln -s "$DOTFILES/bin/.gobrew" "$HOME/.gobrew"
