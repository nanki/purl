module Purl
  module Features::Resize
    class << self
      include ::Purl::Features::Limit

      def operators
        [ 
          Op.new(:resize, 3),
          Op.new('resize.upto', 3, :resize_upto),
          Op.new('resize.fitto', 3, :resize_fitto),
          Macro.new('resize.width' , [:swap, :geom, :swap, :div, 2, :pull, :dup, 2, :pull, :mul,        :resize]),
          Macro.new('resize.height', [:swap, :geom,        :div, 2, :pull, :dup, 2, :pull, :mul, :swap, :resize]),
        ]
      end

      def resize(image, w, h)
        w = [w, @max_width].min
        h = [h, @max_height].min
        process(image, :as => :magick) do |img|
          img.crop_resized!(w, h, Magick::CenterGravity)
        end
      end

      def resize_fitto(image, w, h)
        w = [w, @max_width].min
        h = [h, @max_height].min
        process(image, :as => :magick) do |img|
          img.change_geometry!("#{w}x#{h}") do |cols, rows, img|
            img.resize!(cols, rows)
          end

          img
        end
      end

      def resize_upto(image, w, h)
        w = [w, @max_width].min
        h = [h, @max_height].min
        process(image, :as => :magick) do |img|
          unless img.columns < w && img.rows < h
            img.change_geometry!("#{w}x#{h}") do |cols, rows, img|
              img.resize!(cols, rows)
            end
          end

          img
        end
      end
    end
  end
end
