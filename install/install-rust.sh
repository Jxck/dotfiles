###################
# intall rust
###################

RUSTUP_HOME=$HOME/.rustup
CARGO_HOME=$HOME/.cargo

rm -rf $RUSTUP_HOME
rm -rf $CARGO_HOME

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
