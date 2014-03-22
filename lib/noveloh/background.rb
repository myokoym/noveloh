require "gosu"

module Noveloh
  class Background
    def initialize(window)
      @window = window
      @image = nil
      @color = 0x66ffffff
    end

    def draw
      if @image
        @image.draw(0, 0, 0,
                    1.0 * @window.width  / @image.width,
                    1.0 * @window.height / @image.height,
                    @color)
      else
        black = Gosu::Color::BLACK
        @window.draw_quad(0,             0,              black,
                          @window.width, 0,              black,
                          0,             @window.height, black,
                          @window.width, @window.height, black)
      end
    end

    def apply_page(page)
      return unless page
      set_image(page["background_image"])
      set_color(page["background_color"])
    end

    def set_image(file_path)
      return unless file_path
      @image = Gosu::Image.new(@window, file_path)
    end

    def set_color(color)
      return unless color
      @color = color
    end
  end
end
