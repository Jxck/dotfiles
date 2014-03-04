#!/bin/sh
dotfiles=".vimrc .vim .emacs .gitconfig .gitignore .screenrc .zshrc .tmux.conf .hgrc"
for dotfile in $dotfiles
do
  ln -s "$HOME/dotfiles/$dotfile" $HOME
done

ln -s "$HOME/dotfiels/bin/.gobrew/bin/gobrew" $HOME
