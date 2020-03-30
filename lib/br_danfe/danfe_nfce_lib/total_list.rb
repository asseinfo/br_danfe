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
          @pdf.render_blank_line

          cursor = @pdf.cursor
          print_text('Forma de pagamento', cursor, { size: 7, align: :left, style: :bold })
          print_text('Valor pago R$', cursor, { size: 7, align: :right, style: :bold })

          payments.each do |key, value|
            cursor = @pdf.cursor
            print_text(I18n.t("nfce.payment_methods.#{key}"), cursor, { size: 7, align: :left })
            print_text(BrDanfe::DanfeNfceLib::Helper.numerify(value.to_f), cursor, { size: 7, align: :right })
          end
        end
      end
    end
  end
end
