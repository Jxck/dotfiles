# SHA256
$ echo "password2" | ruby -e "require 'digest/sha2'; p Digest::SHA256.hexdigest('$_')"

# show number of row
$ ruby -ne '$l ||= 1; $m=$l.to_s; $m="0"+$m if $m.size==1; puts "#{$m}: #{$_}"; $l+=1' test.js
01: var i = 0;
02: var j = 1000;
03: function hoge() {

$ grep -n '' test.js
1:var i = 0;
2:var j = 1000;
3:function hoge() {

# rendering markdown via github api
wget --header=Content-Type: text/plain --post-file=readme.md https://api.github.com/markdown/raw

# git server
git daemon --verbose --export-all --enable=receive-pack --base-path=./ 1>/dev/null &
