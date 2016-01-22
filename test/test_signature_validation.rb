require 'test/unit'
require 'line'
require 'line/signature_validation'

class SignatureValidationTest < Test::Unit::TestCase
  def test_validates_with_secret
    assert_equal false, Line::SignatureValidation.validate?('12345', '67890', 'Hello world')

    assert_equal true, Line::SignatureValidation.validate?('12345', 'aAbTaUZR7wEoYNdx+9F833tCH2Ldy1VXuntfRvNIJOQ=', '1234567890')
  end
end