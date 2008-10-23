module Purl
  module Features::CairoGradient
    class << self
      def operators
        [
          Op.new(:'grad.linear', 4, :grad_linear),
          Op.new(:'grad.radial', 6, :grad_radial),
          Op.new(:'grad.concentric', 4, :grad_concentric),
          Op.new(:rgbo, 5, :rgb_stop),
          Op.new(:rgbao, 6, :rgba_stop),
        ]
      end

      def grad_linear(x1, y1, x2, y2)
        Result.new(::Cairo::LinearPattern.new(x1, y1, x2, y2))
      end

      def grad_radial(x1, y1, r1, x2, y2, r2)
        Result.new(::Cairo::RadialPattern.new(x1, y1, r1, x2, y2, r2))
      end

      def grad_concentric(x, y, r1, r2)
        Result.new(::Cairo::RadialPattern.new(x, y, r1, x, y, r2))
      end

      def rgb_stop(grad, r, g, b, offset)
        raise UnexpectedArgument unless ::Cairo::GradientPattern === grad
        grad.add_color_stop_rgb offset, r, g, b
        
        Result.new(grad)
      end

      def rgba_stop(grad, r, g, b, a, offset)
        raise UnexpectedArgument unless ::Cairo::GradientPattern === grad
        grad.add_color_stop_rgba offset, r, g, b, a
        
        Result.new(grad)
      end
    end
  end
end
