#!/usr/bin/env zsh

rm -rf $DOTFILES/pkg/bazel
rm -rf $DOTFILES/local/bazel
mkdir $DOTFILES/pkg/bazel
mkdir $DOTFILES/local/bazel
cd $DOTFILES/pkg/bazel

gh release download -p '*linux-x86_64.sh' -R github.com/bazelbuild/bazel

files="./*.sh"
chmod +x ${~files}
echo "execute cmd below"
echo $DOTFILES/pkg/bazel/${~files} --prefix=$DOTFILES/local/bazel
