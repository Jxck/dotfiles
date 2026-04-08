#!/usr/bin/env zsh

\rm -rf $DOTFILES/pkg/dictionary-generator
mkdir $DOTFILES/pkg/dictionary-generator
cd $DOTFILES/pkg/dictionary-generator

git clone --depth 1 https://github.com/google/brotli.git
cd brotli
bazel build brotli
cd research
bazel build dictionary_generator
