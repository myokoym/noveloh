require "gosu"

module Noveloh
  class Text
    def initialize(window, font_size)
      @font_size = font_size
      @font = Gosu::Font.new(window, Gosu.default_font_name, @font_size)
      @text = nil
      @color = nil
    end

    def draw
      return unless @text
      @text.each_line.with_index do |line, i|
        line.chomp!
        @font.draw(line,
                   10, 10 + @font_size * i,
                   10,
                   1.0, 1.0,
                   @color)
      end
    end

    def apply_page(page)
      return unless page
      text = page["text"]
      unless text
        @text = nil
        return
      end
      text.encode!("UTF-8")
      @text = text
      @color = page["color"] || 0xffffffff
    end
  end
end
