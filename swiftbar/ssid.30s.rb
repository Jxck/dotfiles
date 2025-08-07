#!/usr/bin/env ruby
# <xbar.title>Wi-Fi SSID (ipconfig getsummary)</xbar.title>
# <xbar.author>Jxck</xbar.author>
# <xbar.desc>Get current Wi-Fi SSID using ipconfig getsummary</xbar.desc>
# <xbar.version>v1.0</xbar.version>
# <xbar.dependencies>ruby</xbar.dependencies>

output = `system_profiler SPAirPortDataType | grep 'Current Network' -A 1`
line = output.split("--").first.split("\n").last.strip

if line
  puts line.strip[0,4]
else
  puts ""
end
