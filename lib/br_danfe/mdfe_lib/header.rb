module BrDanfe
  module MdfeLib
    class Header
      def initialize(pdf, xml, logo)
        @pdf = pdf
        @xml = xml
        @logo = logo
      end

      def render
        company
      end

      private

      def render_emit
        if @logo.blank?
          company
        else
          company(3.60.cm)
          logo
        end
      end

      def company(x = 0)
        @pdf.text_box(@xml['emit/xNome'], size: 12, style: :bold, align: :left, at: [x, 770])
        @pdf.text_box(address, align: :left, size: 9, at: [x, 755])
        @pdf.text_box(company_informations, size: 9, align: :left, inline_format: true, at: [x, 735])
      end

      def address
        formatted = @xml['enderEmit/xLgr'] + ', nº ' + @xml['enderEmit/nro'] + "\n"
        formatted += @xml['enderEmit/xMun'] + ' - ' + @xml['enderEmit/UF'] + '   ' + 'CEP ' + cep + "\n"
        formatted
      end

      def cep
        Cep.format(@xml['enderEmit/CEP'])
      end

      def company_informations
        '<b>CNPJ: </b>' + @xml['emit/CNPJ'] + '   ' + '<b>IE: </b>' + @xml['emit/IE']
      end

      def logo
        bounding_box_size = 80
        logo_options = BrDanfe::Logo::Options.new(bounding_box_size, @logo_dimensions).options

        @pdf.bounding_box(
          [0.83.cm, Helper.invert(@y_position.cm + 1.02.cm)], width: bounding_box_size, height: bounding_box_size
        ) do
          @pdf.image @logo, logo_options
        end
      end
    end
  end
end
