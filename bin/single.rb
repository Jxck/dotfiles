#!/usr/bin/env ruby

HELP=<<EOS
replace double width symbol to single width
copy from browser sometime needs this

$ singler readme.md
$ cat readme.md | singler > readme.md
EOS

arg = ARGV[0]

def replace(str)
  str
    .gsub('”', '"')
    .gsub('“', '"')
    .gsub("’", "'")
    .gsub("‘", "'")
    .gsub("—", "-")
    .gsub("｜", "|")
end

unless arg == nil
  formatted = replace(File.open(arg).read)
  File.write(arg, formatted)
  exit 0
end

unless STDIN.isatty
  while line = STDIN.gets
    STDOUT.print replace(line)
  end
  exit 0
end

puts HELP
