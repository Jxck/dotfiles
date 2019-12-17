#!/usr/bin/env ruby

def main(paths)
  paths.map{|path|
    File
      .read(path)
      .split(/\W+?/)
      .reject{|w| w == ""}
  }.flatten
    .sort
    .group_by(&:itself)
    .map{|k, v| [v.count, k]}
    .sort
    .reverse
    .each{|k, v|
      puts "#{k}: #{v}"
    }
end

if __FILE__ == $0
  main(ARGV)
end

