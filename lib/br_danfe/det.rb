module BrDanfe
  class Det
    def initialize(pdf, xml)
      @pdf = pdf
      @xml = xml
    end

    def render_header
      @pdf.ititle 0.42, 10.00, 0.25, 17.45, "det.title"

      column(2.00, 0.25, "prod.cProd")
      column(4.90, 2.25, "prod.xProd")
      column(1.30, 7.15, "prod.NCM")
      column(0.80, 8.45, "ICMS.CST")
      column(1.00, 9.25, "prod.CFOP")
      column(1.00, 10.25, "prod.uCom")
      column(1.30, 11.25, "prod.qCom")
      column(1.50, 12.55, "prod.vUnCom")
      column(1.50, 14.05, "prod.vProd")
      column(1.50, 15.55, "ICMS.vBC")
      column(1.00, 17.05, "ICMS.vICMS")
      column(1.00, 18.05, "IPI.vIPI")
      column(0.90, 19.05, "ICMS.pICMS")
      column(0.86, 19.95, "IPI.pIPI")

      @pdf.horizontal_line 0.25.cm, 20.83.cm, at: Helper.invert(18.17.cm)
    end

    def render_body
      @pdf.font_size(6) do
        @pdf.itable 6.37, 21.50, 0.25, 18.17,
          products,
          column_widths: column_widths,
          cell_style: {padding: 2, border_width: 0} do |table|
            table.column(6..13).style(align: :right)
            table.column(0..13).border_width = 1
            table.column(0..13).borders = [:bottom]
          end
      end
    end

    private
    def column(w, x, title)
      @pdf.ibox 6.70, w, x, 17.87, I18n.t("danfe.det.#{title}")
    end

    def products
      @xml.collect("xmlns", "det") { |det| product(det) }
    end

    def product(det)
      [
        det.css("prod/cProd").text,
        Xprod.generate(det),
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
        0 => 2.00.cm,
        1 => 4.90.cm,
        2 => 1.30.cm,
        3 => 0.80.cm,
        4 => 1.00.cm,
        5 => 1.00.cm,
        6 => 1.30.cm,
        7 => 1.50.cm,
        8 => 1.50.cm,
        9 => 1.50.cm,
        10 => 1.00.cm,
        11 => 1.00.cm,
        12 => 0.90.cm,
        13 => 0.86.cm
      }
    end
  end
end
