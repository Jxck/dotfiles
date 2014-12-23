dotfiles=".vimrc .vim .gitconfig .gitignore .zshrc .tmux.conf .hgrc"
for dotfile in $dotfiles
do
  ln -s "$HOME/dotfiles/$dotfile" $HOME
done

ln -s "$HOME/dotfiles/bin/.gobrew" "$HOME/.gobrew"
