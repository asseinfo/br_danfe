module BrDanfe
  class Dest
    def initialize(pdf, xml)
      @pdf = pdf
      @xml = xml
    end

    def render
      @pdf.ititle 0.42, 10.00, 0.25, 8.16, "dest.title"

      render_line1
      render_line2
      render_line3
    end

    private
    def render_line1
      @pdf.lbox 0.85, 12.32, 0.25, 8.58, @xml, "dest/xNome"
      render_cnpj_cpf
      @pdf.idate 0.85, 2.92, 17.90, 8.58, "ide.dEmi", @xml["ide/dEmi"], { align: :right }
    end

    def render_cnpj_cpf
      if @xml["dest/CNPJ"] == ""
        @pdf.ibox 0.85, 5.33, 12.57, 8.58, I18n.t("danfe.dest.CPF"), cpf
      else
        @pdf.ibox 0.85, 5.33, 12.57, 8.58, I18n.t("danfe.dest.CNPJ"), cnpj
      end
    end

    def cnpj
      Cnpj.format(@xml["dest/CNPJ"])
    end

    def cpf
      Cpf.format(@xml["dest/CPF"])
    end

    def render_line2
      @pdf.ibox 0.85, 10.16, 0.25, 9.43, I18n.t("danfe.enderDest.xLgr"), street
      @pdf.lbox 0.85, 4.83, 10.41, 9.43, @xml, "enderDest/xBairro"
      @pdf.ibox 0.85, 2.67, 15.24, 9.43, I18n.t("danfe.enderDest.CEP"), cep
      @pdf.idate 0.85, 2.92, 17.90, 9.43, "ide.dSaiEnt", @xml["ide/dSaiEnt"], { align: :right }
    end

    def street
      @xml["enderDest/xLgr"] + " " + @xml["enderDest/nro"]
    end

    def cep
      Cep.format(@xml["enderDest/CEP"])
    end

    def render_line3
      @pdf.lbox 0.85, 7.11, 0.25, 10.28, @xml, "enderDest/xMun"
      @pdf.ibox 0.85, 4.06, 7.36, 10.28, I18n.t("danfe.enderDest.fone"), phone
      @pdf.lbox 0.85, 1.14, 11.42, 10.28, @xml, "enderDest/UF"
      @pdf.ibox 0.85, 5.33, 12.56, 10.28, I18n.t("danfe.dest.IE"), ie
      @pdf.idate 0.85, 2.92, 17.90, 10.28, "ide.hSaiEnt", @xml["ide/dSaiEnt"], { align: :right }
    end

    def phone
      Phone.format(@xml["enderDest/fone"])
    end

    def ie
      Ie.format(@xml["dest/IE"], @xml["enderDest/UF"])
    end
  end
end
