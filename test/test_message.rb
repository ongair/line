require 'test/unit'
require 'line'
require 'byebug'
class MessageTest < Test::Unit::TestCase

  def test_can_recieve_a_text_message
    hash =
        { "content"=>
          {
            "toType"=>1,
            "createdTime"=>1457077187436,
            "from"=>"ue303310d67722553bbb6c476a6ffaedd",
            "location"=>nil,
            "id"=>"3976766182080",
            "to"=>["ucdd3e95cd9ec0821a203f953989414bc"],
            "text"=>"Wassup?",
            "contentMetadata"=>nil,
            "deliveredTime"=>0,
            "contentType"=>1,
            "seq"=>nil
          },
          "createdTime"=>1457077187582,
          "eventType"=>"138311609000106303",
          "from"=>"u206d25c2ea6bd87c17655609a1c37cb8",
          "fromChannel"=>1341301815,
          "id"=>"WB1521-3213401013",
          "to"=>["u078acb79595564c91f562c04e3a8a9b1"],
          "toChannel"=>1454447408
        }

    message = Line::Result.from_hash(hash)
    assert message.is_a?(Line::Text)
    assert_equal 'Wassup?', message.text
    assert_equal 'ue303310d67722553bbb6c476a6ffaedd', message.from
    assert_equal '3976766182080', message.id
    assert_equal 'Text', message.contentType
  end

  def test_can_recieve_an_image_message
    hash =
        { "content"=>
          {
            "toType"=>1,
            "createdTime"=>1457077187436,
            "from"=>"ue303310d67722553bbb6c476a6ffaedd",
            "location"=>nil,
            "id"=>"3976766182080",
            "to"=>["ucdd3e95cd9ec0821a203f953989414bc"],
            "text"=>"",
            "contentMetadata"=>nil,
            "deliveredTime"=>0,
            "contentType"=>2,
            "seq"=>nil
          },
          "createdTime"=>1457077187582,
          "eventType"=>"138311609000106303",
          "from"=>"u206d25c2ea6bd87c17655609a1c37cb8",
          "fromChannel"=>1341301815,
          "id"=>"WB1521-3213401013",
          "to"=>["u078acb79595564c91f562c04e3a8a9b1"],
          "toChannel"=>1454447408
        }

    message = Line::Result.from_hash(hash)
    assert message.is_a?(Line::Image)
    assert_equal 'ue303310d67722553bbb6c476a6ffaedd', message.from
    assert_equal '3976766182080', message.id
    assert_equal 'Image', message.contentType
  end
end
