module BrDanfe
  class Helper
    def self.homologation?(xml)
      xml.css('nfeProc/NFe/infNFe/ide/tpAmb').text == '2'
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
  end
end

#spec
  # describe '.numerify' do
  #   it 'formats with the decimals' do
  #     expect(BrDanfe::DanfeLib::Helper.numerify(0.123)).to eq '0,123'
  #     expect(BrDanfe::DanfeLib::Helper.numerify(0.1234)).to eq '0,1234'
  #     expect(BrDanfe::DanfeLib::Helper.numerify(0.12345)).to eq '0,12345'
  #     expect(BrDanfe::DanfeLib::Helper.numerify(0.1234567891)).to eq '0,1234567891'
  #   end

  #   it 'formats integers' do
  #     expect(BrDanfe::DanfeLib::Helper.numerify(100)).to eq '100,00'
  #   end

  #   it 'formats decimals' do
  #     expect(BrDanfe::DanfeLib::Helper.numerify(123.45)).to eq '123,45'
  #   end

  #   it 'formats thousands' do
  #     expect(BrDanfe::DanfeLib::Helper.numerify(1000)).to eq '1.000,00'
  #   end

  #   it 'formats millions' do
  #     expect(BrDanfe::DanfeLib::Helper.numerify(1_000_000)).to eq '1.000.000,00'
  #   end

  #   it 'formats using two as min decimal precision' do
  #     expect(BrDanfe::DanfeLib::Helper.numerify(123.4)).to eq '123,40'
  #   end

  #   it 'formats 0 to 0,00' do
  #     expect(BrDanfe::DanfeLib::Helper.numerify(0)).to eq '0,00'
  #   end

  #   it "doesn't format nil value" do
  #     expect(BrDanfe::DanfeLib::Helper.numerify(nil)).to eq ''
  #   end

  #   it "doesn't format blank value" do
  #     expect(BrDanfe::DanfeLib::Helper.numerify('')).to eq ''
  #   end
  # end

  # describe '.format_datetime' do
  #   it 'returns a formated string' do
  #     string = '2013-10-18T13:54:04'
  #     expect(BrDanfe::DanfeLib::Helper.format_datetime(string)).to eq '18/10/2013 13:54:04'
  #   end

  #   describe 'when the source is blank' do
  #     it 'is empty' do
  #       expect(BrDanfe::DanfeLib::Helper.format_datetime('')).to eq ''
  #     end
  #   end
  # end
