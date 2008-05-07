module Purl
  class Result < Array
    def initialize(*args)
      super(args)
    end
  end

  class OperatorBase
    attr_reader :name, :operands
    def initialize(name, operands)
      @name = name
      @operands = operands
    end

    def dispatch(env, args);end
  end

  class Op < OperatorBase
    def initialize(name, operands, method_name = name)
      super(name, operands)
      @method_name = method_name
    end

    def dispatch(env, args)
      env.send(@method_name, *args)
    end
  end

  class Macro < OperatorBase
    def initialize(name, macro)
      super(name, 0)
      @macro = macro
    end

    def dispatch(env, args)
      Result.new(*@macro)
    end
  end

  class StackMachine
    attr_reader :stack
    def parse(sequence_string)
      sequence_string.scan(/\([^)]*\)|[^:]+/).map{|v| Float(v) rescue (/^\((.*)\)$/ === v ? $1 : v.intern)}
    end

    def initialize(sequence_string, environment)
      @seq = parse(sequence_string)
      @env = environment
      @stack = []
    end

    def run
      @seq.each{|op| process(op)}
      @stack
    end

    def process(op)
      if operator = @env.executable(op)
        n = operator.operands
        args = case n
        when 0
          []
        when -1
          @stack.slice!(0..-1)
        else
          @stack.slice!(-n..-1)
        end
        
        result = @env.dispatch(operator, args)

        result.each{|op| process(op)} if Result === result
      else
        @stack.push op
      end
    end
  end

  class Environment
    def initialize(*args)
      @operators = {}
    end

    def executable(name)
      @operators[name]
    end

    def dispatch(operator, args)
      operator.dispatch(self, args)
    end

    def add_operator(operator)
      @operators[operator.name] = operator
    end

    def load_feature(mod)
      extend mod
      mod.operators.each do |op|
        self.add_operator op
      end
    end
  end
end
