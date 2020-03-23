module BrDanfe
  module DanfeNfceLib
    class ProductList
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def render
        table = create_table

        # fill_table table
        render_table table

        # @pdf.iboxI LINE_HEIGHT, 5.7, 1.7, 0, '', @xml['emit/xNome'], { size: 7, align: :left, border: 0, style: :bold }
        # @pdf.cnpj LINE_HEIGHT, 5.7, 1.7, 0.25, @xml['emit/CNPJ'], { size: 7, align: :left, border: 0 }
        # @pdf.iboxI LINE_HEIGHT, 5.7, 1.7, 0.50, '', address, { size: 7, align: :left, border: 0 }
        # @pdf.iboxI LINE_HEIGHT, 5.7, 1.7, 1.25, '', 'Documento Auxiliar da Nota Fiscal de Consumidor Eletrônica', { size: 6, align: :left, border: 0 }
      end

      private

      def create_table
        [create_header]
      end

      def create_header
        header = [[
          header_column('Código', :left),
          header_column('Descrição', :left),
          header_column('Qtde', :right),
          header_column('UN', :left),
          header_column('Vl Unit', :right),
          header_column('Vl Total', :right)
        ]]
        @pdf.make_table(header, options)
      end

      def header_column(title, align)
        { content: title, align: align, size: 6, valign: :top }
      end

      def options
        { column_widths: column_widths, cell_style: { padding: 2, border_width: 0, border_lines: [:dotted, :dotted, :dotted, :dotted,] } }
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

      def fill_table(table)
        products.each do |product|
          table << create_row(product)
        end
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
        cell = { content: text, border_widths: [0, 0, 0, 0], size: 6.5 }
        cell.merge!(options)
        cell
      end

      def cell_number(text)
        cell_text(text, { align: :right })
      end

      def numerify(det, xpath)
        Helper.numerify(det.css(xpath.to_s).text)
      end

      tentar fazer o header assim
      def create_row(data)
        @pdf.make_table([data], options)
      end

      def render_table(table)
        @pdf.bounding_box [0, BrDanfe::DanfeNfceLib::Helper.invert(@pdf.page_height, 2.cm)], width: 8.cm, height: 0.cm do
          @pdf.table table.map { |item| [item] }, { header: true }
        end

      # @pdf.table(data) do |t|
      #   t.cells.border_width = 0
      # end
      # cells.borders
      # borders => :bottom


        # @pdf.bounding_box([0, BrDanfe::DanfeNfceLib::Helper.invert(@pdf.page_height, 0.1.cm)], width: box_size, height: box_size) do
        #   @pdf.image @logo, logo_options
        # end
      end
    end
  end
end
