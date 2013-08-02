mkdir $HOME/.ssh
chmod 700 $HOME/.ssh
cd $HOME/.ssh
wget https://github.com/Jxck.keys authorized_keys
chmod 600 authorized_keys

sudo sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo /etc/init.d/ssh reload

sudo ufw default DENY
sudo ufw allow ssh
sudo ufw enable

sudo less /var/log/auth.log
