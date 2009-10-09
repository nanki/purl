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
      load_feature Features::Lambda
      load_feature Features::Image
      load_feature Features::Effect
      load_feature Features::Resize
      load_feature Features::ResizeMacro
      load_feature Features::Cairo
      load_feature Features::CairoGradient
      yield self
    end
  end

  include ::CairoUtil

  private
  # process with block must return Result.new(ImageList or Image)
  def process(image, options = {:as => :cairo})
    if block_given?
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
      when Magick::ImageList
        if options[:as] == :magick
          result = Magick::ImageList.new
          image.each do |img|
            result.concat(yield(img))
          end
          Result.new(result)
        elsif options[:as] == :cairo
          raise "not implemented."
          #yield magick2cairo(image)
        end
      else
        Result.new(image)
      end
    else
      image
    end
  end
end
