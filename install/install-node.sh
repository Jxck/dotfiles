###################
# intall node.js
###################

# install nodebrew
wget git.io/nodebrew
perl nodebrew setup
rm nodebrew
NODE_PATH='export PATH=$HOME/.nodebrew/current/bin:$PATH'
eval $NODE_PATH

# install node
nodebrew install-binary stable
nodebrew use stable

# shim for shebang
# sudo ln -s $HOME/.nodebrew/current/bin/node /usr/local/bin
