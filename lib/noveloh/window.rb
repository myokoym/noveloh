require "gosu"
require "noveloh/scenario"
require "noveloh/background"
require "noveloh/text"
require "noveloh/cursor"
require "noveloh/sound"

module Noveloh
  class Window < Gosu::Window
    def initialize(pages, width=640, height=480)
      super(width, height, false)
      self.caption = "Noveloh"
      @scenario = Scenario.new(pages)
      init_elements
      apply_page(@scenario.current_page)
    end

    def draw
      @background.draw
      @text.draw
      @cursor.draw
    end

    def button_down(id)
      case id
      when Gosu::KbEscape
        close
      when Gosu::KbReturn, Gosu::KbEnter, Gosu::KbSpace
        unless @scenario.current_page
          close
        else
          @scenario.turn_over(@cursor)
          @cursor.clear
          apply_page(@scenario.current_page)
        end
      when Gosu::KbDown
        @cursor.increment
      when Gosu::KbUp
        @cursor.decrement
      end
    end

    private
    def init_elements
      font_size = self.height / 15
      @background = Background.new(self)
      @text       = Text.new(self, font_size)
      @sound      = Sound.new(self)
      @cursor     = Cursor.new(self, font_size)
    end

    def apply_page(page)
      return unless page
      @background.apply_page(page)
      @text.apply_page(page)
      @sound.apply_page(page)
    end
  end
end
