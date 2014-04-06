module BrDanfe
  class DetHeader
    def initialize(pdf, xml)
      @pdf = pdf
      @xml = xml
    end

    def render
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

    private
    def column(w, x, title)
      @pdf.ibox 6.70, w, x, 17.87, I18n.t("danfe.det.#{title}")
    end
  end
end
