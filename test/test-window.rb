require "noveloh/window"

class WindowTest < Test::Unit::TestCase
  def test_init
    pages = []
    assert_not_nil(Noveloh::Window.new(pages))
  end

  private
  def fixtures_dir
    File.join(File.expand_path(File.dirname(__FILE__)), "fixtures")
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

    class BackgroundImageTest < self
      def setup
        pages = [
          {"background_image" => File.join(fixtures_dir, "leaf.jpg")},
        ]
        @window = Noveloh::Window.new(pages)
      end

      def test_nothing_raised
        assert_nothing_raised do
          @window.draw
        end
      end
    end

    class ColorTest < self
      def setup
        pages = [
          {"text" => "Hello"},
          {"color" => 0xffffffff},
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
