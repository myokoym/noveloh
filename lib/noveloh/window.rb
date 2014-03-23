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

    def jump
      previous_page = @pages[@page_index - 1]
      return unless previous_page
      next_page = one_way(previous_page["jump"])  ||
                  select(previous_page["select"]) ||
                  flag_check(previous_page["flag_jump"])
      @page_index = next_page if next_page
    end

    def one_way(dest_tag)
      return unless dest_tag
      @tag_index[dest_tag]
    end

    def select(tags)
      return unless tags

      if @cursor.position <= 0
        @page_index -= 1
        return
      end

      selected_tag = tags[@cursor.position - 1]
      next_page = @tag_index[selected_tag]

      unless next_page
        @page_index -= 1
        return
      end

      next_page
    end

    def flag_check(candidates)
      return unless candidates

      selected_tag = nil
      candidates.each_entry do |key, value|
        if @flags[key]
          selected_tag = value
          break
        end
      end
      selected_tag = candidates["else"] unless selected_tag

      @tag_index[selected_tag]
    end
  end
end
