#!/usr/bin/env zsh

# revert file access time to git log
for FILE in `git ls-files | grep -e '.md$' -e '.js$' -e '.css$' -e '.svg$' -e '.png$' -e '.jpeg$' -e '.webp$' `; do
  LOG=`git log --pretty=format:%ci -n1 $FILE`

  if [ `uname` = 'Darwin' ]; then
    TIME=`gdate -d "$LOG" +"%y%m%d%H%M.%S"`
  else
    TIME=`date  -d "$LOG" +"%y%m%d%H%M.%S"`
  fi

  echo "$LOG\t$TIME\t$FILE"
  touch -t $TIME $FILE
done
