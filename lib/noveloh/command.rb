require "noveloh/window"
require "yaml"

module Noveloh
  class Command
    class << self
      def run(*arguments)
        window = Window.new(YAML.load(File.read(arguments[0])))
        window.show
      end
    end
  end
end
