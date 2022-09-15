function tmux_h() {
  cat <<EOF
C-s C-o  # swap pane
EOF
}

function zsh_h() {
  cat <<EOF
alias -g N="1>/dev/null 2>/dev/null"          # No Output
alias -g B="1>/dev/null 2>/dev/null &"        # Background
alias -g A="2>&1"                             # All (merge stdout/err)
alias -g C="2>&1 | color"                     # Color (All then colorize)
alias -g H="| xxd -g 1 -c 4"                  # Hex
alias -g V="2>&1 | vim -c 'au! CursorHold' -" # Vim from stdout
alias -g PP="|&pp"                            # PanicParse (golang)
alias -g S="| less -S"                        # Shorten long lines
alias -g T="| tee -a /dev/stderr"             # Tee to stderr
alias -g U="| sort | uniq -c | sort -nr"      # Count
alias -g W="| btee"                           # Window in browser
EOF
}

function less_h() {
  cat <<EOF
[line count] $ less -M
[show ansi]  $ less -R
[nowrap]     $ less -S
[tail -f]    $ Shift+F
[grep]       $ &word
[grep -v]    $ &!word
EOF
}

function git_h() {
  cat <<EOF
[push branch]  $ git push origin dev
[ck branch]    $ git checkout -b dev origin/dev
[del branch]   $ git push origin :dev
[sync branch]  $ git fetch --prune
[pull force]   $ git fetch --all && git reset --hard origin/master
[clone submod] $ git submodule init && git submodule update
[up submod]    $ git submodule foreach 'git pull origin master'
[patch]        $ git diff --no-prefix HEAD~ > my.patch
[apply]        $ patch -p0 < my.patch
[reset atime]  $ $DOTFILES/bin/git-touch.sh
[shallow]      $ git clone --depth 1 https://github.com/git/git
EOF
}

function grep_h() {
  cat <<EOF
[ignore]  $ grep -v
[only]    $ grep -o
[exclude] $ grep --exclude-dir=pkg
[no name] $ grep -h
[unicode] $ grep "$(printf '\uFE0F')" ./**/*.html
EOF
}

function sed_h() {
  cat <<EOF
[infile]  $ sed -i
[regexp]  $ sed -r
[replace] $ sed -ir 's/a/A/g' ./**/*.html
EOF
}

function find_h() {
  cat <<EOF
[name] $ find ./ -name *.md
[each] $ find ./ -name *.md | xargs -L 1 echo
EOF
}

function docker_h() {
  cat <<EOF
[build]     $ docker build -t name/image:1.1 .
[run]       $ docker run -d -p 3000:80 name/image:2.0
[nsenter]   $ docker run --rm -v /usr/local/bin:/target jpetazzo/nsenter
[enter]     $ docker-enter PID
EOF
}

function rbenv_h() {
  cat <<EOF
[gem]       $ rbenv exec gem install bundler
[init]      $ bundle init
[install]   $ bundle install --path vendor/bundle
[rails]     $ bundle exec rails new example --skip-bundle
EOF
}

function vim_h() {
  cat <<EOF
Window
[window rotate] <ctl-w> r
[window move]   <ctl-w> [k/j/h/l]
[to horizonal]  <ctl-w> K
[to vertical]   <ctl-w> H

Tab
[tab open]  <ctl-t><ctl-o>
[tab close] <ctl-t><ctl-c>
[tab next]  <ctl-t><ctl-n>
[tab prev]  <ctl-t><ctl-p>

CLI
$ vim +command +qall
$ vim -c 'Command' -c 'qa!'
EOF
}

function curl_h() {
  cat <<EOF
[show header]  --include
[ignore cert]  --insecure
[post]         -X POST -d 'aaa=bbb&ccc=ddd'
[post JSON]    -X POST -H "Content-Type: application/json" -d 'aaa=bbb&ccc=ddd'
EOF
}

function chrome_h() {
  cat <<EOF
$ git rebase-update
$ gclient sync
$ git checkout -b feature-2222222
$ git cl patch 2222222
$ autoninja -C out/Default chrome
EOF
}
