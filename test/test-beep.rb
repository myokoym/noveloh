require "noveloh/beep"

class BeepTest < Test::Unit::TestCase
  def setup
    window = Noveloh::Window.new([])
    file_path = File.join(fixtures_dir, "test.wav")
    @beep = Noveloh::Beep.new(window, file_path)
  end

  def test_play
    mock(@beep.instance_variable_get(:@sample)).play
    assert_nothing_raised do
      @beep.play
    end
  end

  private
  def fixtures_dir
    File.join(File.expand_path(File.dirname(__FILE__)), "fixtures")
  end
end
