for FILE in `git ls-files`; do
  LOG=`git log --pretty=format:%ci -n1 $FILE`
  TIME=`date -d "$LOG" +"%y%m%d%H%M.%S"`
  echo "$FILE': \t'$LOG'\t'$TIME"
  touch -t $TIME $FILE
done
