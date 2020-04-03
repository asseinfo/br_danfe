module BrDanfe
  module DanfeLib
    module NfeLib
      class Plate
        def self.format(plate)
          plate.delete('-').sub(/([A-Za-z]{3})/, '\\1-')
        end
      end
    end
  end
end
