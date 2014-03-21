require "noveloh/parser"

class ParserTest < Test::Unit::TestCase
  def test_parse
    file_path = File.join(fixtures_dir, "test.yaml")
    assert_equal([{"text" => "Hello"}],
                 Noveloh::Parser.parse(file_path))
  end

  private
  def fixtures_dir
    File.join(File.expand_path(File.dirname(__FILE__)), "fixtures")
  end
end
