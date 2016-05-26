cd $DOTFILES/pkg
DEST=$DOTFILES/pkg/certbot
rm -rf $DEST
git clone https://github.com/certbot/certbot
cd certbot
./certbot-auto --help
