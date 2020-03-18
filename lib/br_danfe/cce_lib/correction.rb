module BrDanfe
  module CceLib
    class Correction
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = Nokogiri::XML(xml)
      end

      def render
        @pdf.box(height: 490) do
          @pdf.text correction
        end
      end

      private

      def correction
        node = @xml.css('procEventoNFe > evento > infEvento > detEvento > xCorrecao')
        node ? node.text : ''
      end
    end
  end
end
