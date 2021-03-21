#!/usr/bin/env ruby
require "pathname"

def etag(path)
  tag = sprintf("%08x-%x", File.mtime(path), File.size(path))
  ext = File.extname(path)
  path.sub(/#{ext}$/, ".#{tag}#{ext}")
end

if __FILE__ == $0
  puts ARGV.map{|path| etag(path)}
end
