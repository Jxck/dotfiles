# 1 2 3 4 5 6 7 8
# 9 10 11 -7
# 12 13 14 +8
# 15 16 17 +7
# 18 19 20 +7
# 21 22 23 24
git filter-branch --force --env-filter '
d=$GIT_AUTHOR_DATE
d=`echo "@$d" | cut -c 1-11`
day=`date -d "$d" "+%Y-%m-%d %T +0900"`

echo $day


h=`date -d "$day" "+%H"`
a=`date -d "$day" "+%a"`

if test $a = Sat -o $a = Sun
then
  echo "noop"
elif test $h -le 8
then
  day=$day

elif test $h -le 11
then
  day=`date -d "$day 10 hour ago"`

elif test $h -le 14
then
  day=`date -d "$day 8 hour"`

elif test $h -le 17
then
  day=`date -d "$day 7 hour"`

elif test $h -le 20
then
  day=`date -d "$day 7 hour"`
fi

day=`date -d "$day" "+%Y-%m-%d %T +0900"`
echo $day

export GIT_AUTHOR_DATE="$day"
export GIT_COMMITTER_DATE="$day"
' HEAD

git filter-branch -f --commit-filter '
  GIT_AUTHOR_NAME="Jxck"
  GIT_AUTHOR_EMAIL="block.rxckin.beats@gmail.com"
  GIT_COMMITTER_NAME="Jxck"
  GIT_COMMITTER_EMAIL="block.rxckin.beats@gmail.com"
  git commit-tree "$@"
' HEAD

git gc