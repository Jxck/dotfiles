#!/usr/bin/env zsh

# remove unused dotfiles at $HOME

target_files="
.apport-ignore.xml
.babel.json
.bash_history
.bashrc
.boto
.calc_history
.cydec_repo
.dbshell
.dbus
.degit
.DS_Store
.esd_auth
.evolution
.faastjs
.gconf
.gconfd
.gnome
.gnome2_private
.goutputstream*
.gstreamer-0.10
.gtk-bookmarks
.hawtjni
.irb_history
.lesshst
.nautilus
.node_repl_history
.pulse
.pulse-cookie
.python_history
.recently-used.xbel*
.rnd
.swt
.thumbnails
.v8flags.*
.viminfo
.w3m
.wget-hsts
.Xauthority
.xsel.log
.xsession-errors
.xsession-errors.old
.zcompdump
canary_debuglog.txt
tmux-client-*.log
"

# remove listed files
for target in ${=target_files}
do
  echo "rm -rf $HOME/$target"
  rm -rf "$HOME/$target"
done

# remove broken symlink
for f in "$HOME"/*(N@D); do
  [[ -e "$f" ]] || { print -r -- "rm $f"; rm -f -- "$f"; }
done

# empty SSLKEYLOGFILE.log
if [ -f "$HOME/SSLKEYLOGFILE.log" ]; then
  cp /dev/null "$HOME/SSLKEYLOGFILE.log"
fi

# clean tool caches
if command -v npm >/dev/null; then
  npm cache clean --force || echo "npm cache clean failed"
fi

if command -v brew >/dev/null; then
  brew cleanup --prune=all -s || echo "brew cleanup failed"
fi

if command -v go >/dev/null; then
  go clean -cache || echo "go clean failed"
fi

if command -v deno >/dev/null; then
  deno clean || echo "deno clean failed"
fi

if command -v pnpm >/dev/null; then
  pnpm store prune || echo "pnpm store prune failed"
fi

if command -v bun >/dev/null; then
  bun pm cache rm || echo "bun cache clean failed"
fi

# shrink systemd journal logs when available
if command -v journalctl >/dev/null; then
  journalctl --vacuum-size=500M || echo "journalctl vacuum failed"
fi
