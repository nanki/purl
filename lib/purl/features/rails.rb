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
        Result.new(Magick::ImageList.new.from_blob(image.send(@data_column)))
      end
    end
  end
end
