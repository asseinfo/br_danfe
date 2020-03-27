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

      def self.homologation?(xml)
        xml_text(xml, 'nfeProc/NFe/infNFe/ide/tpAmb') == '2'
      end

      def self.format_datetime(xml_datetime)
        formated = ''

        unless xml_datetime.empty?
          date = DateTime.strptime(xml_datetime, '%Y-%m-%dT%H:%M:%S')
          formated = date.strftime('%d/%m/%Y %H:%M:%S')
        end

        formated
      end

      def self.xml_text(xml, property)
        xml.css(property).text
      end

      private_class_method :xml_text
    end
  end
end
