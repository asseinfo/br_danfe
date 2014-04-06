module BrDanfe
  class Emit
    def initialize(pdf, xml, logo_path)
      @pdf = pdf
      @xml = xml
      @logo_path = logo_path
    end

    def render
      address_box
      danfe_box
      access_key_box
      sefaz_box
      operationkind_box
      protocol_box
      ie_box
      ie_st_box
      cnpj_box
    end

    private
    def address_box
      @pdf.ibox 3.92, 8.46, 0.25, 2.54

      @pdf.ibox 3.92, 8.46, 0.25, 2.80, "", @xml["emit/xNome"],
        { size: 12, align: :center, border: 0, style: :bold }

      if @logo_path.empty?
        @pdf.ibox 3.92, 8.46, 0.75, 4, "", address, { align: :left, border: 0 }
      else
        @pdf.ibox 3.92, 8.46, 2.75, 4, "", address,
          { size: 8, align: :left, border: 0 }

        @pdf.image @logo_path, at: [0.5.cm, Helper.invert(4.cm)],
          width: 2.cm
      end
    end

    def address
      formatted = @xml["enderEmit/xLgr"] + ", " + @xml["enderEmit/nro"] + "\n"
      formatted += @xml["enderEmit/xBairro"] + " - " + cep + "\n"
      formatted += @xml["enderEmit/xMun"] + "/" + @xml["enderEmit/UF"] + "\n"
      formatted += phone + " " + @xml["enderEmit/email"]

      formatted
    end

    def phone
      Phone.format(@xml["enderEmit/fone"])
    end

    def cep
      Cep.format(@xml["enderEmit/CEP"])
    end

    def danfe_box
      @pdf.ibox 3.92, 2.08, 8.71, 2.54

      @pdf.ibox 0.60, 2.08, 8.71, 2.54, "", "DANFE",
        { size: 12, align: :center, border: 0, style: :bold }

      @pdf.ibox 1.20, 2.08, 8.71, 3.14, "", I18n.t("danfe.others.danfe"),
        { size: 8, align: :center, border: 0 }

      @pdf.ibox 0.60, 2.08, 8.71, 4.34, "", "#{@xml['ide/tpNF']} - " + (@xml["ide/tpNF"] == "0" ? I18n.t("danfe.ide.tpNF.entry") : I18n.t("danfe.ide.tpNF.departure")),
        { size: 8, align: :center, border: 0 }

      @pdf.ibox 1.00, 2.08, 8.71, 4.94, "",
        I18n.t("danfe.ide.document", nNF: @xml["ide/nNF"], serie: @xml["ide/serie"]),
        { size: 8, align: :center, valign: :center, border: 0, style: :bold }
    end

    def access_key_box
      @pdf.ibox 2.20, 10.02, 10.79, 2.54
      @pdf.ibarcode 1.50, 8.00, 10.9010, 4.44, @xml["chNFe"]
      @pdf.ibox 0.85, 10.02, 10.79, 4.74, I18n.t("danfe.chNFe"), @xml["chNFe"].gsub(/(\d)(?=(\d\d\d\d)+(?!\d))/, "\\1 "),
        { style: :bold, align: :center }
    end

    def sefaz_box
      @pdf.ibox 0.85, 10.02, 10.79, 5.60 , "", I18n.t("danfe.others.sefaz"),
        { align: :center, size: 8 }
    end

    def operationkind_box
      @pdf.lbox 0.85, 10.54, 0.25, 6.46, @xml, "ide/natOp"
    end

    def protocol_box
      @pdf.ibox 0.85, 10.02, 10.79, 6.46, I18n.t("danfe.infProt"), @xml["infProt/nProt"] + " " + Helper.format_date(@xml["infProt/dhRecbto"]), { align: :center }
    end

    def ie_box
      ie(0.25, "IE")
    end

    def ie_st_box
      ie(7.11, "IE_ST")
    end

    def ie(x, field)
      @pdf.ibox 0.85, 6.86, x, 7.31, I18n.t("danfe.emit.#{field}"), Ie.format(@xml["emit/#{field}"], @xml["enderEmit/UF"])
    end

    def cnpj_box
      @pdf.ibox 0.85, 6.84, 13.97, 7.31, I18n.t("danfe.emit.CNPJ"), Cnpj.format(@xml["emit/CNPJ"])
    end
  end
end
