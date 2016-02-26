module Line
  class Result
    require 'pry-byebug'

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

    def self.from_hash(hash)
      content = hash['content']
      result = nil

      if MESSAGE_TYPE[content['contentType']] == 'Text'
        result = Text.new(content['from'], content['id'], content['text'])
      elsif MESSAGE_TYPE[content['contentType']] == 'Image'
        result = Image.new(content['from'], content['id'], content['originalContentUrl'], content['previewImageUrl'])
      end
      result
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
