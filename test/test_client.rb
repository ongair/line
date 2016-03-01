require 'test/unit'
require 'line'
require 'webmock/minitest'
require 'pry-byebug'

class ClientTest < Test::Unit::TestCase
  def test_can_check_if_access_token_is_valid
    stub_request(:get, "https://api.line.me/v1/oauth/verify").
      with(:headers => {'Content-Type'=>'application/json; charset=utf-8', 'X-Line-Channeltoken'=>'invalid_token'}).
      to_return(:status => 200, :body => {"statusCode"=>"401", "statusMessage"=>"invalid token"}.to_json, :headers => {})

    stub_request(:get, "https://api.line.me/v1/oauth/verify").
      with(:headers => {'Content-Type'=>'application/json; charset=utf-8', 'X-Line-Channeltoken'=>'valid_token'}).
      to_return(:status => 200, :body => {"channelId"=>1454447408, "mid"=>"u078acb79595564c91f562c04e3a8a9b1"}.to_json, :headers => {})

    client = Line::Client.new
    assert_equal false, client.valid_access_token?('invalid_token')
    assert_equal true, client.valid_access_token?('valid_token')

  end
end
