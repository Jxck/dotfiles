git filter-branch -f --commit-filter '
  GIT_AUTHOR_NAME="Jxck"
  GIT_AUTHOR_EMAIL="block.rxckin.beats@gmail.com"
  GIT_COMMITTER_NAME="Jxck"
  GIT_COMMITTER_EMAIL="block.rxckin.beats@gmail.com"
  git commit-tree "$@"
' HEAD~1..HEAD

git filter-branch --force --env-filter '
  export GIT_AUTHOR_DATE="2013-01-03 11:23:43 +0900"
  export GIT_COMMITTER_DATE="2013-01-03 11:23:43 +0900"
' HEAD~1..HEAD
