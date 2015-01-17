module BrDanfe
  class Transp
    Y = 14.47 + SPACE_BETWEEN_GROUPS

    def initialize(pdf, xml)
      @pdf = pdf
      @xml = xml

      @ltitle = Y - 0.42
      @l1 = Y
      @l2 = Y + LINE_HEIGHT
    end

    def render
      @pdf.ititle 0.42, 10.00, 0.25, @ltitle, "transporta.title"

      @pdf.lbox LINE_HEIGHT, 9.02, 0.25, @l1, @xml, "transporta/xNome"
      @pdf.ibox LINE_HEIGHT, 2.79, 9.27, @l1, I18n.t("danfe.transp.modFrete.title"), @xml["transp/modFrete"] == "0" ? I18n.t("danfe.transp.modFrete.emitter") : I18n.t("danfe.transp.modFrete.recipient")
      @pdf.lbox LINE_HEIGHT, 1.78, 12.06, @l1, @xml, "veicTransp/RNTC"
      @pdf.ibox LINE_HEIGHT, 2.29, 13.84, @l1, I18n.t("danfe.veicTransp.placa"), Plate.format(@xml["veicTransp/placa"])
      @pdf.lbox LINE_HEIGHT, 0.76, 16.13, @l1, @xml, "veicTransp/UF"
      @pdf.lbox LINE_HEIGHT, 3.94, 16.89, @l1, @xml, "transporta/CNPJ"
      @pdf.lbox LINE_HEIGHT, 9.02, 0.25, @l2, @xml, "transporta/xEnder"
      @pdf.lbox LINE_HEIGHT, 6.86, 9.27, @l2, @xml, "transporta/xMun"
      @pdf.lbox LINE_HEIGHT, 0.76, 16.13, @l2, @xml, "transporta/UF"
      @pdf.lbox LINE_HEIGHT, 3.94, 16.89, @l2, @xml, "transporta/IE"
    end
  end
end
