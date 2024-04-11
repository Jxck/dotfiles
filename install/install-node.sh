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


# zsh
# if [[ -f $DOTFILES/pkg/nodebrew/nodebrew ]]; then
#   export NODEBREW_ROOT=$DOTFILES/pkg/nodebrew
#   addToPath $NODEBREW_ROOT
#   addToPath $NODEBREW_ROOT/current/bin
#   out=`node -v`
#   . <(npm completion)

#   # always add path of $DOTFILES/node_modules/.bin before
#   addToPath $DOTFILES/node_modules/.bin

#   # always add path of current repo
#   addToPath ./node_modules/.bin

#   echo nodebrew $out
# fi