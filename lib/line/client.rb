require 'httparty'

module Line
  class Client
    # checks to see if the token is valid
    #
    # @params access_token [String] the access_token
    # [Boolean] true/false if valid or not
    #
    def valid_access_token?(access_token)
      url = 'https://api.line.me/v1/oauth/verify'
      response = get_request(url, access_token)
      if response.has_key?('channelId')
        return true
      elsif response.has_key?('statusCode') && response['statusCode'] == '401'
        return false
      else
        raise 'Something weird is going on here'
      end
    end

    # refreshes the access token if it's deemed invalid
    #
    # @params refreshToken [String] the refresh token
    # @params channelSecret [String] the channel secret
    # @params channel_access_toke [String] the channel access token
    #
    def refresh_access_token(refreshToken, channelSecret, channel_access_token)
      url = "https://api.line.me/v1/oauth/accessToken?refreshToken=#{refreshToken}&channelSecret=#{channelSecret}"
      channel_access_token = channel_access_token
      response = send url, channel_access_token
      if response.has_key?('accessToken') && valid_access_token?(response['accessToken'])
        return response
      else
        raise 'Invalid access token'
      end
    end

    # Sends a message
    #
    # @param to [Array] String arrays of the recipients
    # msg_type [Integer] The type of message to be sent.
    # toType [Integer] The type of recipient
    # @param text [Hash] - contains the content of the message to be sent
    # @return [Boolean] if message was sent successfully
    #
    def send_message channel_access_token, to, msg_type, toType, text
      url = 'https://api.line.me/v1/events'
      request = case msg_type
      when 'Text'
        { "to" => [to],
          "toChannel" => "1383378250",
          "eventType" => "138311608800106203",
          "content" => {
            "contentType" => Line::Result::MESSAGE_TYPE.key(msg_type),
            "toType" => toType,
            "text" => text
          }
        }.to_json
      end
      send url, channel_access_token, request
    end

    private
      def get_request url, access_token
        response = HTTParty.get(url,
          :headers => {
            "Content-Type" => "application/json; charset=utf-8",
            "X-LINE-ChannelToken" => access_token
          }
        )
        return JSON.parse response.body
      end

      def send url, channel_access_token, request={}
        response = HTTParty.post(url,
          body: request,
          :debug_output => $stdout,
          :headers => {
            "Content-Type" => "application/json; charset=utf-8",
            "X-LINE-ChannelToken" => channel_access_token
          }
        )
        return JSON.parse response.body
      end

  end
end
