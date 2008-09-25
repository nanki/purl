module Purl
  module Features::Image
    include ::Purl
    include ::CairoUtil
    def self.operators
      [ Op.new(:geom, 1),
        Op.new(:crop, 5),
        Op.new(:blur, 2),
        Op.new(:shadow, 2),
        Op.new(:composite, 2),
        Op.new(:rotate, 2),
        Op.new(:extend, 5, :_extend),
        Op.new(:opacify, 2)]
    end

    def geom(image)
      process(image, :as => :magick) do |img|
        Result.new(image, img.columns, img.rows)
      end
    end

    def rotate(image, angle)
      process(image, :as => :magick) do |img|
        img.background_color = 'transparent'
        img.rotate!(angle)
        Result.new(img)
      end
    end

    def opacify(image, opacify)
      process(image, :as => :cairo) do |img|
        img = cairo(img.width, img.height) do |ctx|
          ctx.set_source(img, 0, 0)
          ctx.paint opacify
        end
        Result.new(img)
      end
    end

    def _extend(image, x1, y1, x2, y2)
      process(image, :as => :magick) do |img|
        img = img.extent(img.columns + x1 + x2, img.rows + y1 + y2, -x1, -y1)
        Result.new(img)
      end
    end

    def crop(image, x, y, w, h)
      process(image, :as => :magick) do |img|
        img.crop!(x, y, w, h, true)
        Result.new(img)
      end
    end

    def blur(image, r)
      r = [r, 10].min
      d = r.quo(2.75)
      process(image, :as => :magick) do |img|
        img = img.blur_image(0, d) unless r.zero?
        Result.new(img)
      end
    end

    def shadow(image, r)
      r = [r, 10].min
      d = r.quo(2.75)
      process(image, :as => :magick) do |img|
        shadow = magick2cairo(img.blur_channel(0, d, Magick::AlphaChannel))

        img = cairo(img.columns, img.rows) do |c|
          c.identity_matrix
          c.set_source_rgba 0, 0, 0, 1
          c.mask shadow, 0, 0
        end
        Result.new(img)
      end
    end

    def composite(image1, image2)
      process(image1, :as => :magick) do |img1|
        process(image2, :as => :magick) do |img2|
          Result.new(img1.composite(img2, 0, 0, Magick::OverCompositeOp))
        end
      end
    end
  end
end
