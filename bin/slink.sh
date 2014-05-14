#!/bin/sh
dotfiles=".vimrc .vim .emacs .gitconfig .gitignore .screenrc .zshrc .tmux.conf .hgrc"
for dotfile in $dotfiles
do
  ln -s "$HOME/dotfiles/$dotfile" $HOME
done

ln -s "$HOME/dotfiles/bin/.gobrew" "$HOME/.gobrew"
