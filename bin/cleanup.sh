# remove unused dotfiles at $HOME

# selected from below
# http://library.gnome.org/admin/system-admin-guide/stable/appendixa-0.html.ja
# http://uguisu.skr.jp/Windows/setting.html

# ignore
#  .config
#  .gvfs
#  .local

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

for target in $target_files
do
  echo "rm -rf $HOME/$target"
  rm -rf "$HOME/$target"
done

if [ -f "$HOME/SSLKEYLOGFILE.log" ]; then
  cp /dev/null "$HOME/SSLKEYLOGFILE.log"
fi
