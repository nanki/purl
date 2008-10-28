module Purl
  module Features::Lambda
    class << self
      include ::Purl::Features::Limit

      def operators
        [
          Op.new(:call, 1),
          Op.new(:times, 2),
          Op.new(:each, -1),
          Op.new(:'each.n', -1, 'each_n'),
        ]
      end

      def call(macro)
        Result.new(*macro.dispatch)
      end

      def times(macro, n)
        n = [@max_n, n].min
        Result.new(*(macro.dispatch * n))
      end

      def each(*stack)
        n = [@max_n, stack.pop].min
        macro = stack.pop
        op = macro.dispatch

        stack.concat stack.slice!(-n, n).map{|v| [v, *op]}.flatten
        Result.new(*stack)
      end

      def each_n(*stack)
        n = [@max_n, stack.pop].min
        m = [@max_n, stack.pop].min
        macro = stack.pop

        op = macro.dispatch

        mn = m * n
        array = stack.slice!(- mn, mn)

        stack.concat((0...n).map{[array.slice!(0, m), *op]}.flatten)

        Result.new(*stack)
      end
    end
  end
end
