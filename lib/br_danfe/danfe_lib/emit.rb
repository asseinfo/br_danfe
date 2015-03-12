module BrDanfe
  module DanfeLib
    class Emit
      Y = 6.46

      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml

        @l1 = Y
        @l2 = Y + LINE_HEIGHT
      end

      def render
        @pdf.lbox LINE_HEIGHT, 10.54, 0.25, @l1, @xml, "ide/natOp"
        @pdf.ibox LINE_HEIGHT, 10.02, 10.79, @l1, I18n.t("danfe.infProt"), @xml["infProt/nProt"] + " " + Helper.format_datetime(@xml["infProt/dhRecbto"]), { align: :center }
        @pdf.lie LINE_HEIGHT, 6.86, 0.25, @l2, @xml, "enderEmit/UF", "emit/IE"
        @pdf.lie LINE_HEIGHT, 6.86, 7.11, @l2, @xml, "enderEmit/UF", "emit/IE_ST"
        @pdf.lcnpj LINE_HEIGHT, 6.84, 13.97, @l2, @xml, "emit/CNPJ"
      end
    end
  end
end
