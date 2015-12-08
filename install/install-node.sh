###################
# intall node.js
###################

DEST=$DOTFILES/pkg/nodebrew

# change nodebrew root to DEST
export NODEBREW_ROOT=$DEST

# install nodebrew
curl -L git.io/nodebrew | perl - setup
NODE_PATH='export PATH=$NODEBREW_ROOT/current/bin:$PATH'
eval $NODE_PATH

# install node
nodebrew install-binary stable
nodebrew use stable
