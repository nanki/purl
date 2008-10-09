module Purl
  module Features::Rails
    class << self
      def operators
        [ Op.new(:load, 1) ]
      end

      attr_reader :image_class, :data_column

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
