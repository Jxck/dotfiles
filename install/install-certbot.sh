cd $DOTFILES/bin
DEST=$DOTFILES/bin/certbot-auto
rm -rf $DEST
wget https://dl.eff.org/certbot-auto
chmod a+x ./certbot-auto
./certbot-auto --help
