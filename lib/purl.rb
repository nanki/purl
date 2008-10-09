require 'RMagick'
require 'cairo_util'
require 'purl/stack_machine'

module Purl
  class Purl < Environment
    def initialize(options = {})
      super
      load_feature Features::Rails
      load_feature Features::Arithmetic
      load_feature Features::Conversion
      load_feature Features::Stack
      load_feature Features::Image
      load_feature Features::Effect
      load_feature Features::Resize
      load_feature Features::ResizeMacro
      yield self
    end
  end

  include ::CairoUtil

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
