module Purl
  class UnexpectedArgument < StandardError;end
  
  class Result < Array
    def initialize(*args)
      super(args)
    end
  end

  class OperatorBase
    attr_reader :name, :operands
    def initialize(name, operands)
      @name = name.to_sym
      @operands = operands
    end

    attr_accessor :mod
    def dispatch(args = nil);end
  end

  class Op < OperatorBase
    def initialize(name, operands, method_name = name)
      super(name, operands)
      @method_name = method_name.to_sym
    end

    def dispatch(args = nil)
      @mod.send(@method_name, *args)
    end
  end

  class Macro < OperatorBase
    def initialize(name = 'lambda', macro = [])
      super(name, 0)
      @macro = macro
    end

    def dispatch(args = nil)
      Result.new(*@macro)
    end

    def push(op)
      @macro.push op
    end
  end

  class StackMachine
    attr_reader :stack

    def parse(sequence_string)
      sequence_string.split(":").reject(&:blank?).map{|v| Float(v) rescue (/^\((.*)\)$/ === v ? $1 : v.intern)}
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
      case 
      when op == :'['
        self.open_stack.push Macro.new
      when op == :']'
        raise "" unless Macro === self.open_stack
        self.open_stack.close
      when Macro === self.open_stack
        self.open_stack.push op
      when operator = @env.executable(op)
        result = @env.dispatch(operator, fetch_operands(operator.operands))
        result.each{|op| process(op)} if Result === result
      else
        @stack.push op
      end
    end

    private
    def fetch_operands(n)
      case n
      when 0
        []
      when -1
        @stack.slice!(0..-1)
      else
        @stack.slice!(-n..-1)
      end
    end
  end

  class Macro
    def open?
      @open = @open.nil? || @open
    end

    def close
      @open = false
    end

    def open_stack
      (@macro.last.respond_to?(:open_stack) && @macro.last.open_stack) || (self.open? && self) || nil
    end
  end
  
  class StackMachine
    def open_stack
      (@stack.last.respond_to?(:open_stack) && @stack.last.open_stack) || @stack
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
      operator.dispatch(args)
    end

    def add_operator(operator)
      @operators[operator.name] = operator
    end

    def load_feature(mod, options = {})
      class << mod
        include ::Purl
      end

      if mod.respond_to?(:options=)
        mod.options = options
      end
      
      mod.operators.each do |op|
        op.mod = mod
        self.add_operator op
      end
    end
  end
end
