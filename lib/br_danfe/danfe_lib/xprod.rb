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

        xprod
      end

      private
      def has_infAdProd?
        !@det.css("infAdProd").text.empty?
      end

      def has_fci?
        !@det.css("prod/nFCI").text.empty?
      end

      def has_st?
        @det.css("ICMS/*/vBCST").text.to_i > 0
      end

      def infAdProd
        "\n" + @det.css("infAdProd").text
      end

      def fci
        "\n" + I18n.t("danfe.det.prod.xProdFCI", nFCI: @det.css('prod/nFCI').text)
      end

      def st
        "\n" + I18n.t("danfe.det.prod.xProdST",
          pMVAST: Helper.numerify(@det.css('ICMS/*/pMVAST').text),
          pICMSST: Helper.numerify(@det.css('ICMS/*/pICMSST').text),
          vBCST: Helper.numerify(@det.css('ICMS/*/vBCST').text),
          vICMSST: Helper.numerify(@det.css('ICMS/*/vICMSST').text))
      end
    end
  end
end
