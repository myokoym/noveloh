require "noveloh/window"

class WindowTest < Test::Unit::TestCase
  def test_init
    pages = []
    @window = Noveloh::Window.new(pages)
  end
end
