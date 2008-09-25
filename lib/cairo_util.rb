require 'cairo'
require 'RMagick'


class Cairo::Surface
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
  def cairo(width = 10, height = 10)
    context = Cairo::Context.new(Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, width, height))
    yield context
    context.target
  end

  def magick2cairo(image)
    image.format = "png"
    Cairo::ImageSurface.from_blob(image.to_blob)
  end

  def cairo2magick(image)
    img = Magick::Image.from_blob(image.to_blob).shift
    img.background_color = 'transparent'
    img
  end
end
