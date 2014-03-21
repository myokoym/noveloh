require "gosu"

module Noveloh
  class Window < Gosu::Window
    def initialize(pages, width=640, height=480)
      super(width, height, false)
      self.caption = "Noveloh"
      @pages = pages
      @page_index = 0
      @cursor = 0
      @font_size = height / 15
      @font = Gosu::Font.new(self, Gosu.default_font_name, @font_size)
      @background_image = nil
      set_background_image
      @flags = {}
    end

    def draw
      draw_background_image if @background_image
      draw_text
      draw_cursor if @cursor > 0
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
          @cursor = 0
          set_background_image
          play_beep
        end
      when Gosu::KbDown
        @cursor += 1
      when Gosu::KbUp
        @cursor -= 1
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
      text = @pages[@page_index]["text"]
      return unless text
      text.encode!("UTF-8")
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

    def draw_background_image
      image  = @background_image
      page = @pages[@page_index]
      color = (page && page["background_color"]) || 0x66ffffff
      width  = image.width
      height = image.height
      image.draw(0, 0, 0,
                 1.0 * self.width / width,
                 1.0 * self.height / height,
                 color)
    end

    def draw_cursor
      color = 0x66ffffff
      cursor_height = @font_size
      self.draw_quad(5,              10 + cursor_height * (@cursor - 1), color,
                     self.width - 5, 10 + cursor_height * (@cursor - 1), color,
                     5,              10 + cursor_height * @cursor, color,
                     self.width - 5, 10 + cursor_height * @cursor, color)
    end

    def play_beep
      return unless @pages[@page_index]
      beep_file = @pages[@page_index]["beep"]
      return unless beep_file
      Gosu::Sample.new(self, beep_file).play
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
        if @cursor <= 0
          @page_index -= 1
          return
        end
      end
      next_page = nil
      @pages.each_with_index do |page, i|
        current_tag = page["tag"]
        next unless current_tag
        if tags.is_a?(Array)
          selected_tag = tags[@cursor - 1]
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
