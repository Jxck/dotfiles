dotfiles=".vimrc .vim .gemrc .gitconfig .gitignore_global .zshrc .tmux.conf .hgrc .npmrc"
for dotfile in $dotfiles
do
  ln -s "$HOME/dotfiles/$dotfile" $HOME
done

mkdir -p "$HOME/.config/rebar3"
ln -s "$DOTFILES/snips/erlang/rebar3/templates" "$HOME/.config/rebar3"
