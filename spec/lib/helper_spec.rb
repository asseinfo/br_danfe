require 'spec_helper'

describe BrDanfe::Helper do
  describe '.homologation?' do
    context 'when tpAmb is equal to "2"' do
      let(:xml_homologation) do
        xml = <<-eos
          <nfeProc>
            <NFe>
              <infNFe>
                <ide>
                  <tpAmb>2</tpAmb>
                </ide>
              </infNFe>
            </NFe>
          </nfeProc>
        eos

        Nokogiri::XML(xml)
      end

      it 'returns true' do
        expect(described_class.homologation?(xml_homologation)).to be true
      end
    end

    context 'when tpAmb is different to "2"' do
      let(:xml_production) do
        xml = <<-eos
          <nfeProc>
            <NFe>
              <infNFe>
                <ide>
                  <tpAmb>1</tpAmb>
                </ide>
              </infNFe>
            </NFe>
          </nfeProc>
        eos

        Nokogiri::XML(xml)
      end

      it 'returns true' do
        expect(described_class.homologation?(xml_production)).to be false
      end
    end
  end

  describe '.numerify' do
    it 'formats with the decimals' do
      expect(described_class.numerify(0.123)).to eql '0,123'
      expect(described_class.numerify(0.1234)).to eql '0,1234'
      expect(described_class.numerify(0.12345)).to eql '0,12345'
      expect(described_class.numerify(0.1234567891)).to eql '0,1234567891'
    end

    it 'formats integers' do
      expect(described_class.numerify(100)).to eql '100,00'
    end

    it 'formats decimals' do
      expect(described_class.numerify(123.45)).to eql '123,45'
    end

    it 'formats thousands' do
      expect(described_class.numerify(1000)).to eql '1.000,00'
    end

    it 'formats millions' do
      expect(described_class.numerify(1_000_000)).to eql '1.000.000,00'
    end

    it 'formats using two as min decimal precision' do
      expect(described_class.numerify(123.4)).to eql '123,40'
    end

    it 'formats 0 to 0,00' do
      expect(described_class.numerify(0)).to eql '0,00'
    end

    it 'does not format nil value' do
      expect(described_class.numerify(nil)).to eql ''
    end

    it 'does not format blank value' do
      expect(described_class.numerify('')).to eql ''
    end
  end

  describe '.format_datetime' do
    it 'returns a formated string' do
      expect(described_class.format_datetime('2013-10-18T13:54:04')).to eql '18/10/2013 13:54:04'
    end

    describe 'when the source is blank' do
      it 'is empty' do
        expect(described_class.format_datetime('')).to eql ''
      end
    end
  end
end
