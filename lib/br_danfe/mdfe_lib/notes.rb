module BrDanfe
  module MdfeLib
    class Notes
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def render
        title
      end

      private

      def title
        title = 'Observações'

        @pdf.move_down 20
        @pdf.bounding_box [0, @pdf.cursor], width: 278, height: 20 do
          @pdf.stroke_color GRAY_COLOR
          @pdf.stroke_horizontal_line(0, 526, at: 6)
          @pdf.text(title, size: 12, align: :left, style: :bold)
        end
      end
    end
  end
end
