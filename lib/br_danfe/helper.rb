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

    def self.format_datetime(xml_datetime, with_time_zone: false)
      formated = with_time_zone ? '%d/%m/%Y %H:%M:%S%:z' : '%d/%m/%Y %H:%M:%S'
      xml_datetime.present? ? Time.parse(xml_datetime).strftime(formated) : ''
    end

    def self.nfe?(xml)
      nfe_code = '55'

      xml['ide > mod'] == nfe_code
    end

    def self.format_cep(cep)
      cep.sub(/(\d{2})(\d{3})(\d{3})/, '\\1.\\2-\\3')
    end
  end
end
