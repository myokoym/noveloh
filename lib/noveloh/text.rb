require "gosu"

module Noveloh
  class Text
    def initialize(window, font_size)
      @window = window
      @font_size = font_size
      @default_font = create_font
      @text = nil
      @color = nil
    end

    def draw
      return unless @text
      font = @custom_font || @default_font
      @text.each_line.with_index do |line, i|
        line.chomp!
        font.draw(line,
                   10, 10 + @font_size * i,
                   10,
                   1.0, 1.0,
                   @color)
      end
    end

    def apply_page(page)
      @text = nil
      @custom_font = nil
      return unless page
      text = page["text"]
      return unless text
      text.encode!("UTF-8")
      @text = text
      @color = page["color"] || 0xffffffff
      if page["font_size"]
        @custom_font = create_font({
          size: page["font_size"],
        })
      end
    end

    private
    def create_font(options={})
      name = Gosu.default_font_name
      size = options[:size] || @font_size
      Gosu::Font.new(@window, name, size)
    end
  end
end
