# install
sudo apt install python3-pip
sudo pip3 install xkeysnail

# uinput グループを作り自分を追加
sudo groupadd uinput
sudo usermod -aG input,uinput yusuke

# uinput/event にアクセスできるように権限をコピー
sudo ln -sf $DOTFILES/conf/xkeysnail/input.rules /etc/udev/rules.d
sudo ln -sf $DOTFILES/conf/xkeysnail/uinput.rules /etc/udev/rules.d

# コンフィグがローカルにあるとパスが面倒なので /etc/xkeysnail にコピー
sudo mkdir /etc/xkeysnail
sudo ln -sf $DOTFILES/conf/xkeysnail/xkeysnail.py /etc/xkeysnail

# keysnail  への sudo に password 省略
echo "$USER ALL=(ALL) ALL, NOPASSWD: /usr/local/bin/xkeysnail" > /tmp/sudo-xkeysnail
chmod 0440 /tmp/sudo-xkeysnail
sudo chown root:root /tmp/sudo-xkeysnail
sudo mv /tmp/sudo-xkeysnail /etc/sudoers.d

# link systemd
ln -sf $DOTFILES/systemd/xkeysnail.service ~/.config/systemd/user

# start systemd
systemctl --user daemon-reload
systemctl --user enable xkeysnail
systemctl --user start xkeysnail
systemctl --user status xkeysnail
