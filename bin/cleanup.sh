# http://library.gnome.org/admin/system-admin-guide/stable/appendixa-0.html.ja
# http://uguisu.skr.jp/Windows/setting.html

# ignore
# .config
# .gvfs
# .local

target_files="\
.DS_Store
.apport-ignore.xml
.babel.json
.cache
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
.lesshst
.nautilus
.node_repl_history
.pulse
.pulse-cookie
.recently-used.xbel*
.rnd
.swt
.thumbnails
.w3m
.xsel.log
.xsession-errors
.xsession-errors.old
"

for target in $target_files
do
  echo "rm -rf $HOME/$target"
  rm -rf "$HOME/$target"
done
