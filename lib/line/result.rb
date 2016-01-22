module Line
  class Result

    attr_accessor :from, :contentType

    def initialize(contentType, from)
      @from = from
      @contentType = contentType      
    end

    def self.from_hash(hash)
      content = hash['content']
      result = nil
      if content['contentType'].to_i == TEXT_MESSAGE
        result = Text.new(content['from'], content['text'])
      elsif content['contentType'].to_i == IMAGE_MESSAGE
        result = Image.new(content['from'], content['originalContentUrl'], content['previewImageUrl'])
      end

      result
    end

    TEXT_MESSAGE = 1
    IMAGE_MESSAGE = 2
    VIDEO_MESSAGE = 3
    AUDIO_MESSAGE = 4
    LOCATION_MESSAGE = 5
    STICKER_MESSAGE = 6
    CONTACT_MESSAGE = 7
  end

  class Text < Result

    attr_accessor :text

    def initialize(from, text)
      super(Result::TEXT_MESSAGE, from)
      @text = text
    end

  end

  class Image < Result

    attr_accessor :url, :preview

    def initalize(from, originalContentUrl, previewImageUrl)
      super(Result::IMAGE_MESSAGE, from)
      @url = originalContentUrl
      @preview = previewImageUrl 
    end

  end

end