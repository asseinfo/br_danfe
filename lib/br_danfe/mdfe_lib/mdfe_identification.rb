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
      end

      def model
        @pdf.text_box('Modelo', size: 10, at: [0, 665])
        @pdf.bounding_box(
          [0, 656], width: 40, height: 20,
        ) do
          @pdf.stroke_color '000000'
          @pdf.stroke_bounds
          @pdf.text_box(@xml['ide/mod'], size: 12, align: :center, valign: :center)
        end
      end

      def serie
        @pdf.text_box('Série', size: 10, at: [40, 665])
        @pdf.bounding_box(
          [40, 656], width: 40, height: 20,
        ) do
          @pdf.stroke_color '000000'
          @pdf.stroke_bounds
          @pdf.text_box(@xml['ide/serie'], size: 12, align: :center, valign: :center)
        end
      end

      def number
        @pdf.text_box('Número', size: 10, at: [80, 665])
        @pdf.bounding_box(
          [80, 656], width: 40, height: 20,
        ) do
          @pdf.stroke_color '000000'
          @pdf.stroke_bounds
          @pdf.text_box(@xml['ide/nMDF'], size: 12, align: :center, valign: :center)
        end
      end
    end
  end
end
