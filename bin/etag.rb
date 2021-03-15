#!/usr/bin/env ruby

def etag(path)
  mtime = File.mtime(path)
  size  = File.size(path)
  sprintf("%08x-%x", mtime, size)
end

if __FILE__ == $0
  puts ARGV.map{|path| etag(path)}
end
