module BrDanfe
  module CceLib
    class NfeKey
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = Nokogiri::XML(xml)
      end

      def render
        @pdf.box(height: 36) do
          @pdf.text I18n.t("cce.key"), size: 8, style: :bold
          @pdf.text nfe_key, pad: 5
        end
      end

      private
      def nfe_key
        node = @xml.css("procEventoNFe > evento > infEvento > chNFe")
        return node ? node.text : ""
      end
    end
  end
end
