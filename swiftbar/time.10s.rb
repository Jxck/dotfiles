#!/usr/bin/env ruby


days = %w[日 月 火 水 木 金 土]
now = Time.now
formatted = now.strftime("%Y-%m-%d(#{days[now.wday]}) %H:%M")
puts formatted