module BrDanfe
  module DanfeNfceLib
    class Footer
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def render
        tot_trib = @xml['ICMSTot/vTotTrib'].present? ? BrDanfe::Helper.numerify(@xml['ICMSTot/vTotTrib']) : '0,00'
        @pdf.text "Tributos Totais Incidentes (Lei Federal 12.741/2012): R$ #{tot_trib}", size: 5, align: :center
      end
    end
  end
end
