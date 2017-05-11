module BrDanfe
  module DanfeLib
    class DetBody
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def render
        options = {
          column_widths: column_widths,
          header: true,
          cell_style: { padding: 2, border_width: 0.5 }
        }

         @pdf.font_size(6.5) do
          @pdf.bounding_box [0.75.cm, Helper.invert(19.59.cm)], width: 19.57.cm, height: 6.07.cm do
            @pdf.table products, options
          end
        end
      end

      private

      def products
        header = [[header_column("prod.cProd"), header_column("prod.xProd"), header_column("prod.NCM"),
          header_column("ICMS.CST"), header_column("prod.CFOP"), header_column("prod.uCom"),
          header_column("prod.qCom"), header_column("prod.vUnCom"), header_column("prod.vProd"),
          header_column("ICMS.vBC"), header_column("ICMS.vICMS"), header_column("IPI.vIPI"),
          header_column("ICMS.pICMS"), header_column("IPI.pIPI")
        ]]

        data = @xml.collect("xmlns", "det") { |det| product(det) }
        header + data
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

      def header_column(title)
        { content: I18n.t("danfe.det.#{title}"), padding: 2, align: :left, size: 6, valign: :top }
      end

      def cell_number(text)
        cell_text(text, { align: :right })
      end

      def cell_text(text, options = {})
        cell = { content: text, border_width: 0.3, border_lines: [:solid] } #, borders: [:bottom]
        cell.merge!(options)
        cell
      end

      def numerify(det, xpath)
        Helper.numerify(det.css("#{xpath}").text)
      end

      def column_widths
        {
          0 => 1.60.cm,
          1 => 6.10.cm,
          2 => 1.05.cm,
          3 => 0.60.cm,
          4 => 0.70.cm,
          5 => 1.05.cm,
          6 => 1.20.cm,
          7 => 1.20.cm,
          8 => 1.20.cm,
          9 => 1.20.cm,
          10 => 1.00.cm,
          11 => 1.00.cm,
          12 => 0.90.cm,
          13 => 0.76.cm
        }
      end
    end
  end
end
