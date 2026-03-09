#!/usr/bin/env zsh

# revert file access time to git log
if [[ $(uname) == "Darwin" ]]; then
  DATECMD=gdate
else
  DATECMD=date
fi

git ls-files -- ${1:-.} | grep -e '\.md$' -e '\.js$' -e '\.css$' -e '\.svg$' -e '\.png$' -e '\.jpeg$' -e '\.webp$' \
  | xargs -P4 -I{} zsh -c '
    FILE=$1
    DATECMD=$2
    LOG=$(git log --pretty=format:%ci -n1 "$FILE")
    TIME=$($DATECMD -d "$LOG" +"%y%m%d%H%M.%S")
    echo "$LOG\t$TIME\t$FILE"
    touch -t $TIME "$FILE"
  ' _ {} $DATECMD
