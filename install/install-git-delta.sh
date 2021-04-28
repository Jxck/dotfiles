if [[ `uname` == "Darwin" ]]; then
  echo "install via brew"
  exit 0
fi

curl -L https://github.com/dandavison/delta/releases/download/0.1.1/git-delta_0.1.1_amd64.deb -o "/tmp/git-delta_0.1.1_amd64.deb"
sudo dpkg -i /tmp/git-delta_0.1.1_amd64.deb
