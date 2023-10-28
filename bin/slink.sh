dotfiles="
.vimrc
.vim
.gemrc
.gitconfig
.gitignore_global
.zshrc
.zprofile
.tmux.conf
.npmrc
.hyper.js
"

for dotfile in $dotfiles
do
  rm $HOME/$dotfile
  ln -s "$HOME/dotfiles/$dotfile" $HOME
done

mkdir -p "$HOME/.config/rebar3"
ln -s "$DOTFILES/snips/erlang/rebar3/templates" "$HOME/.config/rebar3"
