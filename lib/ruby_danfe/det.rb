module RubyDanfe
  class Det
    def self.render_header(pdf, xml)
      pdf.ititle 0.42, 10.00, 0.25, 17.45, "det.title"

      pdf.ibox 6.70, 2.00, 0.25, 17.87, I18n.t("danfe.det.prod.cProd")
      pdf.ibox 6.70, 4.90, 2.25, 17.87, I18n.t("danfe.det.prod.xProd")
      pdf.ibox 6.70, 1.30, 7.15, 17.87, I18n.t("danfe.det.prod.NCM")
      pdf.ibox 6.70, 0.80, 8.45, 17.87, I18n.t("danfe.det.ICMS.CST")
      pdf.ibox 6.70, 1.00, 9.25, 17.87, I18n.t("danfe.det.prod.CFOP")
      pdf.ibox 6.70, 1.00, 10.25, 17.87, I18n.t("danfe.det.prod.uCom")
      pdf.ibox 6.70, 1.30, 11.25, 17.87, I18n.t("danfe.det.prod.qCom")
      pdf.ibox 6.70, 1.50, 12.55, 17.87, I18n.t("danfe.det.prod.vUnCom")
      pdf.ibox 6.70, 1.50, 14.05, 17.87, I18n.t("danfe.det.prod.vProd")
      pdf.ibox 6.70, 1.50, 15.55, 17.87, I18n.t("danfe.det.ICMS.vBC")
      pdf.ibox 6.70, 1.00, 17.05, 17.87, I18n.t("danfe.det.ICMS.vICMS")
      pdf.ibox 6.70, 1.00, 18.05, 17.87, I18n.t("danfe.det.IPI.vIPI")
      pdf.ibox 6.70, 0.90, 19.05, 17.87, I18n.t("danfe.det.ICMS.pICMS")
      pdf.ibox 6.70, 0.86, 19.95, 17.87, I18n.t("danfe.det.IPI.pIPI")

      pdf.horizontal_line 0.25.cm, 20.83.cm, at: Helper.invert(18.17.cm)
    end

    def self.render_body(pdf, xml)
      pdf.font_size(6) do
        pdf.itable 6.37, 21.50, 0.25, 18.17,
          xml.collect("xmlns", "det")  { |det|
            [
              det.css("prod/cProd").text,
              Descricao.generate(det),
              det.css("prod/NCM").text,
              Cst.to_danfe(det),
              det.css("prod/CFOP").text,
              det.css("prod/uCom").text,
              Helper.numerify(det.css("prod/qCom").text),
              Helper.numerify(det.css("prod/vUnCom").text),
              Helper.numerify(det.css("prod/vProd").text),
              Helper.numerify(det.css("ICMS/*/vBC").text),
              Helper.numerify(det.css("ICMS/*/vICMS").text),
              Helper.numerify(det.css("IPI/*/vIPI").text),
              Helper.numerify(det.css("ICMS/*/pICMS").text),
              Helper.numerify(det.css("IPI/*/pIPI").text)
            ]
          },
          column_widths: {
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
          },
          cell_style: {padding: 2, border_width: 0} do |table|
            table.column(6..13).style(align: :right)
            table.column(0..13).border_width = 1
            table.column(0..13).borders = [:bottom]
          end
      end
    end
  end
end
