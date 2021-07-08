module BrDanfe
  module MdfeLib
    class MdfeIdentification
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def render
        model
        serie
        number
        number_of_pages
        emitted_at
        origin_uf
        destination_uf
      end

      private

      def model
        render_box('Modelo', @xml['ide/mod'], 0)
      end

      def render_box(title, text, x_position, width = 40)
        @pdf.text_box(title, size: 10, at: [x_position, 650])
        @pdf.bounding_box([x_position, 641], width: width, height: 20) do
          @pdf.stroke_color '000000'
          @pdf.stroke_bounds
          @pdf.text_box(text, size: 12, align: :center, valign: :center)
        end
      end

      def serie
        render_box('Série', @xml['ide/serie'], 40)
      end

      def number
        render_box('Número', @xml['ide/nMDF'], 80)
      end

      def number_of_pages
        render_box('FL', '1/1', 125)
      end

      def emitted_at
        date = Helper.format_datetime(@xml['dhEmi'])
        render_box('Data e hora de Emissão', date, 170, 120)
      end

      def origin_uf
        render_box('UF Carreg.', @xml['ide/UFIni'], 295, 60)
      end

      def destination_uf
        render_box('UF Descarreg.', @xml['ide/UFFim'], 355, 60)
      end
    end
  end
end
