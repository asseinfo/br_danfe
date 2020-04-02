module BrDanfe
  module DanfeLib
    module NfceLib
      class TotalList
        require 'bigdecimal'

        def initialize(pdf, xml)
          @pdf = pdf
          @xml = xml
        end

        def render
          subtotal
          totals
          payment_methods
        end

        private

        def subtotal
          cursor = @pdf.cursor
          @pdf.bounding_box [4.8.cm, cursor], width: 1.4.cm, height: 0.2.cm do
            @pdf.text 'Subtotal R$', size: 6, align: :left
          end
          @pdf.bounding_box [6.2.cm, cursor], width: 1.2.cm, height: 0.2.cm do
            @pdf.text BrDanfe::Helper.numerify(@xml['ICMSTot > vProd'].to_f), size: 6, align: :right
          end
        end

        def totals
          @pdf.render_blank_line

          cursor = @pdf.cursor
          print_text('Qtde. total de itens', cursor, size: 7, align: :left)
          print_text(@xml.css('det').count.to_s, cursor, size: 7, align: :right)

          cursor = @pdf.cursor
          print_text('Desconto R$', cursor, size: 7, align: :left)
          print_text(BrDanfe::Helper.numerify(@xml['ICMSTot > vDesc'].to_f), cursor, size: 7, align: :right)

          cursor = @pdf.cursor
          print_text('Valor Total R$', cursor, size: 7, align: :left, style: :bold)
          print_text(BrDanfe::Helper.numerify(@xml['ICMSTot > vNF'].to_f), cursor, size: 7, align: :right, style: :bold)
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
            print_text('Forma de pagamento', cursor, size: 7, align: :left, style: :bold)
            print_text('Valor pago R$', cursor, size: 7, align: :right, style: :bold)

            payments.each do |key, value|
              cursor = @pdf.cursor
              print_text(I18n.t("nfce.payment_methods.#{key}"), cursor, size: 7, align: :left)
              print_text(BrDanfe::Helper.numerify(value.to_f), cursor, size: 7, align: :right)
            end
          end
        end

        def print_text(text, cursor, options)
          @pdf.bounding_box [0, cursor], width: 7.4.cm, height: 0.25.cm do
            @pdf.text text, options
          end
        end
      end
    end
  end
end
