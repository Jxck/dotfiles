#!/bin/bash -xe
FILE=mozaic-ep63.mp3
TITLE="ep63 Cross Origin Info Leaks"
TRACK=70

eyeD3 --remove-all $FILE

eyeD3 --title "$TITLE"                      \
      --track $TRACK                        \
      --artist 'Jxck'                       \
      --album 'mozaic.fm'                   \
      --genre 'Podcast'                     \
      --add-image ./mozaic.jpeg:FRONT_COVER \
      --to-v2.3                             \
      $FILE
