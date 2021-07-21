module BrDanfe
  module MdfeLib
    class Header
      def initialize(pdf, xml, logo, logo_dimensions)
        @pdf = pdf
        @xml = xml
        @logo = logo
        @logo_dimensions = logo_dimensions
      end

      def generate
        generate_emit
        generate_title
        qr_code
      end

      private

      def generate_emit
        if @logo.present?
          company(x: 90)
          logo
        else
          company(x: 0)
        end
      end

      def company(x:)
        @pdf.bounding_box([x, @pdf.cursor], width: 280, height: 80) do
          @pdf.text(@xml['emit/xNome'], size: 12, style: :bold, align: :left)
          @pdf.text(address, align: :left, size: 9)
          @pdf.text(company_informations, size: 9, align: :left, inline_format: true)
        end
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

        @pdf.bounding_box([0, 770], width: bounding_box_size, height: bounding_box_size) do
          @pdf.image @logo, logo_options
        end
      end

      def generate_title
        title = '<b>DAMDFE</b> - Documento Auxiliar de Manifesto Eletrônico de Documentos Fiscais'

        @pdf.move_down 15
        @pdf.bounding_box([0, @pdf.cursor], width: 500, height: 20) do
          @pdf.text(title, size: 12, align: :left, inline_format: true)
        end
      end

      def qr_code
        box_size = 40.mm
        security_margin = box_size + box_size / 10.0

        @pdf.bounding_box([414, 780], width: security_margin, height: security_margin) do
          BrDanfe::QrCode.new(pdf: @pdf, xml: @xml, qr_code_tag: @xml['qrCodMDFe'], box_size: box_size).render
        end
      end
    end
  end
end
