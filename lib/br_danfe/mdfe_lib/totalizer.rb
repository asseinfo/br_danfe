module BrDanfe
  module MdfeLib
    class Totalizer
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def render
        render_title
        cte_quantity
        nfe_quantity
        total_weight
      end

      private

      def render_title
        title = 'Modelo Rodoviário de Carga'

        @pdf.text_box(title, size: 12, align: :left, style: :bold, at: [0, 620])
      end

      def cte_quantity
        render_box('QTD. CTe', @xml['qCTe'], 0)
      end

      def nfe_quantity
        render_box('QTD. NFe', @xml['qNFe'], 55)
      end

      def total_weight
        weight = ActiveSupport::NumberHelper.number_to_rounded(@xml['qCarga'], precision: 2)
        weight = Helper.numerify(weight)

        render_box('Peso Total (Kg)', weight, 110, 80)
      end

      def render_box(title, text, x_position, width = 50)
        @pdf.text_box(title, size: 10, at: [x_position, 605])
        @pdf.bounding_box([x_position, 596], width: width, height: 20) do
          @pdf.stroke_color '000000'
          @pdf.stroke_bounds
          @pdf.text_box(text, size: 12, align: :center, valign: :center)
        end
      end
    end
  end
end
