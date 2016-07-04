#cd $DOTFILES/pkg
#DEST=$DOTFILES/pkg/rebar3
#rm -rf $DEST
#ghlatest erlang/rebar3
#cd $DEST
#./bootstrap
#./rebar3 local install
#cd $DOTFILES/bin
#rm -rf ./rebar3
#ln -s $HOME/.cache/rebar3/bin/rebar3 .

cd $DOTFILES/bin
DEST=$DOTFILES/bin/rebar3
rm -rf $DEST
wget https://s3.amazonaws.com/rebar3/rebar3
chmod a+x ./rebar3
