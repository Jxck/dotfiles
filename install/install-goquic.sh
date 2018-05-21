if [ `uname` = "Linux" ]; then
  sudo apt install -y \
    build-essential       \
    cmake                 \
    ninja-build
elif [ `uname` = "Darwin" ]; then
  brew install cmake ninja
fi


cd $HOME
rm -rf $GOPATH/src/github.com/devsisters/goquic
git clone https://github.com/devsisters/goquic $GOPATH/src/github.com/devsisters/goquic
cd $GOPATH/src/github.com/devsisters/goquic
./build_libs.sh
go get github.com/bradfitz/http2
go get github.com/oleiade/lane
go get github.com/vanillahsu/go_reuseport

CGO_CFLAGS="-I$GOPATH/src/github.com/devsisters/goquic/libquic/boringssl/include" \
CGO_LDFLAGS="-L$GOPATH/src/github.com/devsisters/goquic/lib/darwin_amd64" \
go build $GOPATH/src/github.com/devsisters/goquic/example/server.go
