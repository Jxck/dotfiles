#!/usr/bin/env ruby

names = DATA.read.downcase.split("\n")

result = names.select{|name|
    # これらの文字を含まない
    !(
        name.include?("l") ||
        name.include?("q") ||
        name.include?("v") ||
        name.include?("x") ||
        name.include?(".") ||
        name.include?(",")
    )
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

p result

# example https://lists.w3.org/Archives/Public/www-style/2017Dec/0004.html
__END__
