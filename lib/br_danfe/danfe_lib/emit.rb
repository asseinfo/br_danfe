module BrDanfe
  module DanfeLib
    class Emit
      Y = 7.88

      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml

        @l1 = Y
        @l2 = Y + LINE_HEIGHT
      end

      def render
        @pdf.lbox LINE_HEIGHT, 10.04, 0.75, @l1, @xml, "ide/natOp"
        @pdf.ibox LINE_HEIGHT, 9.52, 10.79, @l1, I18n.t("danfe.infProt"), @xml["infProt/nProt"] + " " + Helper.format_datetime(@xml["infProt/dhRecbto"]), { align: :center }
        @pdf.lie LINE_HEIGHT, 6.36, 0.75, @l2, @xml, "enderEmit/UF", "emit/IE"
        @pdf.lie LINE_HEIGHT, 6.86, 7.11, @l2, @xml, "enderEmit/UF", "emit/IEST"
        @pdf.lcnpj LINE_HEIGHT, 6.34, 13.97, @l2, @xml, "emit/CNPJ"
      end
    end
  end
end
