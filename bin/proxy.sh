#!/bin/bash

read -p  "user: " user
read -sp "pass: " pass
echo
read -p  "host: " host
read -p  "port: " port

echo "http://$user:*****@$host:$port"
confpath="$HOME/dotfiles/conf"

for f in `\ls -A $confpath`
do
  cat $confpath/$f |
  sed -e "s/{{user}}/$user/g" |
  sed -e "s/{{pass}}/$pass/g" |
  sed -e "s/{{host}}/$host/g" |
  sed -e "s/{{port}}/$port/g" > ~/$f
done

if [[ `uname` == "Darwin" ]]; then
  rm ~/apt.conf
elif [[ `uname` == "Linux" ]]; then
  sudo mv ~/apt.conf /etc/apt/apt.conf
fi
