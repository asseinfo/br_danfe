module BrDanfe
  module DanfeLib
    class EmitHeader
      def initialize(pdf, xml, logo, logo_dimensions)
        @pdf = pdf
        @xml = xml
        @logo = logo
        @logo_dimensions = logo_dimensions
      end

      def render
        company_box
        danfe_box
        access_key_box
        sefaz_box
      end

      private

      def company_box
        @pdf.ibox 3.92, 7.46, 0.75, 3.96

        @pdf.ibox 3.92, 7.46, 0.75, 3.96, "", @xml["emit/xNome"],
          { size: 12, align: :center, border: 0, style: :bold }

        address_company
      end

      def address_company
        if @logo.blank?
          @pdf.ibox 3.92, 7.46, 1.25, 5.42, "", address, { align: :left, border: 0 }
        else
          @pdf.ibox 3.92, 7.46, 3.60, 5.42, "", address, { size: 8, align: :left, border: 0 }
          logo
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

      def logo
        bounding_box_size = 80
        logo_options = BrDanfe::DanfeLib::LogoOptions.new(bounding_box_size, @logo_dimensions).options

        @pdf.move_down 105
        @pdf.bounding_box([0.83.cm, @pdf.cursor], width: bounding_box_size, height: bounding_box_size) do
          @pdf.image @logo, logo_options
        end
      end

      def danfe_box
        @pdf.ibox 3.92, 2.08, 8.21, 3.96

        @pdf.ibox 0.60, 2.08, 8.21, 3.96, "", "DANFE",
          { size: 12, align: :center, border: 0, style: :bold }

        @pdf.ibox 1.20, 2.08, 8.21, 4.56, "", I18n.t("danfe.others.danfe"),
          { size: 8, align: :center, border: 0 }

        @pdf.ibox 0.60, 2.08, 8.21, 5.76, "", "#{@xml['ide/tpNF']} - " + (@xml["ide/tpNF"] == "0" ? I18n.t("danfe.ide.tpNF.entry") : I18n.t("danfe.ide.tpNF.departure")),
          { size: 8, align: :center, border: 0 }

        @pdf.ibox 1.00, 2.08, 8.21, 6.36, "",
          I18n.t("danfe.ide.document", nNF: @xml["ide/nNF"], serie: @xml["ide/serie"]),
          { size: 8, align: :center, valign: :center, border: 0, style: :bold }
      end

      def access_key_box
        @pdf.ibox 2.22, 10.02, 10.29, 3.96
        @pdf.ibarcode 1.50, 8.00, 10.4010, 5.86, @xml["chNFe"]
        @pdf.ibox 0.85, 10.02, 10.29, 6.18, I18n.t("danfe.chNFe"), @xml["chNFe"].gsub(/(\d)(?=(\d\d\d\d)+(?!\d))/, "\\1 "),
          { style: :bold, align: :center }
      end

      def sefaz_box
        @pdf.ibox 0.85, 10.02, 10.29, 7.03, "", I18n.t("danfe.others.sefaz"),
          { align: :center, size: 8 }
      end
    end
  end
end
