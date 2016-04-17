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
      def test_text
        pages = [
          {"text" => "Hello"},
        ]
        @window = Noveloh::Window.new(pages)
        text = text_attr("text")
        assert_equal("Hello", text)
      end

      def test_color
        pages = [
          {"text" => "Hello"},
          {"color" => 0xffffffff},
        ]
        @window = Noveloh::Window.new(pages)
        color = text_attr("color")
        assert_equal(0xffffffff, color)
      end

      private
      def text_attr(name)
        @text = @window.instance_variable_get(:@text)
        @text.instance_variable_get("@#{name}")
      end
    end

    class BackgroundImageTest < self
      def setup
        pages = [
          {"background_image" => File.join(fixtures_dir, "leaf.jpg")},
        ]
        @window = Noveloh::Window.new(pages)
        @background = @window.instance_variable_get(:@background)
        @image = @background.instance_variable_get(:@image)
      end

      def test_image
        assert_not_nil(@image)
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
        cursor = @window.instance_variable_get(:@cursor)
        mock(cursor).decrement
        assert_nothing_raised do
          @window.button_down(Gosu::KbUp)
        end
      end
    end

    class DownTest < self
      def test_cursor_increment
        cursor = @window.instance_variable_get(:@cursor)
        mock(cursor).increment
        assert_nothing_raised do
          @window.button_down(Gosu::KbDown)
        end
      end
    end
  end
end
