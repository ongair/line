module Line
  class Result
    TEXT_MESSAGE = 1
    IMAGE_MESSAGE = 2
    VIDEO_MESSAGE = 3
    AUDIO_MESSAGE = 4
    LOCATION_MESSAGE = 7
    STICKER_MESSAGE = 8
    CONTACT_MESSAGE = 10

    ##
    # Line Business Connect sends the following parameters in the content hash
    # See https://developers.line.me/businessconnect/api-reference#receiving_messages for definitions
    #
    # @param content [Hash] the contents of the message
    def self.from_hash(hash)
      content = hash['content']
      message = nil
      if hash['eventType'] == "138311609000106303"
        if content['contentType'].to_i == TEXT_MESSAGE
          message = Text.new(content['id'], content['from'], content['text'])
        elsif content['contentType'].to_i == IMAGE_MESSAGE
          message = Image.new(content['id'], content['from'])
        end
      end
      message
    end
  end
end
