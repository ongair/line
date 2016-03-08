module Line
  class Message
    MESSAGE_TYPE  = {
      1 => 'Text',
      2 => 'Image',
      3 => 'Video',
      4 => 'Audio',
      7 => 'Location',
      8 => 'Sticker',
      10 => 'Contact'
    }

    attr_accessor :from, :contentType, :id

    def initialize(contentType, id, from)
      @from = from
      @contentType = MESSAGE_TYPE[contentType]
      @id = id
    end

    def is_text?
      self.is_a?(Line::Text)
    end

    def is_media?
      self.is_a?(Line::Image)
    end

    def is_location?
      contentType == 'Location'
    end
  end

  class Text < Message
    attr_accessor :text

    def initialize(id, from, text)
      super(Result::TEXT_MESSAGE, id, from)
      @text = text
    end
  end

  class Image < Message
    attr_accessor :url, :preview_url

    def initialize(id, from)
      super(Result::IMAGE_MESSAGE, id, from)
      @preview_url = "https://api.line.me/v1/bot/message/#{id}/content/preview"
      @url = "https://api.line.me/v1/bot/message/#{id}/content"
    end
  end
end
