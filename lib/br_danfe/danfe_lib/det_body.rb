module BrDanfe
  module DanfeLib
    class DetBody
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def render(has_issqn)
        table_height_on_first_page = table_height_on_first_page has_issqn
        first_table = create_table
        next_table = create_table

        fill_tables first_table, next_table, table_height_on_first_page
        render_tables first_table, next_table, table_height_on_first_page
      end

      private

      def table_height_on_first_page(has_issqn)
        has_issqn ? 6.35.cm : 7.72.cm
      end

      def create_table
        [create_header]
      end

      def create_header
        header = [[
          header_column("prod.cProd"), header_column("prod.xProd"), header_column("prod.NCM"),
          header_column("ICMS.CST"), header_column("prod.CFOP"), header_column("prod.uCom"),
          header_column("prod.qCom"), header_column("prod.vUnCom"), header_column("prod.vProd"),
          header_column("ICMS.vBC"), header_column("ICMS.vICMS"), header_column("IPI.vIPI"),
          header_column("ICMS.pICMS"), header_column("IPI.pIPI")
        ]]
        @pdf.make_table(header, options)
      end

      def header_column(title)
        { content: I18n.t("danfe.det.#{title}"), align: :left, size: 6, valign: :top }
      end

      def options
        { column_widths: column_widths, cell_style: { padding: 2, border_width: 0.3 } }
      end

      def column_widths
        {
          0 => 1.60.cm, 1 => 6.10.cm, 2 => 1.05.cm, 3 => 0.60.cm, 4 => 0.70.cm, 5 => 1.05.cm, 6 => 1.20.cm,
          7 => 1.20.cm, 8 => 1.20.cm, 9 => 1.20.cm, 10 => 1.00.cm, 11 => 1.00.cm, 12 => 0.90.cm, 13 => 0.76.cm
        }
      end

      def fill_tables(first_table, next_table, first_table_height)
        total_height = first_table.first.height

        products.each do |product|
          row = create_row product
          total_height += row.height
          total_height <= first_table_height ? first_table << row : next_table << row
        end
      end

      def products
        @xml.collect("xmlns", "det") { |det| product(det) }
      end

      def product(det)
        [
          cell_text(det.css("prod/cProd").text),
          cell_text(Xprod.new(det).render),
          cell_text(det.css("prod/NCM").text),
          cell_text(Cst.to_danfe(det)),
          cell_text(det.css("prod/CFOP").text),
          cell_text(det.css("prod/uCom").text),
          cell_number(numerify(det, "prod/qCom")),
          cell_number(numerify(det, "prod/vUnCom")),
          cell_number(numerify(det, "prod/vProd")),
          cell_number(numerify(det, "ICMS/*/vBC")),
          cell_number(numerify(det, "ICMS/*/vICMS")),
          cell_number(numerify(det, "IPI/*/vIPI")),
          cell_number(numerify(det, "ICMS/*/pICMS")),
          cell_number(numerify(det, "IPI/*/pIPI"))
        ]
      end

      def cell_text(text, options = {})
        cell = { content: text, border_lines: [:solid], size: 6.5 }
        cell.merge!(options)
        cell
      end

      def cell_number(text)
        cell_text(text, { align: :right })
      end

      def numerify(det, xpath)
        Helper.numerify(det.css("#{xpath}").text)
      end

      def create_row(data)
        @pdf.make_table([data], options)
      end

      def render_tables(first_table, next_table, first_table_height)
        render_table first_table, table_position_on_first_page, first_table_height

        table_with_only_header = 1
        if next_table.size > table_with_only_header
          @pdf.start_new_page
          render_table next_table, table_position_on_next_pages, table_height_on_next_pages
        end
      end

      def render_table(data, start_position, height)
        @pdf.y = start_position
        @pdf.bounding_box [0.75.cm, @pdf.cursor], width: 19.56.cm, height: height do
          options = { header: true, cell_style: { border_width: 0 } }
          @pdf.table data.map{ |item| [item] }, options
        end
      end

      def table_position_on_first_page
        Helper.invert(18.07.cm)
      end

      def table_position_on_next_pages
        Helper.invert(6.57.cm)
      end

      def table_height_on_next_pages
        22.58.cm
      end
    end
  end
end
