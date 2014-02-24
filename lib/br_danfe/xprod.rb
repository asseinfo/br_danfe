module BrDanfe
  class Xprod
    def self.generate(det)
      xprod = "#{det.css('prod/xProd').text}"

      if has_infAdProd?(det)
        xprod += "\n"
        xprod += det.css("infAdProd").text
      end

      if has_fci?(det)
        xprod += "\n"
        xprod += I18n.t("danfe.det.prod.xProdFCI", nFCI: det.css('prod/nFCI').text)
      end

      if has_st?(det)
        xprod += "\n"
        xprod += I18n.t("danfe.det.prod.xProdST",
          pMVAST: det.css('ICMS/*/pMVAST').text,
          pICMSST: det.css('ICMS/*/pICMSST').text,
          vBCST: det.css('ICMS/*/vBCST').text,
          vICMSST: det.css('ICMS/*/vICMSST').text)
      end

      xprod
    end

    private
    def self.has_infAdProd?(det)
      !det.css("infAdProd").text.empty?
    end

    def self.has_fci?(det)
      !det.css("prod/nFCI").text.empty?
    end

    def self.has_st?(det)
      det.css("ICMS/*/vBCST").text.to_i > 0
    end
  end
end
