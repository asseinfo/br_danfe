module BrDanfe
  module DanfeLib
    class Xprod
      def initialize(det)
        @det = det
      end

      def render
        xprod = "#{@det.css('prod/xProd').text}"

        xprod += infAdProd if has_infAdProd?
        xprod += fci if fci?
        xprod += icms_st if icms_st?
        xprod += fcp if fcp?
        xprod += fcp_st if fcp_st?
        xprod += add_icms_st_ret_to_product

        xprod
      end

      private

      def infAdProd
        "\n#{@det.css('infAdProd').text}"
      end

      def has_infAdProd?
        !@det.css("infAdProd").text.empty?
      end

      def fci
        "\n#{I18n.t('danfe.det.prod.xProdFCI',
          nFCI: @det.css('prod/nFCI').text)}"
      end

      def fci?
        !@det.css('prod/nFCI').text.empty?
      end

      def icms_st
        "\n#{I18n.t('danfe.det.prod.xProdST',
          pMVAST: Helper.numerify(@det.css('ICMS/*/pMVAST').text),
          pICMSST: Helper.numerify(@det.css('ICMS/*/pICMSST').text),
          vBCST: Helper.numerify(@det.css('ICMS/*/vBCST').text),
          vICMSST: Helper.numerify(@det.css('ICMS/*/vICMSST').text))}"
      end

      def icms_st?
        @det.css('ICMS/*/vBCST').text.to_i > 0
      end

      def fcp?
        @det.css('ICMS/*/vFCP').text.to_i > 0
      end

      def fcp
        icms00? ? fcp_for_icms00 : fcp_complete
      end

      def icms00?
        @det.at_css('ICMS00')
      end

      def fcp_for_icms00
        "\n#{I18n.t('danfe.det.prod.xProdFCPICMS00',
          vFCP: Helper.numerify(@det.css('ICMS00/vFCP').text),
          pFCP: Helper.numerify(@det.css('ICMS00/pFCP').text))}"
      end

      def fcp_complete
        "\n#{I18n.t('danfe.det.prod.xProdFCP',
          vBCFCP: Helper.numerify(@det.css('ICMS/*/vBCFCP').text),
          vFCP: Helper.numerify(@det.css('ICMS/*/vFCP').text),
          pFCP: Helper.numerify(@det.css('ICMS/*/pFCP').text))}"
      end

      def fcp_st?
        @det.css('ICMS/*/vFCPST').text.to_i > 0
      end

      def fcp_st
        "\n#{I18n.t('danfe.det.prod.xProdFCPST',
          vBCFCPST: Helper.numerify(@det.css('ICMS/*/vBCFCPST').text),
          pFCPST: Helper.numerify(@det.css('ICMS/*/pFCPST').text),
          vFCPST: Helper.numerify(@det.css('ICMS/*/vFCPST').text))}"
      end

      def add_icms_st_ret_to_product
        icms_st_ret? ? icms_st_ret : ''
      end

      def icms_st_ret?
        @det.css('ICMS/*/vBCSTRet').text.to_i > 0 ||
          @det.css('ICMS/*/vICMSSTRet').text.to_i > 0 ||
          @det.css('ICMS/*/pST').text.to_i > 0
      end

      def icms_st_ret
        "\n#{I18n.t(
          'danfe.det.prod.xProdSTRet',
          vBCSTRet: Helper.numerify(@det.css('ICMS/*/vBCSTRet').text),
          vICMSSTRet: Helper.numerify(@det.css('ICMS/*/vICMSSTRet').text),
          pST: Helper.numerify(@det.css('ICMS/*/pST').text)
        )}"
      end
    end
  end
end
