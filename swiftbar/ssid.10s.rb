#!/usr/bin/env ruby
# <xbar.title>Wi-Fi SSID (ipconfig getsummary)</xbar.title>
# <xbar.author>Jxck</xbar.author>
# <xbar.desc>Get current Wi-Fi SSID using ipconfig getsummary</xbar.desc>
# <xbar.version>v1.0</xbar.version>
# <xbar.dependencies>ruby</xbar.dependencies>

output = `ipconfig getsummary en0 2>/dev/null`
line = output
        .split("\n")
        .map{|line| line.strip }
        .filter{|line| line.start_with?("SSID") }

if line
  puts line.first.split(":").last.strip[0, 4]
else
  puts ""
end