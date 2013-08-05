###################
# intall node.js
###################

# install nodebrew
wget git.io/nodebrew
perl nodebrew setup
rm nodebrew
NODE_PATH='export PATH=$HOME/.nodebrew/current/bin:$PATH'
eval $NODE_PATH
echo $NODE_PATH >> ~/.bashrc
# install node
nodebrew install stable
nodebrew use stable
