module Purl
  module Features::Conversion
    include CairoUtil
    def self.operators
      [ Op.new(:'to.png' , 1, :to_png),
        Op.new(:'to.jpg' , 1, :to_jpeg),
        Op.new(:'to.jpeg', 1, :to_jpeg)]
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
        Result.new(img.to_blob, 'image/jpeg')
      end
    end
  end
end
