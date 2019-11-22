\rm -rf $DOTFILES/pkg/webp
mkdir $DOTFILES/pkg/webp
cd $DOTFILES/pkg/webp

URL=https://storage.googleapis.com/downloads.webmproject.org/releases/webp/


if [ `uname` = "Linux" ]; then
  VERSION=libwebp-1.0.3-linux-x86-64
elif [ `uname` = "Darwin" ]; then
  VERSION=libwebp-1.0.3-mac-10.14
fi

wget $URL$VERSION.tar.gz
unpack $VERSION.tar.gz
mv $VERSION/bin .
\rm -rf $VERSION
\rm -rf $VERSION.tar.gz
