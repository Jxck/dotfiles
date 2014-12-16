# http://library.gnome.org/admin/system-admin-guide/stable/appendixa-0.html.ja
# http://uguisu.skr.jp/Windows/setting.html

# ignore
# .config/
# .gvfs/
# .local/

target_files="\
.cache/
.dbus/
.esd_auth
.evolution/
.gconf/
.gconfd/
.gnome/
.gnome2_private/
.goutputstream*
.gstreamer-0.10/
.gtk-bookmarks
.nautilus/
.pulse/
.pulse-cookie
.recently-used.xbel*
.swt/
.thumbnails/
.w3m/
.xsession-errors
.xsession-errors.old
.xsel.log
.rnd
.lesshst
.dbshell
.apport-ignore.xml
"

for target in $target_files
do
  echo "rm -rf $HOME/$target"
  rm -rf "$HOME/$target"
done
