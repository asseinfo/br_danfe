module BrDanfe
  module DanfeNfceLib
    class ProductList
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def render
        data = []
        data.push create_header
        data += products
        render_table data
      end

      private

      def create_header
        [
          header_column('Código', :left),
          header_column('Descrição', :left),
          header_column('Qtde', :right),
          header_column('UN', :left),
          header_column('Vl Unit', :right),
          header_column('Vl Total', :right)
        ]
      end

      def header_column(title, align)
        { content: title, align: align, size: 6, valign: :top }
      end

      def products
        @xml.collect('xmlns', 'det') { |det| product(det) }
      end

      def product(det)
        [
          cell_text(det.css('prod/cProd').text),
          cell_text(det.css('prod/xProd').text),
          cell_number(numerify(det, 'prod/qCom')),
          cell_text(det.css('prod/uCom').text),
          cell_number(numerify(det, 'prod/vUnCom')),
          cell_number(numerify(det, 'prod/vProd'))
        ]
      end

      def cell_text(text, options = {})
        cell = { content: text, border_width: 0, size: 6 }
        cell.merge!(options)
        cell
      end

      def cell_number(text)
        cell_text(text, { align: :right })
      end

      def numerify(det, xpath)
        BrDanfe::DanfeNfceLib::Helper.numerify(det.css(xpath.to_s).text)
      end

      def options
        { column_widths: column_widths, cell_style: { padding: 2, border_width: 0 } }
      end

      def column_widths
        {
          0 => 0.9.cm,
          1 => 2.7.cm,
          2 => 1.cm,
          3 => 0.4.cm,
          4 => 1.2.cm,
          5 => 1.2.cm
        }
      end

      def render_table(data)
        table = []
        table << @pdf.make_table(data, options)
        height = table.inject(0) { |sum, line| sum + line.height }

        @pdf.y -= 0.5.cm
        @pdf.bounding_box [0, @pdf.cursor], width: 8.cm, height: height do
          mapped_table = table.map { |item| [item] }

          @pdf.table(mapped_table) do |item|
            item.cells.border_width = 0
          end
        end
      end
    end
  end
end
