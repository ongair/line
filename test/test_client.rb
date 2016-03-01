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
      with(:headers => {'Content-Type'=>'application/json; charset=utf-8', 'X-Line-Channeltoken'=>'channel_access_token'}).
      to_return(:status => 200, :body => {"channelId"=>1454447408, "mid"=>"u078acb79595564c91f562c04e3a8a9b1"}.to_json, :headers => {})

    client = Line::Client.new
    assert_equal false, client.valid_access_token?('invalid_token')
    assert_equal true, client.valid_access_token?('channel_access_token')

  end

  def test_can_get_refresh_access_token_with_valid_params
    stub_request(:get, "https://api.line.me/v1/oauth/verify").
      with(:headers => {'Content-Type'=>'application/json; charset=utf-8', 'X-Line-Channeltoken'=>'channel_access_token'}).
      to_return(:status => 200, :body => {"channelId"=>1454447408, "mid"=>"u078acb79595564c91f562c04e3a8a9b1"}.to_json, :headers => {})


    stub_request(:post, "https://api.line.me/v1/oauth/accessToken?channelSecret=channelSecret&refreshToken=refreshToken").
      with(:headers => {'Content-Type'=>'application/json; charset=utf-8', 'X-Line-Channeltoken'=>'channel_access_token'}).
      to_return(:status => 200, :body => {
        "mid"=>"12345",
        "accessToken"=>"channel_access_token",
        "expire"=>1459435368761,
        "refreshToken"=>"wldkjihx3wfn"}.to_json, :headers => {}
      )

    client = Line::Client.new

    response = client.refresh_access_token('refreshToken', 'channelSecret', 'channel_access_token')
    assert response.has_key?('mid')
    assert response.has_key?('accessToken')
    assert response.has_key?('expire')
    assert response.has_key?('refreshToken')

  end

  def test_does_not_get_refresh_access_token_with_valid_params
    stub_request(:post, "https://api.line.me/v1/oauth/accessToken?channelSecret=channelSecret&refreshToken=badRefreshToken").
      with(:headers => {'Content-Type'=>'application/json; charset=utf-8', 'X-Line-Channeltoken'=>'channel_access_token'}).
      to_return(:status => 200, :body => {
        "statusCode"=>"401",
        "statusMessage"=>"invalid refreshToken"}.to_json, :headers => {}
      )

    client = Line::Client.new

    assert_raises RuntimeError do
      client.refresh_access_token('badRefreshToken', 'channelSecret', 'channel_access_token')
    end
  end

  def test_can_send_a_message


    stub_request(:post, "https://api.line.me/v1/events").
      with(:body => "{\"to\":[\"userID\"],\"toChannel\":\"1383378250\",\"eventType\":\"138311608800106203\",\"content\":{\"contentType\":1,\"toType\":1,\"text\":\"Hello, Yoichiro!\"}}",
           :headers => {'Content-Type'=>'application/json; charset=utf-8', 'X-Line-Channeltoken'=>'channel_access_token'}).
      to_return(:status => 200, :body => {"failed"=>[],"messageId"=>"1456847120183","timestamp"=>1456847120183,"version"=>1}.to_json, :headers => {})

    client = Line::Client.new
    response = client.send_message 'channel_access_token','userID', 'Text', 1, 'this is a test message'

    assert response['failed'].empty?
  end
end
