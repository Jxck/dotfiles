###################
# intall rust
###################

RUSTUP_HOME=$HOME/.rustup
CARGO_HOME=$HOME/.cargo

rm -rf $RUSTUP_HOME
rm -rf $CARGO_HOME

curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path
rustup component add rustfmt-preview
