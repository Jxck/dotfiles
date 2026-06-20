#!/usr/bin/env ruby
# <xbar.title>Wi-Fi SSID (preferred networks)</xbar.title>
# <xbar.author>Jxck</xbar.author>
# <xbar.desc>Show current Wi-Fi SSID via networksetup preferred network list</xbar.desc>
# <xbar.version>v1.0</xbar.version>
# <xbar.dependencies>ruby</xbar.dependencies>

# macOS 14.4+ では SSID が位置情報権限なしだと <redacted> になる
# (ipconfig / system_profiler / networksetup -getairportnetwork すべて redacted)。
# 回避策として優先ネットワーク一覧の先頭を現在の SSID とみなす。
# 注意: 「接続中が必ず先頭」は保証されてないが、動いてるからよしとしている。
output = `networksetup -listpreferredwirelessnetworks en0`

# 1 行目はヘッダ "Preferred networks on en0:"、2 行目以降がタブ字下げの SSID
ssid = output.lines.drop(1).map(&:strip).reject(&:empty?).first

puts ssid || ""
