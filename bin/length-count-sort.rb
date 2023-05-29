#!/usr/bin/env ruby

def main(lines)
  lines
    .group_by{|e| e}
    .map{|k, v| [v.length, k]}
    .sort{|a, b|
      a[0] <=> b[0]
    }
    .sort{|a, b|
      if a[0] == b[0]
        a[1].size <=> b[1].size
      else
        1
      end
    }
    .map{|e|
      "#{e[0]} #{e[1]}"
    }
end

if __FILE__ == $0
  puts main(STDIN.readlines)
end
