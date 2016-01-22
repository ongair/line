module Line
  class Result

    attr_accessor :from, :contentType, :id

    def initialize(contentType, id, from)
      @from = from
      @contentType = contentType
      @id = id      
    end

    def self.from_hash(hash)
      content = hash['content']
      result = nil
      if content['contentType'].to_i == TEXT_MESSAGE
        result = Text.new(content['from'], content['id'], content['text'])
      elsif content['contentType'].to_i == IMAGE_MESSAGE
        result = Image.new(content['from'], content['id'], content['originalContentUrl'], content['previewImageUrl'])
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