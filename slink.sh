#!/bin/sh
dotfiles=".vimrc .vim .emacs .gitconfig .gitignore .screenrc .zshrc .tmux.conf .hgrc"
for dotfile in $dotfiles
do
  ln -s "$PWD/$dotfile" $HOME
done
