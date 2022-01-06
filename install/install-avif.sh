#!/usr/bin/env zsh

sudo apt install -y \
  zlib1g-dev \
  libpng-dev \
  libjpeg-dev \
  ninja-build \
  yasm \


cd $DOTFILES/pkg
rm -rf $DOTFILES/pkg/libavif
rm -rf $DOTFILES/local/libavif
git clone --depth=1 https://github.com/AOMediaCodec/libavif.git
cd libavif/ext
./aom.cmd
cd ..
mkdir build
cd build
cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=0 \
  -DAVIF_CODEC_AOM=1 \
  -DAVIF_LOCAL_AOM=1 \
  -DAVIF_BUILD_APPS=1 ..
make


# sudo apt install libaom-dev
# go install github.com/Kagami/go-avif/cmd/avif@latest

# npm install avif
