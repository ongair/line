require 'test/unit'
require 'line'
class ResultTest < Test::Unit::TestCase

  def test_can_get_result_messages
    hash = { "from" => "u206d25c2ea6bd87c17655609a1c37cb8", "eventType" => "138311609000106303", "content" => { "from" => "u225a0f79e5e35709d39a157ab78c8dea", "text" => "Wassup?", "toType" => 1, "contentType" => 1 }}

    message = Line::Result.from_hash(hash)
    assert message.is_a?(Line::Text)
    assert_equal 'Wassup?', message.text
    assert_equal 'u225a0f79e5e35709d39a157ab78c8dea', message.from
  end
end