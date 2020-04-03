module BrDanfe
  module DanfeLib
    module NfeLib
      class Cst
        def self.to_danfe(xml)
          value = origin(xml)

          if csosn?(xml)
            value += xml.css('ICMS/*/CSOSN').text
          elsif cst?(xml)
            value += xml.css('ICMS/*/CST').text
          end

          value
        end

        def self.origin(xml)
          xml.css('ICMS/*/orig').text
        end
        private_class_method :origin

        def self.cst?(xml)
          xml.css('ICMS/*/CST').text != ''
        end
        private_class_method :cst?

        def self.csosn?(xml)
          xml.css('ICMS/*/CSOSN').text != ''
        end
        private_class_method :csosn?
      end
    end
  end
end
