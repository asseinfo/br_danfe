module BrDanfe
  module CceLib
    class Protocol
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = Nokogiri::XML(xml)
      end

      def render
        @pdf.box(height: 36) do
          @pdf.text I18n.t("cce.protocol"), size: 8, style: :bold
          @pdf.text protocol, pad: 5
        end
      end

      private
      def protocol
        node = @xml.css("procEventoNFe > retEvento > infEvento > nProt")
        return node ? node.text : ""
      end
    end
  end
end
