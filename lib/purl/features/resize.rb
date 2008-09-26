module Purl
  module Features::Resize
    def self.operators
      [ 
        Op.new(:resize, 3),
        Op.new('resize.upto', 3, :resize_upto),
        Op.new('resize.fitto', 3, :resize_fitto),
        Macro.new(:large , [250, 190, :resize]),
        Macro.new(:medium, [180, 135, :resize]),
        Macro.new(:small , [150, 115, :resize]),
        Macro.new(:thumb , [120,  90, :resize]),
        Macro.new('resize.width' , [:swap, :geom, :swap, :div, 2, :pull, :dup, 2, :pull, :mul,        :resize]),
        Macro.new('resize.height', [:swap, :geom,        :div, 2, :pull, :dup, 2, :pull, :mul, :swap, :resize]),

        Macro.new( 'large.width' , [250, :'resize.width' ]),
        Macro.new( 'large.height', [190, :'resize.height']),
        Macro.new('medium.width' , [180, :'resize.width' ]),
        Macro.new('medium.height', [135, :'resize.height']),
        Macro.new( 'small.width' , [150, :'resize.width' ]),
        Macro.new( 'small.height', [115, :'resize.height']),
        Macro.new( 'thumb.width' , [120, :'resize.width' ]),
        Macro.new( 'thumb.height', [ 90, :'resize.height']),
      ]
    end

    def resize(image, w, h)
      process(image, :as => :magick) do |img|
        img.crop_resized!(w, h, Magick::CenterGravity)
        Result.new(img)
      end
    end

    def resize_fitto(image, w, h)
      process(image, :as => :magick) do |img|
        img.change_geometry!("#{w}x#{h}") do |cols, rows, img|
          img.resize!(cols, rows)
        end

        Result.new(img)
      end
    end

    def resize_upto(image, w, h)
      process(image, :as => :magick) do |img|
        unless img.columns < w && img.rows < h
          img.change_geometry!("#{w}x#{h}") do |cols, rows, img|
            img.resize!(cols, rows)
          end
        end

        Result.new(img)
      end
    end
  end
end
