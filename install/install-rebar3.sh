LOCAL=$DOTFILES/local
PKG=$DOTFILES/pkg

cd $PKG
ghbin erlang/rebar3

mkdir $LOCAL/rebar3
mv $PKG/rebar3 $LOCAL/rebar3
chmod +x $LOCAL/rebar3/rebar3
