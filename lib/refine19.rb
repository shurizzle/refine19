require 'refine19/scope'

def using (*)
  p Refine::Scope.new(self, caller(1))
end
