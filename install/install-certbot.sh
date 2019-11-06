# DEST=$DOTFILES/local/certbot-auto
# rm -rf $DEST
# mkdir $DEST
# cd $DEST
# wget https://dl.eff.org/certbot-auto
# chmod a+x ./certbot-auto
# ./certbot-auto --help

sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot
sudo apt update
sudo apt install certbot
