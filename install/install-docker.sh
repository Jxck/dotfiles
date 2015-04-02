###################
# intall docker
###################

## check os
if [ ! `uname` = "Linux" ]; then
  echo "run this command on Ubuntu"
  exit 1
fi

## install docker
echo -n "install docker? (y/n): "
read install

if [ $install = "y" ]; then
  echo "run wget -qO- https://get.docker.com/ | sh"
  echo
  # wget -qO- https://get.docker.com/ | sh
  echo
fi

## add current user to docker group
echo -n "add current user to docker group? (y/n): "
read usergroup

if [ $usergroup = "y" ]; then
  echo "sudo usermod -aG docker `whoami`"
  echo
  # sudo usermod -aG docker `whoami`
  echo
fi

## edit docker file
echo -n "edit docker file? (y/n): "
read editdocker

if [ $editdocker = "y" ]; then
  echo "sudo vim /etc/default/docker"
  sudo vim /etc/default/docker
fi

## restart docker
echo -n "restart docker? (y/n): "
read restart

if [ $restart = "y" ]; then
  echo "sudo services docker docker"
  echo
  sudo service docker restart
fi

## install nsenter, docker-enter
echo -n "install nsenter/docker-enter? (y/n): "
read nsenter

if [ $nsenter = "y" ]; then
  echo "docker run --rm -v /usr/local/bin:/target jpetazzo/nsenter"
  echo
  docker run --rm -v /usr/local/bin:/target jpetazzo/nsenter
fi
