module Purl
  module Features::Effect
    class << self
      def operators
        [ 
          Op.new(:blur, 2),
          Op.new(:round, 2),
          Op.new(:shadow, 2),
          Op.new(:opacify, 2),
          Macro.new(:dropshadow, [:swap, :dup, 2, :pull, :shadow, :swap, :composite])
        ]
      end

      def blur(image, r)
        return Result.new(image) if r.zero?

        r = [r, 10].min
        d = r.quo(2.75)
        process(image, :as => :magick) do |img|
          img.blur_channel(0, d, Magick::AllChannels)
        end
      end

      def round(image, r)
        r = [r, 50].min
        process(image, :as => :cairo) do |img|
          cairo(img.width, img.height) do |ctx|
            w = img.width
            h = img.height
            c = [r, w / 2, h / 2].min
            mr = [2 * c - r, r].min
            
            ctx.arc c    ,     c, mr,  Math::PI    , -Math::PI / 2
            ctx.arc w - c,     c, mr, -Math::PI / 2,  0
            ctx.arc w - c, h - c, mr,  0           ,  Math::PI / 2
            ctx.arc c    , h - c, mr,  Math::PI / 2,  Math::PI
            ctx.close_path              
            ctx.clip

            ctx.set_source(img, 0, 0)
            ctx.paint
          end
        end
      end

      def shadow(image, r)
        r = [r, 10].min
        d = r.quo(2.75)
        process(image, :as => :magick) do |img|
          shadow = magick2cairo(img.blur_channel(0, d, Magick::AlphaChannel))

          cairo(img.columns, img.rows) do |c|
            c.identity_matrix
            c.set_source_rgba 0, 0, 0, 1
            c.mask shadow, 0, 0
          end
        end
      end

      def opacify(image, opacify)
        process(image, :as => :cairo) do |img|
          cairo(img.width, img.height) do |ctx|
            ctx.set_source(img, 0, 0)
            ctx.paint opacify
          end
        end
      end
    end
  end
end
