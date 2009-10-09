module Purl
  module Features::Conversion
    class << self
      def operators
        [
          Op.new('to.png' , 1, :to_png),
          Op.new('to.jpg' , 1, :to_jpeg),
          Op.new('to.jpeg', 1, :to_jpeg),
          Op.new('to.gif' , 1, :to_gif),
          Op.new('to.json',-1, :to_json)
        ]
      end

      def to_png(image)
        img = process(image, :as => :magick)
        Result.new(img.to_blob{|i| i.format = 'png'}, 'image/png')
      end

      def to_jpeg(image)
        img = process(image, :as => :magick)
        Result.new(img.to_blob{|i| i.format = 'jpeg';i.quality = 80}, 'image/jpeg')
      end

      def to_gif(image)
        img = process(image, :as => :magick)
        if img.respond_to? :optimize_layers
          img = img.optimize_layers(Magick::OptimizeLayer)
        end

        Result.new(img.to_blob{|i| i.format = 'gif'}, 'image/gif')
      end

      def to_json(*stack)
        n = stack.pop.to_i
        Result.new(stack[-n..-1].to_json, 'application/json')
      end
    end
  end
end
