module BrDanfe
  module MdfeLib
    class Drivers
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def render
        @pdf.move_cursor_to 460
        title
        table_titles
        render_drivers
      end

      private

      def title
        title = 'Condutor'

        @pdf.text_box(title, size: 12, align: :left, style: :bold, at: [250, @pdf.cursor])
      end

      def table_titles
        cpf = 'CPF'
        name = 'Nome'

        @pdf.stroke_color GRAY_COLOR
        @pdf.move_down 20
        @pdf.text_box(cpf, size: 9, align: :left, at: [250, @pdf.cursor])
        @pdf.text_box(name, size: 9, align: :left, at: [350, @pdf.cursor])
        @pdf.move_down 10
        @pdf.stroke_horizontal_line(250, 528, at: @pdf.cursor)
      end

      def render_drivers
        @pdf.move_cursor_to 425

        drivers.each_with_index do |driver, index|
          @pdf.bounding_box [250, @pdf.cursor], width: 278, height: 20 do
            @pdf.stroke_color GRAY_COLOR
            @pdf.dash([2], phase: 6)
            @pdf.stroke_horizontal_line(0, 278, at: 26) unless index.zero?
            @pdf.undash
            @pdf.move_down 20

            driver.each_with_index do |cell, index_driver|
              @pdf.text_box(cell, at: [x_position(index_driver), 20], size: 12)
            end
          end
        end
      end

      def drivers
        @xml.collect('xmlns', 'condutor') { |rodo| driver(rodo) }
      end

      def driver(rodo)
        [
          rodo.css('CPF').text,
          rodo.css('xNome').text
        ]
      end

      def x_position(index)
        index.even? ? 0 : 100
      end
    end
  end
end
