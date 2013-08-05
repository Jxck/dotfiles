###################
# intall node.js
###################

# install nodebrew
wget https://raw.github.com/hokaccha/nodebrew/master/nodebrew
perl nodebrew setup
rm nodebrew
NODE_PATH='export PATH=$HOME/.nodebrew/current/bin:$PATH'
eval $NODE_PATH
echo $NODE_PATH >> ~/.bashrc
# install node
nodebrew install v0.8.3
nodebrew use v0.8.3
