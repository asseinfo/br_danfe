module BrDanfe
  module CceLib
    class Barcode
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = Nokogiri::XML(xml)
      end

      def render
        @pdf.box(height: 50) do
          @pdf.move_down 40
          barcode = Barby::Code128C.new(nfe_key)
          barcode.annotate_pdf(@pdf, x: @pdf.cursor, y: @pdf.cursor, height: 40)
        end
      end

      private

      def nfe_key
        node = @xml.css('procEventoNFe > evento > infEvento > chNFe')
        node ? node.text : ''
      end
    end
  end
end
