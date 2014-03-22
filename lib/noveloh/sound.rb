require "gosu"

module Noveloh
  class Sound
    def initialize(window)
      @window = window
    end

    def apply_page(page)
      return unless page
      beep = page["beep"]
      Gosu::Sample.new(@window, beep).play if beep
    end
  end
end
