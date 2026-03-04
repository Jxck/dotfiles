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
  [[ -e "$f" ]] || print -r -- "$f"
done

# empty SSLKEYLOGFILE.log
if [ -f "$HOME/SSLKEYLOGFILE.log" ]; then
  cp /dev/null "$HOME/SSLKEYLOGFILE.log"
fi
