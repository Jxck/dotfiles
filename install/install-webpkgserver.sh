# go get -u github.com/google/webpackager/cmd/webpkgserver

DEST=$DOTFILES/pkg/webpkgserver
rm -rf $DEST
mkdir $DEST
cd $DEST

rm -rf $DOTFILES/local/webpkgserver

git clone --depth 1 https://github.com/google/webpackager
cd webpackager/cmd/webpkgserver
go build .
cd ..
mv -f webpkgserver $DOTFILES/local
