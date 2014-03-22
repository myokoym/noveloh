require "gosu"

module Noveloh
  class Text
    def initialize(window, font_size)
      @font_size = font_size
      @font = Gosu::Font.new(window, Gosu.default_font_name, @font_size)
    end

    def draw(page)
      text = page["text"]
      return unless text
      text.encode!("UTF-8")
      color = page["color"] || 0xffffffff
      text.each_line.with_index do |line, i|
        line.chomp!
        @font.draw(line,
                   10, 10 + @font_size * i,
                   10,
                   1.0, 1.0,
                   color)
      end
    end
  end
end
