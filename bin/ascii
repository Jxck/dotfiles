#!/usr/bin/env ruby

########################################
# HELP
########################################
HELP=<<EOS
convert ascii code from/to charactor

$ ascii hello world
   h    e    l    l    o
 104  101  108  108  111
0x68 0x65 0x6C 0x6C 0x6F

   w    o    r    l    d
 119  111  114  108  100
0x77 0x6F 0x72 0x6C 0x64


$ ascii 0x61 0x62 0x63
  97   98   99
   a    b    c

De Hx Char                           De Hx Char   De Hx Char  De  Hx Char
---------                            -----------  ----------  ------------
 0 00 NUL (null)                     32 20 SPACE  64 40  @     96 60  `
 1 01 SOH (start of heading)         33 21  !     65 41  A     97 61  a
 2 02 STX (start of text)            34 22  "     66 42  B     98 62  b
 3 03 ETX (end of text)              35 23  #     67 43  C     99 63  c
 4 04 EOT (end of transmission)      36 24  $     68 44  D    100 64  d
 5 05 ENQ (enquiry)                  37 25  %     69 45  E    101 65  e
 6 06 ACK (acknowledge)              38 26  &     70 46  F    102 66  f
 7 07 BEL (bell)                     39 27  '     71 47  G    103 67  g
 8 08  BS (backspace)                40 28  (     72 48  H    104 68  h
 9 09 TAB (horizontal tab)           41 29  )     73 49  I    105 69  i
10 0A  LF (NL line feed, new line)   42 2A  *     74 4A  J    106 6A  j
11 0B  VT (vertical tab)             43 2B  +     75 4B  K    107 6B  k
12 0C  FF (NP form feed, new page)   44 2C  ,     76 4C  L    108 6C  l
13 0D  CR (carriage return)          45 2D  -     77 4D  M    109 6D  m
14 0E  SO (shift out)                46 2E  .     78 4E  N    110 6E  n
15 0F  SI (shift in)                 47 2F  /     79 4F  O    111 6F  o
16 10 DLE (data link escape)         48 30  0     80 50  P    112 70  p
17 11 DC1 (device control 1)         49 31  1     81 51  Q    113 71  q
18 12 DC2 (device control 2)         50 32  2     82 52  R    114 72  r
19 13 DC3 (device control 3)         51 33  3     83 53  S    115 73  s
20 14 DC4 (device control 4)         52 34  4     84 54  T    116 74  t
21 15 NAK (negative acknowledge)     53 35  5     85 55  U    117 75  u
22 16 SYN (synchronous idle)         54 36  6     86 56  V    118 76  v
23 17 ETB (end of trans. block)      55 37  7     87 57  W    119 77  w
24 18 CAN (cancel)                   56 38  8     88 58  X    120 78  x
25 19  EM (end of medium)            57 39  9     89 59  Y    121 79  y
26 1A SUB (substitute)               58 3A  :     90 5A  Z    122 7A  z
27 1B ESC (escape)                   59 3B  ;     91 5B  [    123 7B  {
28 1C  FS (file separator)           60 3C  <     92 5C  \\    124 7C   |
29 1D  GS (group separator)          61 3D  =     93 5D  ]    125 7D  }
30 1E  RS (record separator)         62 3E  >     94 5E  ^    126 7E  ~
31 1F  US (unit separator)           63 3F  ?     95 5F  _    127 7F  DEL
EOS

if ARGV[0] == "-h" || ARGV.empty?
  puts HELP
  exit 0
end


########################################
# Main
########################################

# if args are array of hex
# convert each to ascii
if ARGV.first.start_with?("0x")
  args = ARGV.map{|c| c.to_i(0) }
  puts ARGV.join(" ")
  puts args.map{|c| c.to_s.rjust(4, ' ')}.join(" ")
  puts args.pack("c*").chars.map{|c| c.to_s.rjust(4, ' ')}.join(" ")
  exit 0
end

# if args are array of ascii
# convert each to decimal/hex
ARGV.each {|arg|
  puts arg.chars.map{|n| n.to_s.rjust(4, ' ') }.join(" ")
  puts arg.unpack("c*").map{|n| n.to_s.rjust(4, ' ') }.join(" ")
  puts arg.unpack("c*").map{|n| "0x" + n.to_i.to_s(16).upcase }.join(" ")
  puts
}
