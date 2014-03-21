require "noveloh/window"
require "gosu"

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

  class ButtonDownTest < self
    def setup
      pages = [
        {"text" => "Hello"},
      ]
      @window = Noveloh::Window.new(pages)
    end

    class EscapeTest < self
      def test_called_close
        mock(@window).close
        assert_nothing_raised do
          @window.button_down(Gosu::KbEscape)
        end
      end
    end

    class ReturnTest < self
      def test_return_key
        assert_nothing_raised do
          @window.button_down(Gosu::KbReturn)
        end
      end

      def test_enter_key_in_tenkey
        assert_nothing_raised do
          @window.button_down(Gosu::KbEnter)
        end
      end

      def test_space_key
        assert_nothing_raised do
          @window.button_down(Gosu::KbSpace)
        end
      end
    end

    class UpTest < self
      def test_cursor_decrement
        @window.button_down(Gosu::KbUp)
        assert_equal(-1, @window.instance_variable_get(:@cursor))
      end
    end

    class DownTest < self
      def test_cursor_increment
        @window.button_down(Gosu::KbDown)
        assert_equal(1, @window.instance_variable_get(:@cursor))
      end
    end
  end
end
