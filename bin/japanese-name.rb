#!/usr/bin/env ruby

names = DATA.read.downcase.split("\n")

result = names.select{|name|
  # これらの文字を含まない
  !(name.match?(/(l|q|v|x|\.|,)/))
}.map{|name|
  # 名前と名字に分割
  name.split(" ")
}.select{|name|
  # ミドルネームなどが無い
  name.size <= 2
}.select{|name|
  # 名前/名字の最後は n か母音で終わる
  name.first.end_with?("a", "i", "u", "e", "o", "n") && name.last.end_with?("a", "i", "u", "e", "o", "n")
}.map{|name|
  name.join(" ")
}

puts result

__END__
