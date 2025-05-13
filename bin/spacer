#!/usr/bin/env ruby

########################################
# HELP
########################################

HELP=<<EOS
add or remove space between double width Japanese
and single width English
with consider about markdown syntax

$ space.rb -r  README.md # remove
$ space.rb -a  README.md # add
$ space.rb -ra README.md # remove -> add
$ space.rb     README.md # equiv with -ra
EOS

require "optparse"

opts = ARGV.getopts("rah")
if opts["h"]
  puts HELP
  exit 0
end


########################################
# Main
########################################

def removeSpace(str)
  # "a あ" => "aあ"
  str.gsub!(/([a-zA-Z0-9]) ([^[:ascii:]])/) {
    "#{$1}#{$2}"
  }
  # "あ a" => "あa"
  str.gsub!(/([^[:ascii:]]) ([a-zA-Z0-9])/) {
    "#{$1}#{$2}"
  }
  return str
end

def addSpace(str)
  # "aあ" => "a あ"
  str.gsub!(/([a-zA-Z0-9])([^[:ascii:]])/) {
    if $2 === "」"
      "#{$1}#{$2}"
    else
      "#{$1} #{$2}"
    end
  }
  # "あa" => "あ a"
  str.gsub!(/([^[:ascii:]])([a-zA-Z0-9])/) {
    if $1 === "「"
      "#{$1}#{$2}"
    else
      "#{$1} #{$2}"
    end
  }
  return str
end

def process(data)
  result = ""
  state = ""
  data.lines{|line|
    if line.size == 1
      result << line
      next
    end

    # ```
    if line.match("```.*")
      if state == "```"
        state = ""
      else
        state = "```"
      end
      result << line
      next
    end

    if state == "```"
      result << line
      next
    end

    # #
    h = line.match(/^(\#{1,6}) (.*)/)
    if h
      result << "#{h[1]} #{yield(h[2])}\n"
      next
    end

    # -
    ul = line.match(/^( *-) (.*)/)
    if ul
      result << "#{ul[1]} #{yield(ul[2])}\n"
      next
    end

    # +
    ol = line.match(/^( *\+) (.*)/)
    if ol
      result << "#{ol[1]} #{yield(ol[2])}\n"
      next
    end

    # 1.
    num = line.match(/^( *\d*\.) (.*)/)
    if num
      result << "#{num[1]} #{yield(num[2])}\n"
      next
    end

    result << yield(line)
  }
  return result
end

if __FILE__ == $0
  targets = ARGV # file paths without option flags

  targets.each do |target|
    path = File.absolute_path(target)
    data = File.read(path)
    result = process(data) {|str|
      if opts["r"] == false && opts["a"] == false
        str = removeSpace(str)
        str = addSpace(str)
      end
      if opts["r"]
        str = removeSpace(str)
      end
      if opts["a"]
        str = addSpace(str)
      end

      str
    }

    if data != result
      puts "update #{target}"
      File.write(path, result)
    end
  end
end

# Export functions
module Spacer
  module_function :removeSpace, :addSpace, :process
end


__END__
ほげほげ?
aaaa
ほげ(ふが)ぴよ[おい]あ'い'う"え"お!

あ「invalid input」的
あ <invalid input> 的
あ `invalid input` 的

aaa ほげ bbb

```ruby
puts("aaa ほげ bbb")
puts("aaa ほげ bbb")
```

# ccc ひげ

- u あ asf い u
  - u あ asf い u
+ u あ asf い u
  + u あ asf い u


##### ddd ふぁ sd ふぁ

1. kk あおい
2. あいう jjj
10. ff a
100. ff a
