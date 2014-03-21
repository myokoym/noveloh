require "noveloh/window"

class WindowTest < Test::Unit::TestCase
  def test_init
    pages = []
    @window = Noveloh::Window.new(pages)
  end

  class DrawTest < self
    class TextTest < self
      def setup
        pages = [
          {"text" => "Hello"},
        ]
        @window = Noveloh::Window.new(pages)
      end

      def test_nothing_raised
        assert_nothing_raised do
          @window.draw
        end
      end
    end
  end
end
