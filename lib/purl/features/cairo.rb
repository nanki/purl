module Purl
  module Features::Cairo
    class << self
      include ::Purl::Features::Limit

      def operators
        [
          Op.new(:ctx, 2),
          Op.new(:xtc, 1),
          Op.new(:rgb, 4),
          Op.new(:rgba, 5),
          Op.new(:gray, 2),
          Op.new(:pattern, 2),
          Op.new(:linewidth, 2),
          Op.new(:'linecap.butt', 1, :linecap_butt),
          Op.new(:'linecap.round', 1, :linecap_round),
          Op.new(:'linecap.square', 1, :linecap_square),
          Op.new(:stroke, 1),
          Op.new(:fill, 1),
          Op.new(:gap, 1),
          Op.new(:close, 1),
          Op.new(:moveto, 3),
          Op.new(:lineto, 3),
          Op.new(:arc, 6, :arc_cw),
          Op.new(:'arc.cw', 6, :arc_cw),
          Op.new(:'arc.ccw', 6, :arc_ccw),
          Op.new(:dash, -1),
          Macro.new(:circle, [0, 360, :arc])
        ]
      end

      def ctx(w, h)
        w = [w, @max_width].min
        h = [h, @max_height].min
        Result.new(cairo_context(w, h))
      end

      def xtc(ctx)
        Result.new(CairoImageList.new << ctx.target)
      end

      def rgb(ctx, r, g, b)
        ctx.set_source_rgb r, g, b
        Result.new(ctx)
      end

      def rgba(ctx, r, g, b, a)
        ctx.set_source_rgba r, g, b, a
        Result.new(ctx)
      end

      def gray(ctx, g)
        ctx.set_source_rgb g, g, g
        Result.new(ctx)
      end

      def pattern(ctx, pattern)
        ctx.set_source pattern
        Result.new(ctx)
      end

      def linewidth(ctx, w)
        ctx.set_line_width w
        Result.new(ctx)
      end

      def linecap_butt(ctx)
        ctx.set_line_cap Cairo::LineCap::BUTT
        Result.new(ctx)
      end

      def linecap_round(ctx)
        ctx.set_line_cap Cairo::LineCap::ROUND
        Result.new(ctx)
      end

      def linecap_square(ctx)
        ctx.set_line_cap Cairo::LineCap::SQUARE
        Result.new(ctx)
      end

      def stroke(ctx)
        ctx.stroke
        Result.new(ctx)
      end

      def fill(ctx)
        if ctx.has_current_point?
          ctx.fill
        else
          ctx.paint
        end
        
        Result.new(ctx)
      end

      # path
      def gap(ctx)
        ctx.new_sub_path
        Result.new(ctx)
      end

      def close(ctx)
        ctx.close_path
        Result.new(ctx)
      end

      def moveto(ctx, x, y)
        ctx.move_to x, y
        Result.new(ctx)
      end

      def lineto(ctx, x, y)
        ctx.line_to x, y
        Result.new(ctx)
      end

      RAD2DEG = Math::PI/180
      def arc_cw(ctx, x, y, radius, angle1, angle2)
        angle1 *= RAD2DEG
        angle2 *= RAD2DEG
        ctx.arc x, y, radius, angle1, angle2
        Result.new(ctx)
      end

      def arc_ccw(ctx, x, y, radius, angle1, angle2)
        angle1 *= RAD2DEG
        angle2 *= RAD2DEG
        ctx.arc_negative x, y, radius, angle1, angle2
        Result.new(ctx)
      end

      def dash(*stack)
        n = stack.pop
        dash = stack.slice!(-n, n)
        ctx = stack.last
        ctx.set_dash dash
        Result.new(*stack)
      end
    end
  end
end
