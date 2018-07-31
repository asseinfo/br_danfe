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

      def version_is_310_or_newer?
        @xml.css("infNFe").attr("versao").to_s.to_f >= 3.10
      end
    end
  end
end
