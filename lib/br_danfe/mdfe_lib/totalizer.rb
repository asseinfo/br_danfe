module BrDanfe
  module MdfeLib
    class Totalizer
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def render
        render_title
        nfe_quantity
        cte_quantity
        total_weight
      end

      private

      def render_title
        title = 'Modelo Rodoviário de Carga'

        @pdf.text_box(title, size: 12, align: :left, style: :bold, at: [0, 600])
      end

      def nfe_quantity
        render_box('QTD. NFe', @xml['qNFe'], 65)
      end

      def render_box(title, text, x_position, width = 60)
        @pdf.move_cursor_to 580

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

      def cte_quantity
        render_box('QTD. CTe', '', 0)
      end

      def total_weight
        weight = ActiveSupport::NumberHelper.number_to_rounded(@xml['qCarga'], precision: 2)
        weight = Helper.numerify(weight)

        render_box('Peso total (Kg)', weight, 130, 90)
      end
    end
  end
end
