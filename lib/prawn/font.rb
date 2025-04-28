module Prawn
  class Font
    def hash # :nodoc:
      [self.class, name, family].hash
    end
  end
end
