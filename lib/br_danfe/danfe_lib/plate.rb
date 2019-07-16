module BrDanfe
  module DanfeLib
    class Plate
      def self.format(plate)
        plate.gsub('-','').sub(/([A-Za-z]{3})/, "\\1-")
      end
    end
  end
end
