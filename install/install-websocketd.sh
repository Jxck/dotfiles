OWNER=joewalnes
REPO=websocketd
PLATFORM=linux_amd64.zip

VERSION=`curl -L https://github.com/$OWNER/$REPO/releases/latest | grep releases/tag | grep -o -e v[0-9]*\.[0-9]*\.[0-9]* | sed -e 's/v//g'`

curl -L -o /tmp/websocketd-$VERSION-$PLATFORM https://github.com/$OWNER/$REPO/releases/download/v$VERSION/websocketd-$VERSION-$PLATFORM
unzip -o /tmp/websocketd-$VERSION-$PLATFORM -d /tmp

cp /tmp/websocketd $DOTFILES/bin
