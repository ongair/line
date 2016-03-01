require 'httparty'
require 'byebug'

module Line
  class Client
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

    # Sends a message
    #
    # @param to [Array] String arrays of the recipients
    # msg_type [Integer] The type of message to be sent.
    # toType [Integer] The type of recipient
    # @param text [Hash] - contains the content of the message to be sent
    # @return [Boolean] if message was sent successfully
    #
    def send_message to, msg_type, toType, text
      url = 'https://api.line.me/v1/events'
      request = case msg_type
      when 'text'
        { to => [to],
          "toChannel" => "1383378250",
          "eventType" => "138311608800106203",
          "content" => {
            "contentType" => Line::Result::MESSAGE_TYPE.key(msg_type),
            "toType" => toType,
            "text" => "Hello, Yoichiro!"
          }
        }.to_json
      end
      send request
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

      def send url, request, channel_access_token
        response = HTTParty.post(url,
          body: request,
          :debug_output => $stdout,
          :headers => {
            "Content-Type" => "application/json; charset=utf-8",
            "X-LINE-ChannelToken" => channel_access_token
          }
        )
        if response == 200
          return response
        else
          raise "Error: Line Message not sent!"
        end
      end

  end
end
