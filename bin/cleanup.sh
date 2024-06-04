# remove unused dotfiles at $HOME

# selected from below
# http://library.gnome.org/admin/system-admin-guide/stable/appendixa-0.html.ja
# http://uguisu.skr.jp/Windows/setting.html

# ignore
#  .config
#  .gvfs
#  .local

target_files="
.DS_Store
.apport-ignore.xml
.babel.json
.bash_history
.calc_history
.dbshell
.dbus
.esd_auth
.evolution
.gconf
.gconfd
.gnome
.gnome2_private
.goutputstream*
.gstreamer-0.10
.gtk-bookmarks
.irb_history
.lesshst
.lesshst
.nautilus
.node_repl_history
.node_repl_history
.pulse
.pulse-cookie
.python_history
.recently-used.xbel*
.rnd
.swt
.thumbnails
.v8flags.*
.w3m
.wget-hsts
.wget-hsts
.xsel.log
.xsession-errors
.xsession-errors.old
canary_debuglog.txt
tmux-client-*.log
"

for target in $target_files
do
  echo "rm -rf $HOME/$target"
  rm -rf "$HOME/$target"
done

cp /dev/null SSLKEYLOGFILE.log
