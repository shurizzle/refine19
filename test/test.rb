begin
  require 'refine19'
rescue LoadError
  $:.unshift File.realpath(File.join('..', '..', 'lib'), __FILE__)
  retry
end


class Test
  using

  module Penis
    using
  end

  class Cacca
    using

    def initialize
      using
    end
  end

  def self.cacca
    using
  end
end

Test::Cacca.new
Test.cacca
using

p Refine::Scope.new(Test::Cacca, ["`initialize'"]) =~ Refine::Scope.new(Test, ["`<class:'"])
