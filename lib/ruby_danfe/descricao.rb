module RubyDanfe
  class Descricao
    def self.generate(det)
      descricao = "#{det.css('prod/xProd').text}"

      if need_infAdProd(det)
        descricao += "\n"
        descricao += det.css("infAdProd").text
      end

      if need_fci(det)
        descricao += "\n"
        descricao += I18n.t("danfe.det.prod.xProdFCI", nFCI: det.css('prod/nFCI').text)
      end

      if need_st(det)
        descricao += "\n"
        descricao += I18n.t("danfe.det.prod.xProdST",
          pMVAST: det.css('ICMS/*/pMVAST').text,
          pICMSST: det.css('ICMS/*/pICMSST').text,
          vBCST: det.css('ICMS/*/vBCST').text,
          vICMSST: det.css('ICMS/*/vICMSST').text)
      end

      descricao
    end

    private
    def self.need_infAdProd(det)
      !det.css("infAdProd").text.empty?
    end

    def self.need_fci(det)
      !det.css("prod/nFCI").text.empty?
    end

    def self.need_st(det)
      det.css("ICMS/*/vBCST").text.to_i > 0
    end
  end
end
