##########################
# intall docker
##########################

# Uninstall old versions
sudo apt-get remove docker docker-engine docker.io containerd runc

# SET UP THE REPOSITORY
sudo apt-get update

sudo apt-get install \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

# INSTALL DOCKER ENGINE
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

sudo apt-cache madison docker-ce

VERSION_STRING="5:19.03.13~3-0~ubuntu-focal"
sudo apt-get install docker-ce=$VERSION_STRING docker-ce-cli=$VERSION_STRING containerd.io

# Hello World
sudo docker run hello-world


# OLD
#sudo apt install apt-transport-https ca-certificates
#sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
#echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list
#sudo apt update
#apt-cache policy docker-engine
#sudo apt install linux-image-extra-$(uname -r) linux-image-extra-virtual
#sudo apt update
#sudo apt install docker-engine
#sudo service docker start
#sudo groupadd docker
#sudo usermod -aG docker $USER


###########################
## intall docker-compose
###########################

#curl -L "https://github.com/docker/compose/releases/download/1.8.1/docker-compose-$(uname -s)-$(uname -m)" > $DOTFILES/bin/docker-compose
#chmod +x $DOTFILES/bin/docker-compose
