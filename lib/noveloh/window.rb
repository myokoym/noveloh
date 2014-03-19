require "gosu"

module Noveloh
  class Window < Gosu::Window
    def initialize(pages, width=640, height=480)
      super(width, height, false)
      self.caption = "Noveloh"
      @pages = pages
      @page_index = 0
      @font_size = height / 15
      @font = Gosu::Font.new(self, Gosu.default_font_name, @font_size)
      @background_image = nil
      set_background_image
    end

    def draw
      draw_background_image if @background_image
      draw_text
    end

    def button_down(id)
      case id
      when Gosu::KbEscape
        close
      when Gosu::KbReturn, Gosu::KbSpace
        if @pages.length <= @page_index
          close
        else
          @page_index += 1
          set_background_image
          play_beep
        end
      end
    end

    private
    def set_background_image
      return unless @pages[@page_index]
      background_image = @pages[@page_index]["background_image"]
      return unless background_image
      @background_image = Gosu::Image.new(self, background_image)
    end

    def draw_text
      return unless @pages[@page_index]
      text = @pages[@page_index]["text"].encode("UTF-8")
      color = @pages[@page_index]["color"] || 0xffffffff
      text.each_line.with_index do |line, i|
        line.chomp!
        @font.draw(line,
                   10, 10 + @font_size * i,
                   10,
                   1.0, 1.0,
                   color)
      end
    end

    def draw_background_image(color=0x66ffffff)
      image  = @background_image
      width  = image.width
      height = image.height
      image.draw(0, 0, 0,
                 1.0 * self.width / width,
                 1.0 * self.height / height,
                 color)
    end

    def play_beep
      return unless @pages[@page_index]
      beep_file = @pages[@page_index]["beep"]
      return unless beep_file
      Gosu::Sample.new(self, beep_file).play
    end
  end
end
