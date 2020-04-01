module BrDanfe
  module DanfeNfceLib
    class ProductList
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def render
        render_headers(headers)
        render_products
      end

      private

      def headers
        [
          header_column('Código', :left),
          header_column('Descrição', :left),
          header_column('Qtde', :right),
          header_column('UN', :right),
          header_column('Vl Unit', :right),
          header_column('Vl Total', :right)
        ]
      end

      def header_column(title, align)
        { content: title, options: { align: align, size: 6, style: :bold } }
      end

      def products
        @xml.collect('xmlns', 'det') { |det| product(det) }
      end

      def product(det)
        [
          cell_text(det.css('prod/cProd').text),
          cell_text(det.css('prod/xProd').text),
          cell_number(BrDanfe::Helper.numerify(det.css('prod/qCom').text)),
          cell_text(det.css('prod/uCom').text, align: :right),
          cell_number(BrDanfe::Helper.numerify(det.css('prod/vUnCom').text)),
          cell_number(BrDanfe::Helper.numerify(det.css('prod/vProd').text))
        ]
      end

      def cell_text(text, options = {})
        cell = { content: text, options: { border_width: 0, size: 6 } }
        cell[:options].merge!(options)
        cell
      end

      def cell_number(text)
        cell_text(text, align: :right)
      end

      def columns
        [
          { width: 0.9.cm, position: 0 },
          { width: 2.6.cm, position: 0.9.cm },
          { width: 1.1.cm, position: 3.5.cm },
          { width: 0.4.cm, position: 4.6.cm },
          { width: 1.2.cm, position: 5.cm },
          { width: 1.2.cm, position: 6.2.cm }
        ]
      end

      def render_headers(headers)
        2.times { @pdf.render_blank_line }
        cursor = @pdf.cursor
        headers.each_with_index do |header, index|
          @pdf.bounding_box [columns[index][:position], cursor], width: columns[index][:width], height: 0.2.cm do
            @pdf.text header[:content], header[:options]
          end
        end
      end

      def render_products
        @pdf.render_blank_line
        index_of_product_name = 1
        products.each do |product|
          box_height = box_height(product[index_of_product_name][:content])
          cursor = @pdf.cursor

          product.each_with_index do |cell, index|
            @pdf.bounding_box [columns[index][:position], cursor], width: columns[index][:width], height: box_height do
              @pdf.text cell[:content], cell[:options]
            end
          end
        end
      end

      def box_height(content)
        line_height_base = 0.23.cm

        lines = content.scan(/[\s\S]{1,20}( |$)/).length
        line_height_base * lines
      end
    end
  end
end
