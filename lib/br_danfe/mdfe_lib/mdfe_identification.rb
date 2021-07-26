module BrDanfe
  module MdfeLib
    class MdfeIdentification
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def generate(page)
        model
        series
        number
        number_of_pages(page)
        emitted_at
        origin_uf
        destination_uf
      end

      private

      def model
        generate_box('Modelo', @xml['ide/mod'], 0)
      end

      def generate_box(title, text, x_position, width = 40)
        @pdf.move_cursor_to 655

        @pdf.stroke do
          @pdf.fill_color LIGHT_GRAY_COLOR
          @pdf.fill_rectangle([x_position, @pdf.cursor], width, 35)
          @pdf.fill_color BLACK_COLOR
        end

        @pdf.bounding_box([x_position, @pdf.cursor], width: width, height: 35) do
          @pdf.move_down 5
          @pdf.text_box(title, size: 10, at: [3, @pdf.cursor])
          @pdf.move_down 15
          @pdf.text_box(text, size: 12, at: [3, @pdf.cursor])
        end
      end

      def series
        generate_box('Série', @xml['ide/serie'], 40)
      end

      def number
        generate_box('Número', @xml['ide/nMDF'], 80)
      end

      def number_of_pages(page)
        text = page.to_s + '/' + @pdf.page_count.to_s
        generate_box('FL', text, 125)
      end

      def emitted_at
        date = Helper.format_datetime(@xml['dhEmi'])
        generate_box('Data e hora de Emissão', date, 170, 110)
      end

      def origin_uf
        generate_box('UF Carreg.', @xml['ide/UFIni'], 285, 70)
      end

      def destination_uf
        generate_box('UF Descarreg.', @xml['ide/UFFim'], 345, 70)
      end
    end
  end
end
