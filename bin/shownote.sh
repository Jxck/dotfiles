nkf --oc=utf-8 -d --overwrite $@
sed -i -e 's/ *$//g' $@
sed -i -e 's/^\* /- /g' $@
sed -i -e 's/^   \* /  - /g' $@
sed -i -e 's/^      \* /    - /g' $@
sed -i -e 's/^         \* /      - /g' $@
sed -i -e 's/^\(#.*\)/\n\1\n/g' $@
sed -i -e 's/________________//g' $@
sed -i -e 's/- \(https:\/\/.*\)/- <\1>/g' $@
singler $@
spacer $@
