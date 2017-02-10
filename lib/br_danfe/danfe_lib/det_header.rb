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

        column(1.60, 0.75, "prod.cProd")
        column(6.10, 2.35, "prod.xProd")
        column(1.05, 8.45, "prod.NCM")
        column(0.60, 9.50, "ICMS.CST")
        column(0.65, 10.10, "prod.CFOP")
        column(1.10, 10.75, "prod.uCom")
        column(1.20, 11.85, "prod.qCom")
        column(1.20, 13.05, "prod.vUnCom")
        column(1.20, 14.25, "prod.vProd")
        column(1.20, 15.45, "ICMS.vBC")
        column(1.00, 16.65, "ICMS.vICMS")
        column(1.00, 17.65, "IPI.vIPI")
        column(0.90, 18.65, "ICMS.pICMS")
        column(0.76, 19.55, "IPI.pIPI")

        @pdf.horizontal_line 0.75.cm, 20.31.cm, at: Helper.invert(19.59.cm)
      end

      private
      def column(w, x, title)
        @pdf.ibox 6.40, w, x, @l1, I18n.t("danfe.det.#{title}")
      end
    end
  end
end
