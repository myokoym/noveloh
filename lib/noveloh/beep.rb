require "gosu"

module Noveloh
  class Beep
    def initialize(window, file_path)
      @sample = Gosu::Sample.new(window, file_path)
    end

    def play
      @sample.play
    end
  end
end
