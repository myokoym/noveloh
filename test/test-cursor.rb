require "noveloh/cursor"

class CursorTest < Test::Unit::TestCase
  def setup
    window = Noveloh::Window.new([])
    font_size = 20
    @cursor = Noveloh::Cursor.new(window, font_size)
  end

  def test_increment
    @cursor.increment
    assert_equal(1, @cursor.position)
  end

  def test_decrement
    @cursor.decrement
    assert_equal(-1, @cursor.position)
  end

  def test_clear
    @cursor.increment
    @cursor.increment
    @cursor.clear
    assert_equal(0, @cursor.position)
  end
end
