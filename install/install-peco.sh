###################
# intall peco
###################

cd $DOTFILES/pkg

DEST=$DOTFILES/pkg/peco
rm -rf $DEST

if [ `uname` = "Linux" ]; then
  PLATFORM="peco_linux_amd64"
elif [ `uname` = "Darwin" ]; then
  PLATFORM="peco_darwin_amd64"
fi

PECO_URL="https://api.github.com/repos/peco/peco/releases"
PECO_LATEST=`curl $PECO_URL | jq '.[0]["assets"] | .[] | .browser_download_url' | grep $PLATFORM`
echo $PECO_LATEST | xargs curl -L -O

if [ `uname` = "Linux" ]; then
  echo $PLATFORM.tar.gz | xargs tar zxvf
  mv $PLATFORM $DEST
  rm -rf $PLATFORM.tar.gz
elif [ `uname` = "Darwin" ]; then
  echo $PLATFORM.zip | xargs unzip peco
  mv $PLATFORM $DEST
  rm -rf $PLATFORM.zip
fi
