#!/usr/bin/env ruby
# SIMPLE RUBY ECHO SERVER EXAMPLE
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
