module BrDanfe
  module DanfeNfeLib
    class Helper
      def self.invert(y)
        29.7.cm - y
      end

      def self.format_date(xml_datetime)
        formated = ''

        unless xml_datetime.empty?
          date = DateTime.strptime(xml_datetime, '%Y-%m-%d')
          formated = date.strftime('%d/%m/%Y')
        end

        formated
      end

      def self.format_time(xml_datetime)
        formated = ''

        if xml_datetime.length == 8
          formated = xml_datetime
        elsif xml_datetime.length > 8
          date = DateTime.strptime(xml_datetime, '%Y-%m-%dT%H:%M:%S %Z').to_time
          formated = date.strftime('%H:%M:%S')
        end

        formated
      end

      def self.no_fiscal_value?(xml)
        BrDanfe::Helper.homologation?(xml) || unauthorized?(xml)
      end

      def self.unauthorized?(xml)
        xml.css('nfeProc/protNFe/infProt/dhRecbto').empty?
      end

      def self.mensure_text(pdf, text)
        pdf.width_of(text)
      end

      def self.address_is_too_big(pdf, address)
        Helper.mensure_text(pdf, address) > Dest::MAXIMUM_SIZE_FOR_STREET
      end

      def self.generate_address(xml)
        address_complement = " - #{xml_text(xml, 'enderDest/xCpl')}" if xml_text(xml, 'enderDest/xCpl').present?
        address_number = " #{xml_text(xml, 'enderDest/nro')}" if xml_text(xml, 'enderDest/nro').present?
        "#{xml_text(xml, 'enderDest/xLgr')}#{address_number}#{address_complement}"
      end

      def self.xml_text(xml, property)
        xml.css(property).text
      end

      private_class_method :xml_text
    end
  end
end
