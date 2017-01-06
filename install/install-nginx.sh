cd $DOTFILES/pkg
DEST=$DOTFILES/pkg/nginx
rm -rf $DEST

cd /tmp
wget http://nginx.org/download/nginx-1.10.1.tar.gz
tar zxvf /tmp/nginx-1.10.1.tar.gz
mv /tmp/nginx-1.10.1 $DEST
cd $DEST

./configure --prefix=$DOTFILES/local/nginx

make
make install
