module BrDanfe
  module MdfeLib
    class Header
      attr_reader :options

      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
        @options = BrDanfe::Logo::Config.new
      end

      def render
        render_emit
        render_title
      end

      private

      def render_emit
        if @options.logo.blank?
          company
        else
          company(90)
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
        logo_options = BrDanfe::Logo::Options.new(bounding_box_size, @options.logo_dimensions).options

        @pdf.bounding_box(
          [1, 770], width: bounding_box_size, height: bounding_box_size
        ) do
          @pdf.image @options.logo, logo_options
        end
      end

      def render_title
        title = '<b>DAMDFE: </b> - Documento Auxiliar de Manifesto Eletrônico de Documentos Fiscais'

        @pdf.text_box(title, size: 12, align: :left, inline_format: true, at: [0, 675])
      end
    end
  end
end
