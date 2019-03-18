LOCAL=$DOTFILES/local
PKG=$DOTFILES/pkg

\rm -rf $LOCAL/rebar3
\rm -rf $PKG/rebar3

cd $PKG
ghbin erlang/rebar3

mkdir $LOCAL/rebar3
mv $PKG/rebar3 $LOCAL/rebar3
chmod +x $LOCAL/rebar3/rebar3
