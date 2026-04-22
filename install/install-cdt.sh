#!/usr/bin/env zsh

# install https://github.com/Jxck/cdt-toolkit
# prebuilt binary release, extract into $DOTFILES/local/cdt
# always fetches the latest release

case `uname` in
  Darwin)
    target_os="apple-darwin"
    case `uname -m` in
      arm64|aarch64) arch="aarch64" ;;
      x86_64)        arch="x86_64"  ;;
      *) echo "unsupported arch on Darwin: `uname -m`"; exit 1 ;;
    esac
    ;;
  Linux)
    target_os="unknown-linux-gnu"
    case `uname -m` in
      x86_64) arch="x86_64" ;;
      *) echo "unsupported arch on Linux: `uname -m`"; exit 1 ;;
    esac
    ;;
  *)
    echo "unsupported os: `uname`"; exit 1
    ;;
esac

version=`gh release view -R Jxck/cdt-toolkit --json tagName -q .tagName`
archive="cdt-${version}-${arch}-${target_os}.tar.gz"

rm -rf $DOTFILES/local/cdt
mkdir -p $DOTFILES/local/cdt/bin
cd $DOTFILES/local/cdt

gh release download -R Jxck/cdt-toolkit --pattern $archive
gh release download -R Jxck/cdt-toolkit --pattern "${archive}.sha256"

shasum -a 256 -c "${archive}.sha256"

tar zxf $archive --strip-components=1
mv cdt bin/cdt
rm $archive "${archive}.sha256"
