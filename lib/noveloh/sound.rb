require "gosu"

module Noveloh
  class Sound
    def initialize(window)
      @window = window
    end

    def apply_page(page)
      return unless page
      beep = page["beep"]
      return unless beep
      Gosu::Sample.new(@window, beep).play
    end
  end
end
