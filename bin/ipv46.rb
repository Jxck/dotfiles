#!/usr/bin/env ruby
require 'ipaddr'

def ip(str)
  begin
    ip = IPAddr.new(str)
    return "ipv4" if ip.ipv4?
    return "ipv6" if ip.ipv6?
    return "other: #{str}"
  rescue
    return "other: #{str}"
  end
end

while line = gets
  puts ip(line.chomp)
end
