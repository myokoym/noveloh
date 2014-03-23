require "gosu"
require "noveloh/background"
require "noveloh/text"
require "noveloh/cursor"
require "noveloh/sound"
require "noveloh/tag_index"

module Noveloh
  class Window < Gosu::Window
    def initialize(pages, width=640, height=480)
      super(width, height, false)
      self.caption = "Noveloh"
      @pages = pages
      @page_index = 0
      @tag_index = TagIndex.new(pages)
      @flags = {}
      init_elements
      apply_page(@pages.first)
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
        if @pages.length <= @page_index
          close
        else
          turn_over
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

    def turn_over
      flag_on
      flag_off
      @page_index += 1
      jump
      @cursor.clear
      apply_page(@pages[@page_index])
    end

    def apply_page(page)
      return unless page
      @background.apply_page(page)
      @text.apply_page(page)
      @sound.apply_page(page)
    end

    def flag_on
      return unless @pages[@page_index]
      flag = @pages[@page_index]["flag"]
      return unless flag
      @flags[flag] = true
    end

    def flag_off
      return unless @pages[@page_index]
      flag = @pages[@page_index]["flag_off"]
      return unless flag
      @flags[flag] = false
    end

    # TODO: refactoring
    def jump
      return unless @pages[@page_index]
      tags = @pages[@page_index - 1]["jump"]
      return unless tags
      if tags.is_a?(Array)
        if @cursor.position <= 0
          @page_index -= 1
          return
        end
      end

        selected_tag = nil
        if tags.is_a?(Array)
          selected_tag = tags[@cursor.position - 1]
        elsif tags.is_a?(Hash)
          selected_tag = nil
          tags.each_entry do |key, value|
            if @flags[key]
              selected_tag = value
              break
            end
          end
          selected_tag = tags["else"] unless selected_tag
        elsif tags.is_a?(String)
          selected_tag = tags
        end
        next_page = @tag_index[selected_tag]

      if next_page
        @page_index = next_page
      else
        @page_index -= 1
      end
    end
  end
end
