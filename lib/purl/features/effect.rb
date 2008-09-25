module Purl
  module Features::Effect
    include ::CairoUtil
    def self.operators
      [ 
        Op.new(:round, 2),
        Macro.new(:dropshadow, [:swap, :dup, 2, :pull, :shadow, :swap, :composite])
      ]
    end

    def round(image, r)
      r = [r, 50].min
      process(image, :as => :cairo) do |img|
        img = cairo(img.width, img.height) do |ctx|
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
        Result.new(img)
      end
    end
  end
end
