module Purl
  module Features::Arithmetic
    class << self
      def operators
        [
          Op.new(:add, 2),
          Op.new(:sub, 2),
          Op.new(:mul, 2),
          Op.new(:div, 2),
          Op.new(:mod, 2),
          Op.new('add.2', 3, :add_2),
          Op.new('sub.2', 3, :sub_2),
          Op.new('mul.2', 3, :mul_2),
          Op.new('div.2', 3, :div_2),
          Op.new('mod.2', 3, :mod_2),
        ]
      end

      def add(op1, op2)
        Result.new(op1 + op2)
      end

      def sub(op1, op2)
        Result.new(op1 - op2)
      end

      def mul(op1, op2)
        Result.new(op1 * op2)
      end

      def div(op1, op2)
        Result.new(op1.quo(op2).to_f)
      end

      def mod(op1, op2)
        Result.new(op1 % op2)
      end

      # for vector
      def add_2(op1, op2, num)
        Result.new(op1 + num, op2 + num)
      end

      def sub_2(op1, op2, num)
        Result.new(op1 - num, op2 - num)
      end

      def mul_2(op1, op2, num)
        Result.new(op1 * num, op2 * num)
      end

      def div_2(op1, op2, num)
        Result.new(op1.quo(num), op2.quo(num))
      end

      def mod_2(op1, op2, num)
        Result.new(op1 % num, op2 % num)
      end
    end
  end
end
