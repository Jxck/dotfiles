base = Time.mktime(2013, 3, 21, 20, 23, 50)
7.downto(1) {|n|
  base += 911
  dates = base.strftime "%Y-%m-%d %H:%M:%S +0900"
  command = <<-EOS
  git filter-branch --force --env-filter '
    export GIT_AUTHOR_DATE="#{dates}"
    export GIT_COMMITTER_DATE="#{dates}"
  ' HEAD~#{n}..HEAD
  EOS
  puts command
}

# git update-ref -d refs/original/refs/heads/X-branch
