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
          cell_style: { padding: 2, border_width: 0 }
        }

        @pdf.font_size(6.5) do
          @pdf.bounding_box [0.75.cm, Helper.invert(19.59.cm)], width: 19.57.cm, height: 6.07.cm do
            @pdf.table products, options do |table|
              table.column(6..13).style(align: :right)
              table.column(0..13).border_width = 0.3
              table.column(0..13).border_lines = [:dotted]
              table.column(0..13).borders = [:bottom]
            end
          end
        end
      end

      private
      def products
        @xml.collect("xmlns", "det") { |det| product(det) }
      end

      def product(det)
        [
          det.css("prod/cProd").text,
          Xprod.new(det).render,
          det.css("prod/NCM").text,
          Cst.to_danfe(det),
          det.css("prod/CFOP").text,
          det.css("prod/uCom").text,
          numerify(det, "prod/qCom"),
          numerify(det, "prod/vUnCom"),
          numerify(det, "prod/vProd"),
          numerify(det, "ICMS/*/vBC"),
          numerify(det, "ICMS/*/vICMS"),
          numerify(det, "IPI/*/vIPI"),
          numerify(det, "ICMS/*/pICMS"),
          numerify(det, "IPI/*/pIPI")
        ]
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
          4 => 0.65.cm,
          5 => 1.10.cm,
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
