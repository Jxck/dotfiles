#!/usr/bin/env zsh

PKG=$DOTFILES/pkg/dictionary-generator
\rm -rf $PKG
mkdir -p $PKG
cd $PKG

# brotli
git clone --depth 1 https://github.com/google/brotli.git

# esaxx (header-only, required by deorummolae)
git clone --depth 1 https://github.com/hillbig/esaxx.git

# build
DIVSUFSORT=$(brew --prefix libdivsufsort)
cd brotli/research
g++ -O2 -std=c++11 \
  -I${DIVSUFSORT}/include \
  -I${PKG}/esaxx \
  -L${DIVSUFSORT}/lib \
  dictionary_generator.cc sieve.cc durchschlag.cc deorummolae.cc \
  -ldivsufsort \
  -Wl,-rpath,${DIVSUFSORT}/lib \
  -o ${PKG}/dictionary_generator
