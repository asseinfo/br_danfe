module BrDanfe
  module DanfeNfceLib
    class TotalList
      LINE_HEIGHT = 1.35

      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def render
        @pdf.y -= 0.3.cm
        @pdf.ibox LINE_HEIGHT, 7.4, 0, @pdf.cursor, '', 'Qtde. total de itens', { size: 7, align: :left, border: 0 }
        @pdf.ibox LINE_HEIGHT, 7.4, 0, @pdf.cursor, '', @xml.css('det').count.to_s, { size: 7, align: :right, border: 0 }

        @pdf.y -= 0.30.cm
        @pdf.ibox LINE_HEIGHT, 7.4, 0, @pdf.cursor, '', 'Subtotal R$', { size: 7, align: :left, border: 0 }
        @pdf.inumeric LINE_HEIGHT, 7.4, 0, @pdf.cursor, @xml['ICMSTot > vProd'], { size: 7, align: :right, border: 0 }

        @pdf.y -= 0.30.cm
        @pdf.ibox LINE_HEIGHT, 7.4, 0, @pdf.cursor, '', 'Desconto R$', { size: 7, align: :left, border: 0 }
        @pdf.inumeric LINE_HEIGHT, 7.4, 0, @pdf.cursor, @xml['ICMSTot > vDesc'], { size: 7, align: :right, border: 0 }

        @pdf.y -= 0.30.cm
        @pdf.ibox LINE_HEIGHT, 7.4, 0, @pdf.cursor, '', 'Valor Total R$', { size: 7, align: :left, border: 0, style: :bold }
        @pdf.inumeric LINE_HEIGHT, 7.4, 0, @pdf.cursor, @xml['ICMSTot > vNF'], { size: 7, align: :right, border: 0 }
      end
    end
  end
end
