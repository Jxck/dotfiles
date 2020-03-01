#!/usr/bin/env ruby

def main(paths)
  paths.map{|path|
    File
      .read(path)
      .gsub(/\(http(.*?)\)/, '')
      .split(/\W+?/)
      .reject{|w|
        w == "" || w.match(/^[0-9]*$/)
      }
  }.flatten
   .sort
   .group_by(&:itself)
   .map{|k, v| "#{k}, #{v.count}"}
   .sort_by(&:downcase)
   .each{|s| puts(s)}
end

if __FILE__ == $0
  main(ARGV)
end

