module BrDanfe
  module DanfeLib
    Y = 18.81 + SPACE_BETWEEN_GROUPS

    class DetHeader
      def initialize(pdf)
        @pdf = pdf

        @ltitle = Y - 0.42
        @l1 = Y
      end

      def render
        @pdf.ititle 0.42, 10.00, 0.75, @ltitle, "det.title"

        column(1.50, 0.75, "prod.cProd")
        column(4.40, 2.25, "prod.xProd")
        column(1.30, 6.65, "prod.NCM")
        column(0.80, 7.95, "ICMS.CST")
        column(1.00, 8.75, "prod.CFOP")
        column(1.00, 9.75, "prod.uCom")
        column(1.30, 10.75, "prod.qCom")
        column(1.50, 12.05, "prod.vUnCom")
        column(1.50, 13.55, "prod.vProd")
        column(1.50, 15.05, "ICMS.vBC")
        column(1.00, 16.55, "ICMS.vICMS")
        column(1.00, 17.55, "IPI.vIPI")
        column(0.90, 18.55, "ICMS.pICMS")
        column(0.86, 19.45, "IPI.pIPI")

        @pdf.horizontal_line 0.75.cm, 20.31.cm, at: Helper.invert(19.59.cm)
      end

      private
      def column(w, x, title)
        @pdf.ibox 6.40, w, x, @l1, I18n.t("danfe.det.#{title}")
      end
    end
  end
end
