module Line
  class Result

    #constants are always defined at the top of the class
    TEXT_MESSAGE = 1
    IMAGE_MESSAGE = 2
    VIDEO_MESSAGE = 3
    AUDIO_MESSAGE = 4
    LOCATION_MESSAGE = 5
    STICKER_MESSAGE = 6
    CONTACT_MESSAGE = 7

    MESSAGE_TYPE  = {
      1 => 'Text',
      2 => 'Image',
      3 => 'Video',
      4 => 'Audio',
      5 => 'Location',
      6 => 'Sticker',
      7 => 'Contact'
    }

    attr_accessor :from, :contentType, :id

    def initialize(contentType, id, from)
      @from = from
      @contentType = MESSAGE_TYPE[contentType]
      @id = id
    end
    ##
    # Line Business Connect sends the following parameters in the content hash
    # See https://developers.line.me/businessconnect/api-reference#receiving_messages for definitions
    #
    # @params eventType [String] 138311609000106303- Received message (text, images, etc.) 138311609100106403 - Received operation (added as friend, etc.)
    # @param content [Hash] the contents of the message

    def self.from_hash(hash)
      if hash['eventType'] == '138311609000106303'
        content = hash['content']
        result = nil

        if content['contentType'].to_i == TEXT_MESSAGE
          result = Text.new(content['from'], content['id'], content['text'])
        elsif content['contentType'].to_i == IMAGE_MESSAGE
          result = Image.new(content['from'], content['id'], content['originalContentUrl'], content['previewImageUrl'])
        end
        result
      end
    end
  end

  class Text < Result

    attr_accessor :text

    def initialize(from, id, text)
      super(Result::TEXT_MESSAGE, id, from)
      @text = text
    end
  end

  class Image < Result

    attr_accessor :url, :preview

    def initalize(from, id, originalContentUrl, previewImageUrl)
      super(Result::IMAGE_MESSAGE, id, from)
      @url = originalContentUrl
      @preview = previewImageUrl
    end
  end
end
