module BrDanfe
  class Dest
    def self.render(pdf, xml)
      pdf.ititle 0.42, 10.00, 0.25, 8.16, "dest.title"

      pdf.lbox 0.85, 12.32, 0.25, 8.58, xml, "dest/xNome"
      pdf.ibox 0.85, 5.33, 12.57, 8.58, I18n.t("danfe.dest.CNPJ"), Cnpj.format(xml["dest/CNPJ"])  if xml["dest/CNPJ"] != ""
      pdf.ibox 0.85, 5.33, 12.57, 8.58, I18n.t("danfe.dest.CPF"), Cpf.format(xml["dest/CPF"]) if xml["dest/CPF"] != ""
      pdf.idate 0.85, 2.92, 17.90, 8.58, "ide.dEmi", xml["ide/dEmi"], {align: :right}
      pdf.ibox 0.85, 10.16, 0.25, 9.43, I18n.t("danfe.enderDest.xLgr"), xml["enderDest/xLgr"] + " " + xml["enderDest/nro"]
      pdf.lbox 0.85, 4.83, 10.41, 9.43, xml, "enderDest/xBairro"
      pdf.ibox 0.85, 2.67, 15.24, 9.43, I18n.t("danfe.enderDest.CEP"), Cep.format(xml["enderDest/CEP"])
      pdf.idate 0.85, 2.92, 17.90, 9.43, "ide.dSaiEnt", xml["ide/dSaiEnt"], {align: :right}
      pdf.lbox 0.85, 7.11, 0.25, 10.28, xml, "enderDest/xMun"
      pdf.ibox 0.85, 4.06, 7.36, 10.28, I18n.t("danfe.enderDest.fone"), Phone.format(xml["enderDest/fone"])
      pdf.lbox 0.85, 1.14, 11.42, 10.28, xml, "enderDest/UF"
      pdf.ibox 0.85, 5.33, 12.56, 10.28, I18n.t("danfe.dest.IE"), Ie.format(xml["dest/IE"], xml["enderDest/UF"])
      pdf.idate 0.85, 2.92, 17.90, 10.28, "ide.hSaiEnt", xml["ide/dSaiEnt"], {align: :right}
    end
  end
end
