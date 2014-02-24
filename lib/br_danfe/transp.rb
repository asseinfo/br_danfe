module BrDanfe
  class Transp
    def self.render(pdf, xml)
      pdf.ititle 0.42, 10.00, 0.25, 14.48, "transporta.title"

      pdf.lbox 0.85, 9.02, 0.25, 14.90, xml, "transporta/xNome"
      pdf.ibox 0.85, 2.79, 9.27, 14.90, I18n.t("danfe.transp.modFrete.title"), xml["transp/modFrete"] == "0" ? I18n.t("danfe.transp.modFrete.emitter") : I18n.t("danfe.transp.modFrete.recipient")
      pdf.lbox 0.85, 1.78, 12.06, 14.90, xml, "veicTransp/RNTC"
      pdf.ibox 0.85, 2.29, 13.84, 14.90, I18n.t("danfe.veicTransp.placa"), Plate.format(xml["veicTransp/placa"])
      pdf.lbox 0.85, 0.76, 16.13, 14.90, xml, "veicTransp/UF"
      pdf.lbox 0.85, 3.94, 16.89, 14.90, xml, "transporta/CNPJ"
      pdf.lbox 0.85, 9.02, 0.25, 15.75, xml, "transporta/xEnder"
      pdf.lbox 0.85, 6.86, 9.27, 15.75, xml, "transporta/xMun"
      pdf.lbox 0.85, 0.76, 16.13, 15.75, xml, "transporta/UF"
      pdf.lbox 0.85, 3.94, 16.89, 15.75, xml, "transporta/IE"
    end
  end
end
