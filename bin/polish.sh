target="
無
様
用
有
時
出来
行
事
1
一
ご覧
参照
ください
"

for word in $target
do
  echo $word
  grep --color=always $word $1
  read Wait
  echo
  echo
done
