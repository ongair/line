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
      if content['contentType'].to_i == 1
        result = Text.new(content['from'], content['text'])
      end

      result
    end

  end

  class Text < Result

    attr_accessor :text

    def initialize(from, text)
      super(1, from)
      @text = text

    end
  end

end