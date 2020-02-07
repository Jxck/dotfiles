# -*- coding: utf-8 -*-

## README: lint to /etc/xkeysnail
##         systemctl reload xkeysnil after update

import re
from xkeysnail.transform import *

# [Global modemap] Change modifier keys as in xmodmap
define_modmap({
    Key.CAPSLOCK:   Key.LEFT_CTRL,
    Key.LEFT_ALT:   Key.LEFT_META,
    Key.LEFT_META:  Key.LEFT_ALT,
    Key.RIGHT_ALT:  Key.RIGHT_META,
    Key.RIGHT_META: Key.RIGHT_ALT,
})

# Mac-like keybindings
define_keymap(lambda wm_class: wm_class not in ("Gnome-terminal"), {

    # CTRL
    K("C-b"): with_mark(K("left")),
    K("C-f"): with_mark(K("right")),
    K("C-p"): with_mark(K("up")),
    K("C-n"): with_mark(K("down")),
    K("C-h"): with_mark(K("backspace")),
    K("C-a"): with_mark(K("home")),
    K("C-e"): with_mark(K("end")),

    K("C-k"): [K("Shift-end"), K("C-x"), set_mark(False)], # Kill line

    # Command
    K("M-a"): K("C-a"), # select all
    K("M-x"): K("C-x"), # cut
    K("M-c"): K("C-c"), # copy
    K("M-v"): K("C-v"), # paste

    K("M-f"): K("C-f"), # find
    K("M-n"): K("C-n"), # new
    K("M-o"): K("C-o"), # open
    K("M-w"): K("C-w"), # close
    K("M-z"): K("C-z"), # undo
    K("M-s"): K("C-s"), # save

    K("M-g"): K("C-g"), # search next
    K("M-p"): K("C-p"), # print
    K("M-r"): K("C-r"), # reload

    K("M-t"): K("C-t"), # new tab
    K("M-Shift-t"): K("C-Shift-t"), # history tab
    K("M-l"): K("C-l"), # focus url

    K("M-EQUAL"): K("C-EQUAL"), # zoom
    K("M-MINUS"): K("C-MINUS"), # small
    K("M-KEY_0"): K("C-KEY_0"), # restore

}, "global keymap")


# Keybindings for Chrome
define_keymap(re.compile("Google-chrome"), {
    K("C-d"): K("delete"),
}, "Firefox and Chrome")
