brew install gh

# if [[ `uname` == "Linux" ]]; then
#   curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
#   sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
#   echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
#   sudo apt update
#   sudo apt install gh
# elif [[ `uname` == "Darwin" ]]; then
#   brew install gh
# fi

# cd $DOTFILES/pkg
# rm -rf $DOTFILES/pkg/gh-cli
# rm -rf $DOTFILES/local/gh-cli
# git clone --depth 1 https://github.com/cli/cli.git gh-cli
# cd gh-cli
# mkdir $DOTFILES/local/gh-cli
# make install prefix=$DOTFILES/local/gh-cli
