#!/usr/bin/env ruby

def sizes(path, opts)
  name = File.basename(path)
  size = File.size(path)

  unless opts["h"]
    # raw
    return "#{size.to_s.rjust(6)}\t#{name}"
  end

  # human readable
  if size > 1024*1024
    size = size.quo(1024*1024).round(1).to_f.to_s + "M"
  elsif size > 1024
    size = size.quo(1024).round(1).to_f.to_s + "K"
  else
    size = size.to_s + "B"
  end

  return "#{size.rjust(6)}\t#{name}"
end


if __FILE__ == $0
  require "pathname"
  require "optparse"

  opts = ARGV.getopts('h')
  paths = ARGV


  paths.map{|path|
    puts sizes(path, opts)
  }
end
