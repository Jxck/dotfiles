# revert file access time to git log
for FILE in `git ls-files`; do
  LOG=`git log --pretty=format:%ci -n1 $FILE`

  if [ `uname` == 'Darwin' ]; then
    TIME=`date -jf "%Y-%m-%d %H:%M:%S" "$LOG" "+%y%m%d%H%M.%S"`
  else
    TIME=`date -d "$LOG" +"%y%m%d%H%M.%S"`
  fi

  echo "$FILE': \t'$LOG'\t'$TIME"
  touch -t $TIME $FILE
done
