curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "/tmp/awscli-bundle.zip"
unzip /tmp/awscli-bundle.zip -d /tmp
/tmp/awscli-bundle/install -b $DOTFILES/bin/aws
rm -rf /tmp/awscli-bundle*
