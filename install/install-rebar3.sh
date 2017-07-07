# install to /pkg via ghbin but move to /bin because 1 file
cd $DOTFILES/bin
rm rebar3
rm ../pkg/rebar3
ghbin erlang/rebar3
mv ../pkg/rebar3 ../bin
chmod +x rebar3

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
