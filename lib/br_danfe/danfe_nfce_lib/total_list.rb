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

      def print_text(text, cursor, options)
        @pdf.bounding_box [0.085.cm, cursor], width: 7.25.cm, height: 0.25.cm do
          @pdf.text text, options
        end
      end

      def totals
        @pdf.render_blank_line

        cursor = @pdf.cursor
        print_text('Qtde. total de itens', cursor, { size: 7, align: :left })
        print_text(@xml.css('det').count.to_s, cursor, { size: 7, align: :right })

        cursor = @pdf.cursor
        print_text('Subtotal R$', cursor, { size: 7, align: :left})
        print_text(@xml['ICMSTot > vProd'], cursor, { size: 7, align: :right })

        cursor = @pdf.cursor
        print_text('Desconto R$', cursor, { size: 7, align: :left})
        print_text(@xml['ICMSTot > vDesc'], cursor, { size: 7, align: :right })

        cursor = @pdf.cursor
        print_text('Valor Total R$', cursor, { size: 7, align: :left, style: :bold })
        print_text(@xml['ICMSTot > vDesc'], cursor, { size: 7, align: :right, style: :bold })
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
