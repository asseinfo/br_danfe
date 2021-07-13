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

        fisco_information_title = 'INFORMAÇÕES ADICIONAIS DE INTERESSE DO FISCO'
        taxpayer_information_title = 'INFORMAÇÕES ADICIONAIS DE INTERESSE DO CONTRIBUINTE'

        # @pdf.move_cursor_to 600
        @pdf.lazy_bounding_box 526, position: :left do
          if fisco_information.present?
            @pdf.text(fisco_information_title, size: 10, align: :left)
            @pdf.move_down 5
            @pdf.text(fisco_information, size: 10, align: :left)
            @pdf.move_down 10
          end

          if taxpayer_information.present?
            @pdf.text(taxpayer_information_title, size: 10, align: :left)
            @pdf.move_down 5
            @pdf.text(taxpayer_information, size: 10, align: :left)
          end

          @pdf.move_cursor_to 600 if @pdf.page_number != 1
        end
      end
    end
  end
end
