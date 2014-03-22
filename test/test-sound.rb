require "noveloh/sound"

class SoundTest < Test::Unit::TestCase
  def setup
    window = Noveloh::Window.new([])
    @sound = Noveloh::Sound.new(window)
  end

  # TODO
  def test_init
    file_path = File.join(fixtures_dir, "test.wav")
    assert_nothing_raised do
      @sound
    end
  end

  private
  def fixtures_dir
    File.join(File.expand_path(File.dirname(__FILE__)), "fixtures")
  end
end
