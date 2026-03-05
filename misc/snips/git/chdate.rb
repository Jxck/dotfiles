#!/usr/bin/ruby

n = ARGV.shift

target = `git log --pretty=format:%H -#{n}`
target = target.split(' ').map {|e| "$GIT_COMMIT = #{e}" }.join(" -o ")

target.each do |h|
  utime = Time.now - rand(1000)
  command=<<-EOS
  git filter-branch --force --env-filter \
  'if test #{target} ; then
    export GIT_AUTHOR_DATE="#{utime}"
    export GIT_COMMITTER_DATE="#{utime}"
  fi'
  EOS
  system(command)
end

`git update-ref -d refs/original/refs/heads/master`
