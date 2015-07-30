#!/usr/bin/env ruby

# websocketd --port 8888 echo.rb

STDOUT.sync = true

loop do
  line = STDIN.readline.strip
  puts line
end
