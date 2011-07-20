module Refine
  class Scope
    class InstanceMethod < Struct.new(:class, :method)
      def =~ (scope)
        case scope
        when InstanceMethod
          self.class == scope.class and self.method == scope.method
        when SingletonMethod
          false
        when Object
          !!(self.class.name =~ /^#{Regexp.escape(scope.class.name)}/)
        end
      end

      def to_s
        "#{self.class}##{method}"
      end
      alias inspect to_s
    end

    class SingletonMethod < Struct.new(:class, :method)
      def =~ (scope)
        case scope
        when SingletonMethod
          self.class == scope.class and self.method == scope.method
        when InstanceMethod
          false
        when Object
          !!(self.class.name =~ /^#{Regexp.escape(scope.class.name)}/)
        end
      end

      def to_s
        "#{self.class}.#{method}"
      end
      alias inspect to_s
    end

    class Object < Struct.new(:class)
      def =~ (scope)
        case scope
        when SingletonMethod
          false
        when InstanceMethod
          false
        when Object
          !!(self.class.name =~ /^#{Regexp.escape(scope.class.name)}/)
        end
      end

      def to_s
        "#{self.class}"
      end
      alias inspect to_s
    end

    def self.new(klass, call)
      meth = call[0][/`(.+?)'$/][1..-2]

      meth = '<main>' if meth == '__script__'
      meth = "<#{$1}:#{klass.is_a?(Class) ? klass : klass.name}>" if meth =~ /__(class|module)_init__/

      if meth == '<main>' and klass.is_a?(::Object)
        SingletonMethod.new(::Object, '<main>')
      elsif meth =~ /^<(class|module):/
        Object.new(klass)
      else
        if klass.is_a?(Class)
          SingletonMethod.new(klass, meth)
        else
          InstanceMethod.new(klass.class, meth)
        end
      end
    end
  end
end
