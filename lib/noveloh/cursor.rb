module Noveloh
  class Cursor
    attr_reader :position

    def initialize(window, height, default_position=0)
      @window = window
      @width  = window.width - 10
      @height = height
      @position = default_position
    end

    def draw
      return unless @position > 0
      color = 0x66ffffff
      @window.draw_quad(5,          10 + @height * (@position - 1), color,
                        5 + @width, 10 + @height * (@position - 1), color,
                        5,          10 + @height * @position, color,
                        5 + @width, 10 + @height * @position, color)
    end

    def increment
      @position += 1
    end

    def decrement
      @position -= 1
    end

    def clear
      @position = 0
    end
  end
end
