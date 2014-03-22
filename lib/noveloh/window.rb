require "gosu"
require "noveloh/background"
require "noveloh/text"
require "noveloh/cursor"
require "noveloh/sound"

module Noveloh
  class Window < Gosu::Window
    def initialize(pages, width=640, height=480)
      super(width, height, false)
      self.caption = "Noveloh"
      @pages = pages
      @page_index = 0
      font_size = self.height / 15
      @flags = {}
      @text = Text.new(self, font_size)
      @text.apply_page(@pages.first)
      @background = Background.new(self)
      @background.apply_page(@pages.first)
      @cursor = Cursor.new(self, font_size)
      @sound = Sound.new(self)
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
          flag_on
          flag_off
          @page_index += 1
          jump
          @cursor.clear
          current_page = @pages[@page_index]
          return unless current_page
          @background.apply_page(current_page)
          @text.apply_page(current_page)
          @sound.apply_page(current_page)
        end
      when Gosu::KbDown
        @cursor.increment
      when Gosu::KbUp
        @cursor.decrement
      end
    end

    private
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
      next_page = nil
      @pages.each_with_index do |page, i|
        current_tag = page["tag"]
        next unless current_tag
        if tags.is_a?(Array)
          selected_tag = tags[@cursor.position - 1]
          next unless current_tag == selected_tag
        elsif tags.is_a?(Hash)
          selected_tag = nil
          tags.each_entry do |key, value|
            if @flags[key]
              selected_tag = value
              break
            end
          end
          selected_tag = tags["else"] unless selected_tag
          next unless current_tag == selected_tag
        elsif tags.is_a?(String)
          next unless current_tag == tags
        end
        next_page = i
      end
      if next_page
        @page_index = next_page
      else
        @page_index -= 1
      end
    end
  end
end
