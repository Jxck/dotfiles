#!/bin/sh
dotfiles=".emacs .gitconfig .gitignore .screenrc .zshrc"
for dotfile in $dotfiles
do
	ln -si "$PWD/$dotfile" $HOME
done
