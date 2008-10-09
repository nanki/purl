module Purl
  module Features::ResizeMacro
    class << self
      attr_reader :large, :medium, :small
      
      def options=(options)
        options = {
          :large  => 240,
          :medium => 160, 
          :small  => 120
        }.merge(options)

        @large  = options[:large]
        @medium = options[:medium]
        @small  = options[:small]
      end

      def operators
        [ 
          Macro.new(:large , [@large , @large  * 0.75, :resize]),
          Macro.new(:medium, [@medium, @medium * 0.75, :resize]),
          Macro.new(:small , [@small , @small  * 0.75, :resize]),
          Macro.new( 'large.width' , [@large , :'resize.width' ]),
          Macro.new('medium.width' , [@medium, :'resize.width' ]),
          Macro.new( 'small.width' , [@small , :'resize.width' ]),
          Macro.new( 'large.height', [@large  * 0.75, :'resize.height']),
          Macro.new('medium.height', [@medium * 0.75, :'resize.height']),
          Macro.new( 'small.height', [@small  * 0.75, :'resize.height'])
        ]
      end
    end
  end
end
