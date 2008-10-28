module Purl
  module Features::Limit
    def self.included(base)
      base.class_eval do
        attr_reader :max_width, :max_height, :max_n
        def options=(options)
          options = {
            :max_width  => 1024,
            :max_height => 1024,
            :max_n      => 10,
          }.merge(options)

          @max_width  = options[:max_width]
          @max_height = options[:max_height]
          @max_n = options[:max_n]
        end
      end
    end
  end
end
