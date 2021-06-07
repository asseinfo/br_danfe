module BrDanfe
  class Helper
    def self.no_fiscal_value?(xml)
      homologation?(xml) || unauthorized?(xml)
    end

    def self.homologation?(xml)
      xml.css('nfeProc/NFe/infNFe/ide/tpAmb').text == '2'
    end

    def self.unauthorized?(xml)
      xml.css('nfeProc/protNFe/infProt/dhRecbto').empty?
    end

    def self.numerify(number)
      return '' if !number || number == ''

      separated_number = number.to_s.split('.')
      integer_part = separated_number[0].reverse.gsub(/\d{3}(?=\d)/, '\&.').reverse
      decimal_part = separated_number[1] || '00'
      decimal_part += '0' if decimal_part.size < 2

      integer_part + ',' + decimal_part
    end

    def self.format_datetime(xml_datetime)
      formated = ''

      unless xml_datetime.empty?
        date = DateTime.strptime(xml_datetime, '%Y-%m-%dT%H:%M:%S')
        formated = date.strftime('%d/%m/%Y %H:%M:%S')
      end

      formated
    end

    def self.nfe?(xml)
      nfe_code = '55'

      xml['ide > mod'] == nfe_code
    end
  end
end
