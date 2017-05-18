#!/usr/bin/env ruby

HELP=<<EOS
add or remove space between double width Japanese
and single width English
with consider about markdown syntax

$ space.rb -r  README.md # remove
$ space.rb -a  README.md # add
$ space.rb -ra README.md # remove -> add
$ space.rb     README.md # equiv with -ra
EOS

def process(data)
  acc = []
  current = []
  state = ""
  data.each_line{|line|
    p line

    # ```
    if line.match("```.*")
      current << line
      if state == "```"
        acc << current
        state = ""
        current = []
      else
        state = "```"
      end
      next
    end

    if state == "```"
      current << line
      next
    end

    if line == "\n"
      next
    end

    ## #
    #h = line.match(/^(\#{1,6}) (.*)/)
    #if h
    #  result << "#{h[1]} #{yield(h[2])}\n"
    #  next
    #end

    ## -
    #ul = line.match(/^( *-) (.*)/)
    #if ul
    #  result << "#{ul[1]} #{yield(ul[2])}\n"
    #  next
    #end

    ## +
    #ol = line.match(/^( *\+) (.*)/)
    #if ol
    #  result << "#{ol[1]} #{yield(ol[2])}\n"
    #  next
    #end

    ## 1.
    #num = line.match(/^( *\d*\.) (.*)/)
    #if num
    #  result << "#{num[1]} #{yield(num[2])}\n"
    #  next
    #end

    #result << yield(line)
  }
  return acc
end

require "optparse"

opts = ARGV.getopts("raht")
targets = ARGV

if opts["h"]
  puts HELP
  exit 0
end

if opts["t"]
  p process(DATA)
  exit 0
end

targets.each do |target|
  path = File.absolute_path(target)
  data = File.read(path)
  acc = process(data)
  puts "update #{target}"
  File.write(path, result)
end


#  __END__
#  # title
#  ## h2
#  aa bb cc
#  dd ee ff
#  gg hh ii
#  ## h2
#  ### h3
#  ```
#  console.log
#  ```
#  ```rb
#  def hoo()
#    puts "hoo"
#  end
#  ```
#  ## h2
#  - 1
#  - 2
#  - 3

__END__
```
console.log
```
```rb
def hoo()

  puts "hoo"
end
```
