#!/usr/bin/env ruby

def main(path)
  text = File.read(path)
    .gsub(/\\\-/, "-")
    .gsub(/\\\_/, "_")
    .gsub(/\\\=/, "=")
    .gsub(/\\\>/, ">")
    .gsub(/\\\#/, "#")
    .gsub(/\\\&/, "&")
    .gsub(/\\\!/, "!")
    .gsub(/\\\[/, "[")
    .gsub(/\\\]/, "]")
    .gsub(/\\\(/, "(")
    .gsub(/\\\)/, ")")
    .gsub(/\\\./, ".")
    .gsub(/^\*/, "-")
    .gsub(/^  \*/, "  -")
    .gsub(/^    \*/, "    -")
    .gsub(/^      \*/, "      -")
    .gsub(/^        \*/, "        -")
    .gsub(/ +$/, "")

  File.write(path, text)
end

if __FILE__ == $0
  ARGV.each{|path|
    main(path)
  }
end

