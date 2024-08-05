#!/usr/bin/env zsh

echo "=========================="
echo git rebase-update
echo "=========================="
git rebase-update


echo "=========================="
echo gclient sync
echo "=========================="
gclient sync


echo "=========================="
echo git rebase HEAD main
echo "=========================="
git rebase HEAD main


echo "=========================="
echo autoninja -C out/Default blink_tests all_blink content_shell
echo "=========================="
autoninja -C out/Default blink_tests all_blink content_shell
