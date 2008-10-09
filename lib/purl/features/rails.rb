module Purl
  module Features::Rails
    class << self
      attr_accessor :image_class, :image_data

      def operators
        [
          Op.new :load, 1
        ]
      end

      def load(image_id)
        @image_class ||= ::Image
        @image_data ||= 'data'
        image = @image_class.find(image_id)
        image = Magick::Image.from_blob(image.send(@image_data)).shift.strip!
        Result.new(image)
      end
    end
  end
end
