DEST=$DOTFILES/local/certbot-auto
rm -rf $DEST
mkdir $DEST
cd $DEST
wget https://dl.eff.org/certbot-auto
chmod a+x ./certbot-auto
./certbot-auto --help
