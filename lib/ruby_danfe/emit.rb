module RubyDanfe
  class Emit
    def self.render(pdf, xml, logo_path)
      if logo_path.empty?
        pdf.ibox 3.92, 8.46, 0.25, 2.80, "", xml["emit/xNome"], {size: 12, align: :center, border: 0, style: :bold}
        pdf.ibox 3.92, 8.46, 0.25, 2.54, "",
          "\n" + xml["enderEmit/xLgr"] + ", " + xml["enderEmit/nro"] + "\n" +
          xml["enderEmit/xBairro"] + " - " + Cep.format(xml["enderEmit/CEP"]) + "\n" +
          xml["enderEmit/xMun"] + "/" + xml["enderEmit/UF"] + "\n" +
          Phone.format(xml["enderEmit/fone"]) + " " + xml["enderEmit/email"], {align: :center, valign: :center}
      else
        pdf.ibox 3.92, 8.46, 0.25, 2.54
        pdf.ibox 3.92, 8.46, 0.25, 2.80, "", xml["emit/xNome"], {size: 12, align: :center, border: 0, style: :bold}
        pdf.ibox 3.92, 8.46, 2.75, 4, "",
          xml["enderEmit/xLgr"] + ", " + xml["enderEmit/nro"] + "\n" +
          xml["enderEmit/xBairro"] + " - " + Cep.format(xml["enderEmit/CEP"]) + "\n" +
          xml["enderEmit/xMun"] + "/" + xml["enderEmit/UF"] + "\n" +
          Phone.format(xml["enderEmit/fone"]) + " " + xml["enderEmit/email"], {size: 8, align: :left, border: 0, style: :bold}
        pdf.image logo_path, at: [0.5.cm, Helper.invert(4.cm)], width: 2.cm
      end

      pdf.ibox 3.92, 2.08, 8.71, 2.54

      pdf.ibox 0.60, 2.08, 8.71, 2.54, "", "DANFE", {size: 12, align: :center, border: 0, style: :bold}
      pdf.ibox 1.20, 2.08, 8.71, 3.14, "", I18n.t("danfe.others.danfe"), {size: 8, align: :center, border: 0}
      pdf.ibox 0.60, 2.08, 8.71, 4.34, "", "#{xml['ide/tpNF']} - " + (xml["ide/tpNF"] == "0" ? I18n.t("danfe.ide.tpNF.entry") : I18n.t("danfe.ide.tpNF.departure")), {size: 8, align: :center, border: 0}

      pdf.ibox 1.00, 2.08, 8.71, 4.94, "",
        I18n.t("danfe.ide.document", nNF: xml["ide/nNF"], serie: xml["ide/serie"]), {size: 8, align: :center, valign: :center, border: 0, style: :bold}

      pdf.ibox 2.20, 10.02, 10.79, 2.54
      pdf.ibarcode 1.50, 8.00, 10.9010, 4.44, xml["chNFe"]
      pdf.ibox 0.85, 10.02, 10.79, 4.74, I18n.t("danfe.chNFe"), xml["chNFe"].gsub(/(\d)(?=(\d\d\d\d)+(?!\d))/, "\\1 "), {style: :bold, align: :center}
      pdf.ibox 0.85, 10.02, 10.79, 5.60 , "", I18n.t("danfe.others.sefaz"), {align: :center, size: 8}
      pdf.lbox 0.85, 10.54, 0.25, 6.46, xml, "ide/natOp"
      pdf.ibox 0.85, 10.02, 10.79, 6.46, I18n.t("danfe.infProt"), xml["infProt/nProt"] + " " + Helper.format_date(xml["infProt/dhRecbto"]) , {align: :center}

      pdf.ibox 0.85, 6.86, 0.25, 7.31, I18n.t("danfe.emit.IE"), Ie.format(xml["emit/IE"], xml["enderEmit/UF"])
      pdf.ibox 0.85, 6.86, 7.11, 7.31, I18n.t("danfe.emit.IE_ST"), Ie.format(xml["emit/IE_ST"], xml["enderEmit/UF"])
      pdf.ibox 0.85, 6.84, 13.97, 7.31, I18n.t("danfe.emit.CNPJ"), Cnpj.format(xml["emit/CNPJ"])
    end
  end
end
