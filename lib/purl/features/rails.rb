module Purl
  module Features::Rails
    class << self
      attr_accessor :image_class, :data_column

      def operators
        [
          Op.new :load, 1
        ]
      end

      def options=(options)
        @image_class = options[:image_class] || ::Image
        @data_column = options[:data_column] || 'data'
      end

      def load(image_id)
        image = @image_class.find(image_id)
        image = Magick::Image.from_blob(image.send(@data_column)).shift.strip!
        Result.new(image)
      end
    end
  end
end
