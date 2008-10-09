module Purl
  module Features::Stack
    class << self
      def operators
        [
          Op.new(:swap, 2),
          Op.new(:pop,  1),
          Op.new(:dump,-1),
          Op.new(:pull,-1),
          Op.new(:get, -1),
          Op.new(:dup, -1),
          Op.new(:slice, -1),
        ]
      end

      def swap(op1, op2)
        Result.new(op2, op1)
      end

      def pop(ignore)
        Result.new
      end

      def dump(*stack)
        stack.push(stack.inspect)
        Result.new(*stack)
      end

      def get(*stack)
        n = stack.pop
        v = stack[-n]
        d = v
        stack.push d
        Result.new(*stack)
      end

      def pull(*stack)
        i = stack.pop + 1
        v = stack.slice!(-i, 1).first
        d = v
        stack.push d
        Result.new(*stack)
      end

      def slice(*stack)
        n = stack.pop
        i = stack.pop + 1
        stack.concat stack.slice!(-i, n)
        Result.new(*stack)
      end

      def dup(*stack)
        v = stack.last
        d = v.dup rescue v
        stack.push d
        Result.new(*stack)
      end
    end
  end
end
