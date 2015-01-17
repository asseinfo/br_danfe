module BrDanfe
  class Dest
    Y = 8.58

    def initialize(pdf, xml)
      @pdf = pdf
      @xml = xml

      @ltitle = Y - 0.42
      @l1 = Y
      @l2 = Y + LINE_HEIGHT
      @l3 = Y + (LINE_HEIGHT * 2)
    end

    def render
      @pdf.ititle 0.42, 10.00, 0.25, @ltitle, "dest.title"

      render_line1
      render_line2
      render_line3

      render_dates_block
    end

    private
    def render_line1
      @pdf.lbox LINE_HEIGHT, 12.32, 0.25, @l1, @xml, "dest/xNome"
      render_cnpj_cpf
    end

    def render_cnpj_cpf
      if @xml["dest/CNPJ"] == ""
        @pdf.ibox LINE_HEIGHT, 4.87, 12.57, @l1, I18n.t("danfe.dest.CPF"), cpf
      else
        @pdf.ibox LINE_HEIGHT, 4.87, 12.57, @l1, I18n.t("danfe.dest.CNPJ"), cnpj
      end
    end

    def cnpj
      cnpj = BrDocuments::CnpjCpf::Cnpj.new(@xml["dest/CNPJ"])
      cnpj.formatted
    end

    def cpf
      cpf = BrDocuments::CnpjCpf::Cpf.new(@xml["dest/CPF"])
      cpf.formatted
    end

    def render_line2
      @pdf.ibox LINE_HEIGHT, 10.16, 0.25, @l2, I18n.t("danfe.enderDest.xLgr"), street
      @pdf.lbox LINE_HEIGHT, 4.83, 10.41, @l2, @xml, "enderDest/xBairro"
      @pdf.ibox LINE_HEIGHT, 2.20, 15.24, @l2, I18n.t("danfe.enderDest.CEP"), cep
    end

    def street
      @xml["enderDest/xLgr"] + " " + @xml["enderDest/nro"]
    end

    def cep
      Cep.format(@xml["enderDest/CEP"])
    end

    def render_line3
      @pdf.lbox LINE_HEIGHT, 7.11, 0.25, @l3, @xml, "enderDest/xMun"
      @pdf.ibox LINE_HEIGHT, 4.06, 7.36, @l3, I18n.t("danfe.enderDest.fone"), phone
      @pdf.lbox LINE_HEIGHT, 1.14, 11.42, @l3, @xml, "enderDest/UF"
      @pdf.ibox LINE_HEIGHT, 4.88, 12.56, @l3, I18n.t("danfe.dest.IE"), ie
    end

    def render_dates_block
      @pdf.ldate LINE_HEIGHT, 2.92, 17.90, @l1, "ide.dEmi", @xml["ide/dEmi"], { align: :right }

      if @xml.version_310?
        dSaiEnt = @xml["ide/dhSaiEnt"]
        hSaiEnt = @xml["ide/dhSaiEnt"]
      else
        dSaiEnt = @xml["ide/dSaiEnt"]
        hSaiEnt = @xml["ide/hSaiEnt"]
      end

      @pdf.ldate LINE_HEIGHT, 2.92, 17.90, @l2, "ide.dSaiEnt", dSaiEnt, { align: :right }
      @pdf.ltime LINE_HEIGHT, 2.92, 17.90, @l3, "ide.hSaiEnt", hSaiEnt, { align: :right }
    end

    def phone
      Phone.format(@xml["enderDest/fone"])
    end

    def ie
      ie = BrDocuments::IE::Factory.create(@xml["enderDest/UF"], @xml["dest/IE"])
      ie.formatted
    end
  end
end
