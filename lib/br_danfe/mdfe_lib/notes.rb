module BrDanfe
  module MdfeLib
    class Notes
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def render
        first_page = ''
        next_page = ''

        title
        aditional_information_first_page
        fill_aditional_information_taxpayer(first_page, next_page, @pdf.cursor)
        render_aditional_information_taxpayer(first_page, @pdf.cursor)

        @pdf.start_new_page if next_page.present?
        render_aditional_information_taxpayer(next_page, y_position_next_pages)
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

      def aditional_information_first_page
        fisco_information = @xml['infAdic/infAdFisco']

        fisco_information_title = 'INFORMAÇÕES ADICIONAIS DE INTERESSE DO FISCO'
        taxpayer_information_title = 'INFORMAÇÕES ADICIONAIS DE INTERESSE DO CONTRIBUINTE'

        @pdf.bounding_box([0, @pdf.cursor], width: 526) do
          if fisco_information.present?
            @pdf.text(fisco_information_title, size: 10)
            @pdf.move_down 5
            @pdf.text(fisco_information, size: 10)
            @pdf.move_down 10
          end

          if taxpayer_information_xml.present?
            @pdf.text(taxpayer_information_title, size: 10)
            @pdf.move_down 5
          end
        end
      end

      def taxpayer_information_xml
        @taxpayer_information_xml ||= @xml['infAdic/infCpl']
      end

      def fill_aditional_information_taxpayer(first_page, next_page, height_on_first_page)
        total_chars = 0
        total_height = 0

        taxpayer_information_xml.split.each do |word|
          total_chars += word.split.count + 1

          total_height += 10 if total_chars >= 120

          total_height <= height_on_first_page ? first_page << word + ' ' : next_page << word + ' '
        end
      end

      def render_aditional_information_taxpayer(data, position)
        @pdf.bounding_box([0, position], width: 526) do
          @pdf.text(data, size: 10)
        end
      end

      def y_position_next_pages
        600
      end
    end
  end
end
