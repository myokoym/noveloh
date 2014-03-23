require "noveloh/tag_index"

module Noveloh
  class Scenario
    def initialize(pages)
      @pages = pages
      @page_index = 0
      @tag_index = TagIndex.new(pages)
      @flags = {}
    end

    def current_page
      @pages[@page_index]
    end

    def turn_over(cursor)
      flag_on
      flag_off
      @page_index += 1
      jump(cursor)
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

    def jump(cursor)
      previous_page = @pages[@page_index - 1]
      return unless previous_page
      next_page = one_way(previous_page["jump"])  ||
                  select(previous_page["select"], cursor) ||
                  flag_check(previous_page["flag_jump"])
      @page_index = next_page if next_page
    end

    def one_way(dest_tag)
      return unless dest_tag
      @tag_index[dest_tag]
    end

    def select(tags, cursor)
      return unless tags

      if cursor.position <= 0
        @page_index -= 1
        return
      end

      selected_tag = tags[cursor.position - 1]
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
