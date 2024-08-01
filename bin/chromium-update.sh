#!/usr/bin/env zsh

git rebase-update
gclient sync
git rebase HEAD main
autoninja -C out/Default blink_tests all_blink content_shell
