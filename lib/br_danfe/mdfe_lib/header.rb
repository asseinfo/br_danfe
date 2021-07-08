module BrDanfe
  module MdfeLib
    class Header
      def initialize(pdf, xml, logo, logo_dimensions)
        @pdf = pdf
        @xml = xml
        @logo = logo
        @logo_dimensions = logo_dimensions
      end

      def render
        render_emit
        render_title
        space_for_qr_code
      end

      private

      def render_emit
        if @logo.present?
          company(x: 90)
          logo
        else
          company(x: 0)
        end
      end

      def company(x:)
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
        Helper.format_cep(@xml['enderEmit/CEP'])
      end

      def company_informations
        '<b>CNPJ: </b>' + @xml['emit/CNPJ'] + '   ' + '<b>IE: </b>' + @xml['emit/IE']
      end

      def logo
        bounding_box_size = 80
        logo_options = BrDanfe::Logo::Options.new(bounding_box_size, @logo_dimensions).options

        @pdf.bounding_box(
          [0, 770], width: bounding_box_size, height: bounding_box_size
        ) do
          @pdf.image @logo, logo_options
        end
      end

      def render_title
        title = '<b>DAMDFE: </b> - Documento Auxiliar de Manifesto Eletrônico de Documentos Fiscais'

        @pdf.text_box(title, size: 12, align: :left, inline_format: true, at: [0, 675])
      end

      def space_for_qr_code
        @pdf.bounding_box([420, 770], width: 95, height: 95) do
          @pdf.stroke_color BLACK_COLOR
          @pdf.stroke_bounds
          @pdf.text_box('Espaço para QRCode', size: 12, align: :center, valign: :center)
        end
      end
    end
  end
end
