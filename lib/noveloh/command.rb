require "noveloh/window"
require "noveloh/parser"

module Noveloh
  class Command
    class << self
      def run(*arguments)
        window = Window.new(Parser.parse(arguments[0]))
        window.show
      end
    end
  end
end
