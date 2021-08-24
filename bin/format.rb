#!/usr/bin/env ruby

HELP=<<EOS
format markdown line break style

$ format.rb target.md
EOS

def label(line)
  case line
  when "";                      [:br,     "\n"]
  when /^---/;                  [:meta,   line] # zenn
  when /^\#{1,6} .*/;           [:header, line]
  when /^ *- .*/;               [:ul,     line]
  when /^ *\* .*/;              [:ul,     line]
  when /^ *\+ .*/;              [:ol,     line]
  when /^: .*/;                 [:dl,     line]
  when /^ *\d+\. .*/;           [:num,    line]
  when /^> /;                   [:blockquote, line]
  when /```.*/;                 [:code,   line]
  when /^\|.*/;                 [:table,  line]
  when /^<(?!http(s*):\/\/).*/; [:html,   line]
  when /^:::.*/;                [:message,line] # zenn
  else                          [:p,      line]
  end
end

def tokenize(data)
  data.split("\n").map(&method(:label))
end


class State
  attr_reader :acc
  def initialize
    @state = :start
    @acc = []
  end

  def start((key, val))
    if key == :meta
      # --- で始まるならメタ情報
      @acc << val
      @acc << "\n"
      @state = :meta
    else
      # 始まらないなら title があるはず
      @state = :title
      title([key, val])
    end
  end

  def meta((key, val))
    if key == :meta
      # meta が終わる
      @acc << val
      @acc << "\n\n"
      @state = :title
    else
      # そのまま
      @acc << val
      @acc << "\n"
    end
  end

  def title((key, val))
    if key == :header
      @acc << val
      @state = :body
    elsif key == :br
      # title より上の改行は無視
    else
      pp key, val
      raise "state error"
    end
  end

  def body((key, val))
    case key
    when :header;
      @acc << "\n\n\n"
      @acc << val
    when :p;
      @acc << "\n\n"
      @acc << val
    when :ul;
      @acc << "\n\n"
      @acc << val
      @state = :ul
    when :ol;
      @acc << "\n\n"
      @acc << val
      @state = :ol
    when :dl;
      @acc << "\n"
      @acc << val.sub(/: +/, ": ")
      @state = :dl
    when :num;
      @acc << "\n\n"
      @acc << val
      @state = :num
    when :blockquote;
      @acc << "\n\n"
      @acc << val
      @state = :blockquote
    when :code;
      @acc << "\n\n\n"
      @acc << val
      @state = :code
    when :table;
      @acc << "\n\n"
      @acc << val
      @state = :table
    when :html;
      @acc << "\n\n\n"
      @acc << val
      @acc << "\n"
      @state = :body
    when :message;
      @acc << "\n\n"
      @acc << val
      @state = :message
    when :br;
      # do nothing
    else
      pp key, val
      raise "state error"
    end
  end

  def ul((key, val))
    if key == :ul
      @acc << "\n"
      @acc << val
    else
      @state = :body
    end
  end

  def ol((key, val))
    if key == :ol
      @acc << "\n"
      @acc << val
    else
      @state = :body
    end
  end

  def dl((key, val))
    # dl は : で始まる行で終わるので
    # ここでやることはない
    if key == :dl
    else
      @state = :body
    end
  end

  def num((key, val))
    if key == :num
      @acc << "\n"
      @acc << val
    else
      @state = :body
      process([key, val])
    end
  end

  def code((key, val))
    if key == :code
      @acc << "\n"
      @acc << val
      @state = :body
    elsif key == :br
      @acc << val
    else
      @acc << "\n"
      @acc << val
    end
  end

  def blockquote((key, val))
    if key == :blockquote
      @acc << "\n"
      @acc << val
    elsif key == :br
      @state = :body
    else
      @acc << "\n"
      @acc << val
      @state = :body
    end
  end

  def table((key, val))
    if key == :table
      @acc << "\n"
      @acc << val
    else
      @acc << "\n"
      @state = :body
    end
  end

  def message((key, val))
    if key == :message
      @acc << "\n"
      @acc << val
      @state = :body
    elsif key == :br
      @acc << val
    else
      @acc << "\n"
      @acc << val
    end
  end

  def process(tuple)
    self.send(@state, tuple)
  end
end


def main(target)
  path = File.absolute_path(target)
  data = File.read(path)

  data.gsub!(/ +$/, '') # remove trailing space

  state = State.new()
  tokenize(data).each{|tuple|
    # p tuple
    state.process(tuple)
  }

  result = state.acc.join("") << "\n"

  # puts result
  File.write(path, result)
end


if ARGV.empty?
  puts HELP
  exit 0
end

Dir.glob(ARGV).each{|target|
  main(target)
}
