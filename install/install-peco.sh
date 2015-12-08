###################
# intall peco
###################

if [ `uname` = "Linux" ]; then
  PLATFORM="peco_linux_amd64"
elif [ `uname` = "Darwin" ]; then
  PLATFORM="peco_darwin_amd64"
fi

if [ -f $DOTFILES/bin/peco ]; then
  rm $DOTFILES/bin/peco
fi

PECO_URL="https://api.github.com/repos/peco/peco/releases"
PECO_LATEST=`curl $PECO_URL | jq '.[0]["assets"] | .[] | .browser_download_url' | grep $PLATFORM`
echo $PECO_LATEST | xargs curl -L -O

if [ `uname` = "Linux" ]; then
  echo $PLATFORM.tar.gz | xargs tar zxvf
elif [ `uname` = "Darwin" ]; then
  echo $PLATFORM.zip | xargs unzip
fi

mv $PLATFORM/peco $DOTFILES/bin
\rm -rf $PLATFORM*
