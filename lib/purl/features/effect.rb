module Purl
  module Features::Effect
    def self.operators
      [ 
        Macro.new(:dropshadow, [:swap, :dup, 2, :pull, :shadow, :swap, :composite])
      ]
    end
  end
end
