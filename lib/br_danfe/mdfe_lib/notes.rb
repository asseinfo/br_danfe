module BrDanfe
  module MdfeLib
    class Notes
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def render
        title
        aditional_information
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

      def aditional_information
        fisco_information = @xml['infAdic/infAdFisco']
        taxpayer_information = @xml['infAdic/infCpl']

        fisco_information_title = 'Informações adicionais de interesse do Fisco' if fisco_information.present?
        taxpayer_information_title = 'Informações adicionais de interesse do Contribuinte' if taxpayer_information.present?

        @pdf.move_down 10

        @pdf.bounding_box [10, @pdf.cursor], width: 526, height: 300 do
          @pdf.stroke_color GRAY_COLOR
          @pdf.dash([2], phase: 6)
          @pdf.text(taxpayer_information_title, size: 11, align: :left, style: :bold)
          @pdf.stroke_horizontal_line(0, 516, at: @pdf.cursor)
          @pdf.move_down 10
          @pdf.text(taxpayer_information, size: 10, align: :left)
          @pdf.move_down 15
          @pdf.text(taxpayer_information_title, size: 11, align: :left, style: :bold)
          @pdf.stroke_horizontal_line(0, 245, at: @pdf.cursor)
          @pdf.move_down 10
          @pdf.text(taxpayer_information, size: 10, align: :left)
          @pdf.move_down 15
          @pdf.text(' • ' + taxpayer_information_title, size: 11, align: :left, style: :bold)
          @pdf.move_down 10
          @pdf.text(taxpayer_information, size: 10, align: :left)
          @pdf.undash
        end
      end
    end
  end
end
