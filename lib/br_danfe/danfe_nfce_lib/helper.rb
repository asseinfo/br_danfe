module BrDanfe
  module DanfeNfceLib
    class Helper
      # FIXME: refatorar aqui
      def self.invert(page_height, y_position)
        height_in_cm = ((page_height / 2.84) / 10).cm
        position_zero = 1.3.cm

        height_in_cm - position_zero - y_position
      end

      # FIXME: CENTRALIZAR
      def self.numerify(number)
        return '' if !number || number == ''

        separated_number = number.to_s.split('.')
        integer_part = separated_number[0].reverse.gsub(/\d{3}(?=\d)/, '\&.').reverse
        decimal_part = separated_number[1] || '00'
        decimal_part += '0' if decimal_part.size < 2

        integer_part + ',' + decimal_part
      end

      def self.payment_method_name(payment_method)
        payment_methods = { money: '01', check: '02', credit_card: '03', debit_card: '04', credit: '05',
          without_payment: '90', others: '99' }

        payment_methods[payment_method]
      end
      # def self.format_datetime(xml_datetime)
      #   formated = ''

      #   unless xml_datetime.empty?
      #     date = DateTime.strptime(xml_datetime, '%Y-%m-%dT%H:%M:%S')
      #     formated = date.strftime('%d/%m/%Y %H:%M:%S')
      #   end

      #   formated
      # end

      # def self.format_date(xml_datetime)
      #   formated = ''

      #   unless xml_datetime.empty?
      #     date = DateTime.strptime(xml_datetime, '%Y-%m-%d')
      #     formated = date.strftime('%d/%m/%Y')
      #   end

      #   formated
      # end

      # def self.format_time(xml_datetime)
      #   formated = ''

      #   if xml_datetime.length == 8
      #     formated = xml_datetime
      #   elsif xml_datetime.length > 8
      #     date = DateTime.strptime(xml_datetime, '%Y-%m-%dT%H:%M:%S %Z').to_time
      #     formated = date.strftime('%H:%M:%S')
      #   end

      #   formated
      # end

      # def self.no_fiscal_value?(xml)
      #   homologation?(xml) || unauthorized?(xml)
      # end

      # def self.homologation?(xml)
      #   xml_text(xml, 'nfeProc/NFe/infNFe/ide/tpAmb') == '2'
      # end

      # def self.unauthorized?(xml)
      #   xml.css('nfeProc/protNFe/infProt/dhRecbto').empty?
      # end

      # def self.mensure_text(pdf, text)
      #   pdf.width_of(text)
      # end

      # def self.address_is_too_big(pdf, address)
      #   Helper.mensure_text(pdf, address) > Dest::MAXIMUM_SIZE_FOR_STREET
      # end

      # def self.generate_address(xml)
      #   address_complement = " - #{xml_text(xml, 'enderDest/xCpl')}" if xml_text(xml, 'enderDest/xCpl').present?
      #   address_number = " #{xml_text(xml, 'enderDest/nro')}" if xml_text(xml, 'enderDest/nro').present?
      #   "#{xml_text(xml, 'enderDest/xLgr')}#{address_number}#{address_complement}"
      # end

      # def self.xml_text(xml, property)
      #   xml.css(property).text
      # end

      # private_class_method :xml_text
    end
  end
end
