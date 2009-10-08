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
  # process with block must return Result.new(ImageList)
  def process(image, options = {:as => :cairo}, &block)
    as = options[:as]
    case image
    when Cairo::ImageSurface
      case as
      when :cairo
        process(CairoImageList.new << image, options, &block)
      when :magick
        process(cairo2magick(image), options, &block)
      end
    when Magick::Image
      case as
      when :cairo
        process(magick2cairo(image), options, &block)
      when :magick
        process(Magick::ImageList.new << image, options, &block)
      end
    when Magick::ImageList
      case as
      when :cairo
        if block_given?
          process(process(image, options), options, &block)
        else
          result = CairoImageList.new
          image.each{|img| result << magick2cairo(img)}
          result
        end
      when :magick
        if block_given?
          result = []
          image.each{|img| result << yield(img)}
          Result.new(array2imagelist(result.flatten))
        else
          image
        end
      end
    when CairoImageList
      case as
      when :cairo
        if block_given?
          result = []
          image.each{|img| result << yield(img)}
          Result.new(array2imagelist(result.flatten))
        else
          image
        end
      when :magick
        if block_given?
          process(process(image, options), options, &block)
        else
          result = Magick::ImageList.new
          image.each{|img| result << cairo2magick(img)}
          result
        end
      end
    else
      raise 'never give up.'
    end
  end
end
