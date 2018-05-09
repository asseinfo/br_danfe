module BrDanfe
  module DanfeLib
    class XML
      def css(xpath)
        @xml.css(xpath)
      end

      def initialize(xml)
        @xml = Nokogiri::XML(xml)
      end

      def [](xpath)
        node = @xml.css(xpath)
        return node ? node.text : ""
      end

      def collect(ns, tag, &block)
        result = []
        # Tenta primeiro com uso de namespace
        begin
          @xml.xpath("//#{ns}:#{tag}").each do |det|
            result << yield(det)
          end
        rescue
          # Caso dê erro, tenta sem
          @xml.xpath("//#{tag}").each do |det|
            result << yield(det)
          end
        end
        result
      end

      def version_310?
        @xml.css("infNFe").attr("versao").to_s == "3.10"
      end
      
      def version_400?
        @xml.css("infNFe").attr("versao").to_s == "4.00"
      end
    end
  end
end
