#!/usr/bin/env zsh

readonly BROTLI_REV="779a49bfd67793f64b43015a85bc5965fba2063f"

\rm -rf $DOTFILES/pkg/shared-brotli
mkdir $DOTFILES/pkg/shared-brotli
cd $DOTFILES/pkg/shared-brotli

git clone https://github.com/google/brotli.git
cd brotli
#git checkout $BROTLI_REV
bazel build brotli
cd research
bazel build dictionary_generator
