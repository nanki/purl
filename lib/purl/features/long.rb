module Purl
  module Features::Long
    class << self
      def operators
        [Op.new(:/, 0, 'nop')]
      end

      def nop
        Result.new
      end
    end
  end
end
