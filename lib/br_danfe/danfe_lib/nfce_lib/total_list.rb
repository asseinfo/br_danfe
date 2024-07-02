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
          @pdf.render_blank_line
          cursor = @pdf.cursor
          @pdf.bounding_box [3.5.cm, cursor], width: 1.6.cm, height: 0.4.cm do
            @pdf.text 'Subtotal R$', size: 9, align: :left
          end
          @pdf.bounding_box [5.1.cm, cursor], width: 1.6.cm, height: 0.4.cm do
            @pdf.text BrDanfe::Helper.numerify(@xml['ICMSTot > vProd'].to_f), size: 9, align: :right
          end
        end

        def totals
          @pdf.render_blank_line

          cursor = @pdf.cursor
          print_text('QTD. TOTAL DE ITENS', cursor, size: 10, align: :left)
          print_text(@xml.css('det').count.to_s, cursor, size: 10, align: :right)

          cursor = @pdf.cursor
          print_text('DESCONTO R$', cursor, size: 10, align: :left)
          print_text(BrDanfe::Helper.numerify(@xml['ICMSTot > vDesc'].to_f), cursor, size: 10, align: :right)

          cursor = @pdf.cursor
          print_text('VALOR TOTAL R$', cursor, size: 10, align: :left, style: :bold)
          print_text(BrDanfe::Helper.numerify(@xml['ICMSTot > vNF'].to_f), cursor, size: 10, align: :right, style: :bold)
        end

        # rubocop:disable Metrics/MethodLength
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
            print_text('FORMA PAGTO.', cursor, size: 9, align: :left, style: :bold)
            print_text('VLR PAGO R$', cursor, size: 9, align: :right, style: :bold)

            payments.each do |key, value|
              cursor = @pdf.cursor

              payment_description = prepare_payment_description(I18n.t("nfce.payment_methods.#{key}"))
              print_text(payment_description, cursor, size: 9, align: :left)
              print_text(BrDanfe::Helper.numerify(value.to_f), cursor, size: 9, align: :right)
            end
          end
        end
        # rubocop:enable Metrics/MethodLength

        def print_text(text, cursor, options)
          @pdf.bounding_box [0, cursor], width: 6.7.cm, height: 0.35.cm do
            @pdf.text text, options
          end
        end

        def prepare_payment_description(description)
          maximum_size_for_description = 40

          return "#{description[0..maximum_size_for_description - 3]}..." if description.length > maximum_size_for_description

          description
        end
      end
    end
  end
end
