nkf --oc=utf-8 -d --overwrite $@
sed -i -e 's/ *$//g' $@
sed -i -e 's/^\* /- /g' $@
sed -i -e 's/^   \* /  - /g' $@
sed -i -e 's/^      \* /    - /g' $@
sed -i -e 's/^         \* /      - /g' $@
singler $@
spacer $@
