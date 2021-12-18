if [[ `uname` == "Linux" ]]; then
  sudo apt install -y ffmpeg
elif [[ `uname` == "Darwin" ]]; then
  brew install ffmpeg
fi
