module Noveloh
  class TagIndex
    def initialize(pages)
      @tags = {}
      pages.each_with_index do |page, i|
        current_tag = page["tag"]
        next unless current_tag
        @tags[current_tag] = i
      end
    end

    def [](tag)
      @tags[tag]
    end
  end
end
