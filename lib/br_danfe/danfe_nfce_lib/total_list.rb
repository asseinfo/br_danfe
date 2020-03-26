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
        totals
        payment_methods
      end

      private

      def totals
        @pdf.y -= 0.3.cm
        @pdf.ibox LINE_HEIGHT, 7.4, 0, @pdf.cursor, '', 'Qtde. total de itens', { size: 7, align: :left, border: 0 }
        @pdf.ibox LINE_HEIGHT, 7.4, 0, @pdf.cursor, '', @xml.css('det').count.to_s, { size: 7, align: :right, border: 0 }

        @pdf.y -= 0.3.cm
        @pdf.ibox LINE_HEIGHT, 7.4, 0, @pdf.cursor, '', 'Subtotal R$', { size: 7, align: :left, border: 0 }
        @pdf.inumeric LINE_HEIGHT, 7.4, 0, @pdf.cursor, @xml['ICMSTot > vProd'], { size: 7, align: :right, border: 0 }

        @pdf.y -= 0.3.cm
        @pdf.ibox LINE_HEIGHT, 7.4, 0, @pdf.cursor, '', 'Desconto R$', { size: 7, align: :left, border: 0 }
        @pdf.inumeric LINE_HEIGHT, 7.4, 0, @pdf.cursor, @xml['ICMSTot > vDesc'], { size: 7, align: :right, border: 0 }

        @pdf.y -= 0.3.cm
        @pdf.ibox LINE_HEIGHT, 7.4, 0, @pdf.cursor, '', 'Valor Total R$', { size: 7, align: :left, border: 0, style: :bold }
        @pdf.inumeric LINE_HEIGHT, 7.4, 0, @pdf.cursor, @xml['ICMSTot > vNF'], { size: 7, align: :right, border: 0, style: :bold }
      end

      def payment_methods
        payments = {}
        without_payment = '90'

        @xml.css('detPag').each do |detPag|
          next if detPag.css('tPag').text == without_payment
          payments[detPag.css('tPag').text] ||= BigDecimal('0')
          actual_payment_value = BigDecimal(detPag.css('vPag').text)
          payments[detPag.css('tPag').text] += actual_payment_value
        end

        if payments.present?
          @pdf.y -= 0.6.cm
          @pdf.ibox LINE_HEIGHT, 7.4, 0, @pdf.cursor, '', 'Forma de pagamento', { size: 7, align: :left, border: 0, style: :bold }
          @pdf.ibox LINE_HEIGHT, 7.4, 0, @pdf.cursor, '', 'Valor pago R$', { size: 7, align: :right, border: 0, style: :bold }

          payments.each do |key, value|
            @pdf.y -= 0.3.cm
            @pdf.ibox LINE_HEIGHT, 7.4, 0, @pdf.cursor, '', I18n.t("nfce.payment_methods.#{key}"), { size: 7, align: :left, border: 0 }
            @pdf.inumeric LINE_HEIGHT, 7.4, 0, @pdf.cursor, value.to_f, { size: 7, align: :right, border: 0 }
          end
        end
      end
    end
  end
end


# @pdf.text "<b>Texto</b>", inline_format: true, align: :left
# @pdf.y += @pdf.height_of("Texto")
# @pdf.text "Texto", inline_format: true, align: :right
