#!/bin/sh
dotfiles=".emacs .gitconfig .gitignore .screenrc .zshrc"
for dotfile in $dotfiles
do
  ln -s "$PWD/$dotfile" $HOME
done
