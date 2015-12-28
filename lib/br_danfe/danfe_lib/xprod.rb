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
        xprod += difal if has_difal?

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

      def has_difal?
        @det.css("ICMSUFDest").present?
      end

      def infAdProd
        "\n" + @det.css("infAdProd").text
      end

      def fci
        "\n" + I18n.t("danfe.det.prod.xProdFCI", nFCI: @det.css('prod/nFCI').text)
      end

      def st
        "\n" + I18n.t("danfe.det.prod.xProdST",
          pMVAST: Helper.numerify(@det.css('ICMS/*/pMVAST').text, 2),
          pICMSST: Helper.numerify(@det.css('ICMS/*/pICMSST').text, 2),
          vBCST: Helper.numerify(@det.css('ICMS/*/vBCST').text, 2),
          vICMSST: Helper.numerify(@det.css('ICMS/*/vICMSST').text, 2))
      end

      def difal
        "\n" + I18n.t("danfe.det.prod.xProdDIFAL",
          vBCUFDest: Helper.numerify(@det.css('ICMSUFDest/vBCUFDest').text, 2),
          pFCPUFDest: Helper.numerify(@det.css('ICMSUFDest/pFCPUFDest').text, 2),
          pICMSUFDest: Helper.numerify(@det.css('ICMSUFDest/pICMSUFDest').text, 2),
          pICMSInter: Helper.numerify(@det.css('ICMSUFDest/pICMSInter').text, 2),
          pICMSInterPart: @det.css('ICMSUFDest/pICMSInterPart').text,
          vFCPUFDest: Helper.numerify(@det.css('ICMSUFDest/vFCPUFDest').text, 2),
          vICMSUFDest: Helper.numerify(@det.css('ICMSUFDest/vICMSUFDest').text, 2),
          vICMSUFRemet: Helper.numerify(@det.css('ICMSUFDest/vICMSUFRemet').text, 2))
      end
    end
  end
end
