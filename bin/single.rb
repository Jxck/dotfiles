#!/usr/bin/env ruby

HELP=<<EOS
replace double width symbol to single width
copy from browser sometime needs this

$ single.rb readme.md
EOS

arg = ARGV[0]

if arg == nil
  puts HELP
  exit 0
end

[
  ['”', '"' ],
  ['“', '"' ],
  ["’", "'" ],
  ["‘", "'" ],
  ["—", "-" ],
  ["｜", "|" ],
].each {|tar|
  `sed -i -e "s/\\#{tar[0]}/\\#{tar[1]}/" #{arg}`
}
