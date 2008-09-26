module Purl
  module Features::Conversion
    include ::Purl
    def self.operators
      [ Op.new('to.png' , 1, :to_png),
        Op.new('to.jpg' , 1, :to_jpeg),
        Op.new('to.jpeg', 1, :to_jpeg),
        Op.new('to.gif' , 1, :to_gif),
        Op.new('to.json',-1, :to_json)]
    end

    def to_png(image)
      process(image, :as => :magick) do |img|
        img.format = 'png'
        Result.new(img.to_blob, 'image/png')
      end
    end

    def to_jpeg(image)
      process(image, :as => :magick) do |img|
        img.format = 'jpeg'
        Result.new(img.to_blob{self.quality = 80}, 'image/jpeg')
      end
    end

    def to_gif(image)
      process(image, :as => :magick) do |img|
        img.format = 'gif'
        Result.new(img.to_blob, 'image/gif')
      end
    end

    def to_json(*stack)
      n = stack.pop.to_i
      Result.new(stack[-n..-1].to_json, 'application/json')
    end
  end
end
