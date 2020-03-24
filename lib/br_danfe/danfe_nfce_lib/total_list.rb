module BrDanfe
  module DanfeNfceLib
    class TotalList
      require 'bigdecimal'

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

        @pdf.y -= 0.30.cm
        @pdf.ibox LINE_HEIGHT, 7.4, 0, @pdf.cursor, '', 'Forma de pagamento', { size: 7, align: :left, border: 0 }

        # { money: '01', check: '02', credit_card: '03', debit_card: '04', credit: '05', without_payment: '90', others: '99' }
        payments = {}
        @xml.css('detPag').each do |detPag|
          # byebug
          payments[detPag.css('tPag').text] ||= BigDecimal('0')
          actual_payment_value = BigDecimal(detPag.css('vPag').text)

          payments[detPag.css('tPag').text] += actual_payment_value
        end

        p "payments ==> #{payments["05"].to_f}"
        # payments.
        # @pdf.inumeric LINE_HEIGHT, 7.4, 0, @pdf.cursor, @xml['ICMSTot > vNF'], { size: 7, align: :right, border: 0 }
      end
    end
  end
end
