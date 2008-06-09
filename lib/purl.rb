# Purl
require 'RMagick'
require 'cairo_util'
require 'purl/stack_machine'

module Purl
  class Purl < Environment
    def initialize(options = {})
      super
      @options = {:image_class => ::Image, :image_data => 'data'}.merge(options)
      add_operator Op.new :load, 1
      load_feature Features::Arithmetic
      load_feature Features::Conversion
      load_feature Features::Stack
      load_feature Features::Image
      load_feature Features::Resize
      yield self
    end

    def load(image_id)
      image = @options[:image_class].find(image_id)
      image = Magick::Image.from_blob(image.send(@options[:image_data])).shift
      Result.new(image)
    end
  end

  private
  def process(image, options = {:as => :cairo})
    case image
    when Cairo::ImageSurface
      if options[:as] == :cairo
        yield image
      elsif options[:as] == :magick
        yield cairo2magick(image)
      end
    when Magick::Image
      if options[:as] == :magick
        yield image
      elsif options[:as] == :cairo
        yield magick2cairo(image)
      end
    else
      Result.new(image)
    end
  end
end
