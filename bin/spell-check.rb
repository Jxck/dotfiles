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
      .map(&:downcase)
  }.flatten
   .sort
   .group_by(&:itself)
   .sort
   .map{|k, v|
      if v.count <= 2 then
        "#{k}: \e[0;101m#{v.count}\e[0m"
      else
        "#{k}, #{v.count}"
      end
    }
   .each{|s| puts(s)}
end

if __FILE__ == $0
  main(ARGV)
end

