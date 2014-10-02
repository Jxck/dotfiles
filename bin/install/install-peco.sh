## install peco
if [ `uname` = "Linux" ]; then
  PLATFORM="peco_linux_amd64"
elif [ `uname` = "Darwin" ]; then
  PLATFORM="peco_darwin_amd64"
fi

DOT_BIN=$HOME/dotfiles/bin

if [[ -f $DOT_BIN/peco ]]; then
  rm $DOT_BIN/peco
fi

PECO_URL="https://api.github.com/repos/peco/peco/releases"
PECO_LATEST=`curl $PECO_URL | jq '.[0]["assets"] | .[] | .browser_download_url' | grep $PLATFORM`
echo $PECO_LATEST | xargs curl -L -O
echo $PLATFORM.zip | xargs unzip
mv $PLATFORM/peco $HOME/dotfiles/bin
\rm -rf $PLATFORM*
