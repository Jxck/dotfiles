#!/usr/bin/env zsh

if [[ `uname` == "Darwin" ]]; then
  echo "install via brew"
  exit 0
fi

cd $DOTFILES/pkg
rm -rf $DOTFILES/pkg/brotli
rm -rf $DOTFILES/local/brotli
gh release download -R google/brotli --archive tar.gz --output brotli.tar.gz
result=`unpack brotli.tar.gz`
echo $result
version=`echo $result | head -n2 | tail -n1`
mv $version brotli
cd $DOTFILES/pkg/brotli
mkdir $DOTFILES/local/brotli
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$DOTFILES/local/brotli
cmake --build . --config Release --target install
