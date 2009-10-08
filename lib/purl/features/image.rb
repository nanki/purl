module Purl
  module Features::Image
    class << self
      include ::Purl::Features::Limit

      def operators
        [
          Op.new(:geom, 1),
          Op.new(:crop, 5),
          Op.new(:composite, 2),
          Op.new(:rotate, 2),
          Op.new(:extend, 5, :_extend),
          Op.new('flip.x', 1, :flip_x),
          Op.new('flip.y', 1, :flip_y)
        ]
      end

      def geom(target)
        process(target, :as => :magick) do |img|
          return Result.new(img, img.columns, img.rows)
        end
      end

      def rotate(image, angle)
        process(image, :as => :magick) do |img|
          img.background_color = 'transparent'
          img.rotate!(angle)
        end
      end

      def _extend(image, x1, y1, x2, y2)
        process(image, :as => :magick) do |img|
          img.background_color = 'transparent'
          img.extent(img.columns + x1 + x2, img.rows + y1 + y2, -x1, -y1)
        end
      end

      def flip_x(image)
        process(image, :as => :magick) do |img|
          img.flop!
        end
      end

      def flip_y(image)
        process(image, :as => :magick) do |img|
          img.flip!
        end
      end

      def crop(image, x, y, w, h)
        process(image, :as => :magick) do |img|
          img.crop!(x, y, w, h, true)
        end
      end

      require 'rational'
      def composite(image1, image2)
        images1 = process(image1, :as => :magick)
        images2 = process(image2, :as => :magick)

        c1, c2 = 0, 0
        gcd, lcm = images1.size.gcdlcm(images2.size)

        result = Magick::ImageList.new
        while lcm > 0
          img1 = images1[c1]
          img2 = images2[c2]
          h = [img1.rows, img2.rows].max
          w = [img1.columns, img2.columns].max
          w = [w, @max_width].min
          h = [h, @max_height].min


          img2.background_color = 'transparent'

          img = img1.extent(w, h).composite(img2.extent(w, h), 0, 0, Magick::OverCompositeOp)

          # TODO: hmm...
          delay = (images1.size > images2.size) ? img1.delay : img2.delay
          img.delay = delay if delay
          result << img

          lcm -= 1
          c1 += 1;c1 %= images1.size
          c2 += 1;c2 %= images2.size
        end

        Result.new(result)
      end
    end
  end
end
