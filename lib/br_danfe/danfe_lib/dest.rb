module BrDanfe
  module DanfeLib
    class Dest
      Y = 10.00
      MAXIMUM_SIZE_FOR_STREET = 319

      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml

        @ltitle = Y - 0.42
        @l1 = Y
        @l2 = Y + LINE_HEIGHT
        @l3 = Y + (LINE_HEIGHT * 2)
      end

      def render
        @pdf.ititle 0.42, 10.00, 0.75, @ltitle, "dest.title"

        render_line1
        render_line2
        render_line3

        render_dates_block
      end

      private
      def render_line1
        @pdf.lbox LINE_HEIGHT, 11.82, 0.75, @l1, @xml, "dest/xNome"
        render_cnpj_cpf
      end

      def render_cnpj_cpf
        if @xml["dest/CNPJ"] == ""
          @pdf.i18n_lbox LINE_HEIGHT, 4.37, 12.57, @l1, "dest.CPF", cpf
        else
          @pdf.lcnpj LINE_HEIGHT, 4.37, 12.57, @l1, @xml, "dest/CNPJ"
        end
      end

      def cpf
        cpf = BrDocuments::CnpjCpf::Cpf.new(@xml["dest/CPF"])
        cpf.formatted
      end

      def render_line2
        @pdf.i18n_lbox LINE_HEIGHT, 9.66, 0.75, @l2, "enderDest.xLgr", address
        @pdf.lbox LINE_HEIGHT, 4.33, 10.41, @l2, @xml, "enderDest/xBairro"
        @pdf.i18n_lbox LINE_HEIGHT, 2.20, 14.74, @l2, "enderDest.CEP", cep
      end

      def address
        address = Helper.generate_address @xml

        if Helper.address_is_too_big(@pdf, address)
          while Helper.mensure_text(@pdf, "#{address.strip}...") > MAXIMUM_SIZE_FOR_STREET && address.length > 0 do
            address = address[0..address.length-2]
          end
          address = "#{address.strip}..."
        end
        address
      end

      def cep
        Cep.format(@xml["enderDest/CEP"])
      end

      def render_line3
        @pdf.lbox LINE_HEIGHT, 6.61, 0.75, @l3, @xml, "enderDest/xMun"
        @pdf.i18n_lbox LINE_HEIGHT, 4.06, 7.36, @l3, "enderDest.fone", phone
        @pdf.lbox LINE_HEIGHT, 1.14, 11.42, @l3, @xml, "enderDest/UF"
        @pdf.lie LINE_HEIGHT, 4.38, 12.56, @l3, @xml, "enderDest/UF", "dest/IE"
      end

      def render_dates_block

        if @xml.version_310? || @xml.version_400?
          dEmi = "ide/dhEmi"
          dSaiEnt = "ide/dhSaiEnt"
          hSaiEnt = "ide/dhSaiEnt"
        else
          dEmi = "ide/dEmi"
          dSaiEnt = "ide/dSaiEnt"
          hSaiEnt = "ide/hSaiEnt"
        end

        @pdf.ldate LINE_HEIGHT, 2.92, 17.40, @l1, "ide.dEmi", @xml[dEmi], { align: :right }
        @pdf.ldate LINE_HEIGHT, 2.92, 17.40, @l2, "ide.dSaiEnt", @xml[dSaiEnt], { align: :right }
        @pdf.ltime LINE_HEIGHT, 2.92, 17.40, @l3, "ide.hSaiEnt", @xml[hSaiEnt], { align: :right }
      end

      def phone
        Phone.format(@xml["enderDest/fone"])
      end
    end
  end
end
