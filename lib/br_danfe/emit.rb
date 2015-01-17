module BrDanfe
  class Emit
    Y = 6.46
    L1 = Y
    L2 = Y + LINE_HEIGHT

    def initialize(pdf, xml)
      @pdf = pdf
      @xml = xml
    end

    def render
      @pdf.lbox LINE_HEIGHT, 10.54, 0.25, L1, @xml, "ide/natOp"
      @pdf.ibox LINE_HEIGHT, 10.02, 10.79, L1, I18n.t("danfe.infProt"), @xml["infProt/nProt"] + " " + Helper.format_datetime(@xml["infProt/dhRecbto"]), { align: :center }
      ie(0.25, "IE")
      ie(7.11, "IE_ST")
      cnpj_box
    end

    private
    def ie(x, field)
      ie = BrDocuments::IE::Factory.create(@xml["enderEmit/UF"], @xml["emit/#{field}"])
      @pdf.ibox LINE_HEIGHT, 6.86, x, L2, I18n.t("danfe.emit.#{field}"), ie.formatted
    end

    def cnpj_box
      cnpj = BrDocuments::CnpjCpf::Cnpj.new(@xml["emit/CNPJ"])
      @pdf.ibox LINE_HEIGHT, 6.84, 13.97, L2, I18n.t("danfe.emit.CNPJ"), cnpj.formatted
    end
  end
end
