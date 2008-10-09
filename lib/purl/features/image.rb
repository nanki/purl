module Purl
  module Features::Image
    class << self
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

      def _extend(image, x1, y1, x2, y2)
        process(image, :as => :magick) do |img|
          img = img.extent(img.columns + x1 + x2, img.rows + y1 + y2, -x1, -y1)
          Result.new(img)
        end
      end

      def flip_x(image)
        process(image, :as => :magick) do |img|
          Result.new(image.flop!)
        end
      end

      def flip_y(image)
        process(image, :as => :magick) do |img|
          Result.new(image.flip!)
        end
      end

      def crop(image, x, y, w, h)
        process(image, :as => :magick) do |img|
          img.crop!(x, y, w, h, true)
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
end
