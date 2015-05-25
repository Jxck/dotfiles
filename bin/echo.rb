#!/usr/bin/env ruby

# websocketd --port 8888 echo.rb

def say(msg)
  STDOUT.puts msg
  STDOUT.flush
end

def input
  STDIN.gets.chomp
end

say 'websocket echo'
command = ''
while command != 'exit'
  command = input
  say command
end
