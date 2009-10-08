require 'cairo'
require 'RMagick'


class Cairo::Surface
  attr_accessor :delay
  def to_blob
    io = StringIO.new
    self.write_to_png(io)
    #self.finish
    io.string
  end

  def dup
    self.class.from_blob(self.to_blob)
  end

  def self.from_blob(png_blob)
    from_png(StringIO.new(png_blob))
  end
end

module CairoUtil
  class CairoImageList < Array
  end
  
  def cairo(width = 10, height = 10)
    context = cairo_context(width, height)
    yield context
    CairoImageList.new << context.target
  end

  def cairo_context(width = 10, height = 10)
    Cairo::Context.new(Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, width, height))
  end

  def magick2cairo(image)
    image.format = "png"
    new_image = Cairo::ImageSurface.from_blob(image.to_blob)
    new_image.delay = image.delay if image.delay
    new_image
  end

  def cairo2magick(image)
    new_image = Magick::Image.from_blob(image.to_blob).shift
    new_image.background_color = 'transparent'
    new_image.delay = image.delay if image.delay
    new_image
  end

  def array2imagelist(array)
    if array.all?{|v| Cairo::ImageSurface === v}
      result = CairoImageList.new
    elsif array.all?{|v| Magick::Image === v}
      result = Magick::ImageList.new
    else
      array.each do |v| 
        Rails.logger.debug v.class 
      end
      
      raise 'All images need to be same format.'
    end
    array.each{|v| result << v}
    result 
  end
end
