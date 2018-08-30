module BrDanfe
  module DanfeLib
    class Xprod
      def initialize(det)
        @det = det
      end

      def render
        xprod = "#{@det.css('prod/xProd').text}"

        xprod += infAdProd if has_infAdProd?
        xprod += fci if has_fci?
        xprod += st if has_st?
        xprod += fcp if has_fcp?

        xprod
      end

      private

      def infAdProd
        "\n" + @det.css("infAdProd").text
      end

      def has_infAdProd?
        !@det.css("infAdProd").text.empty?
      end

      def fci
        "\n" + I18n.t("danfe.det.prod.xProdFCI", nFCI: @det.css('prod/nFCI').text)
      end

      def has_fci?
        @det.css("prod/nFCI").present?
      end

      def st
        "\n" + I18n.t("danfe.det.prod.xProdST",
          pMVAST: Helper.numerify(@det.css('ICMS/*/pMVAST').text),
          pICMSST: Helper.numerify(@det.css('ICMS/*/pICMSST').text),
          vBCST: Helper.numerify(@det.css('ICMS/*/vBCST').text),
          vICMSST: Helper.numerify(@det.css('ICMS/*/vICMSST').text))
      end

      def has_st?
        @det.css("ICMS/*/vBCST").text.to_i > 0
      end

      def fcp
        "\n" + I18n.t("danfe.det.prod.xProdFCP",
          vFCP: Helper.numerify(@det.css("ICMS00/vFCP").text),
          pFCP: Helper.numerify(@det.css("ICMS00/pFCP").text))
      end

      def has_fcp?
        @det.css("ICMS00/vFCP").present?
      end
    end
  end
end
