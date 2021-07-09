module BrDanfe
  module MdfeLib
    class Driver
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def render
        title
        table_titles
        render_drivers
      end

      private

      def title
        title = 'Condutor'

        @pdf.text_box(title, size: 12, align: :left, style: :bold, at: [250, 460])
      end

      def table_titles
      cpf = 'CPF'
      name = 'Nome'

        @pdf.stroke_color GRAY_COLOR
        @pdf.stroke_horizontal_line(250, 440, at: 430)
        @pdf.text_box(cpf, size: 9, align: :left, at: [250, 440])
        @pdf.text_box(name, size: 9, align: :left, at: [350, 440])
      end

      def render_drivers
        @pdf.move_down 20
        drivers.each_with_index do |driver, index|
          @pdf.bounding_box [250, 425 - index * 20], width: 190, height: 20 do
            driver.each_with_index do |cell, index_driver|
              @pdf.stroke_color GRAY_COLOR
              @pdf.dash([2], :phase => 6)
              @pdf.stroke_horizontal_line(0, 190, at: 26) unless index.zero?
              @pdf.text_box(cell, at: [x_position(index_driver), 425 - index * 20], size: 12)
              @pdf.undash
            end
          end
        end
      end

      def x_position(index)
        index.even? ? 0 : 100
      end

      def drivers
        @xml.collect('xmlns', 'condutor') {|rodo| driver(rodo) }
      end

      def driver(rodo)
        [
          rodo.css('CPF').text,
          rodo.css('xNome').text
        ]
      end
    end
  end
end
