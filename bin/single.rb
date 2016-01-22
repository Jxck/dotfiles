#!/usr/bin/env ruby

# replace double width symbol to single width
# (copy from browser sometime needs this)

[
  ['”', '"' ],
  ['“', '"' ],
  ["’", "'" ],
  ["‘", "'" ],
  ["—", "-" ],
  ["｜", "|" ],
].each {|tar|
  `sed -i -e "s/\\#{tar[0]}/\\#{tar[1]}/" #{ARGV[0]}`
}
