require "yaml"

module Noveloh
  class Parser
    class << self
      def parse(file_path)
        YAML.load(File.read(file_path))
      end
    end
  end
end
