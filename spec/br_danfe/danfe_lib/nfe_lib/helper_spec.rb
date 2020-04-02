require 'spec_helper'

describe BrDanfe::DanfeLib::NfeLib::Helper do
  describe '.format_date' do
    it 'returns a formated string' do
      string = '2013-10-18T13:54:04'
      expect(BrDanfe::DanfeLib::NfeLib::Helper.format_date(string)).to eq '18/10/2013'
    end

    describe 'when the source is blank' do
      it 'is empty' do
        expect(BrDanfe::DanfeLib::NfeLib::Helper.format_date('')).to eq ''
      end
    end
  end

  describe '.format_time' do
    describe 'when param is a complete datetime' do
      let(:param) { '2013-10-18T16:54:04-03:00' }

      it 'is a formated time string in localtime' do
        expect(BrDanfe::DanfeLib::NfeLib::Helper.format_time(param)).to eq '16:54:04'
      end
    end

    describe 'when param is only a time' do
      let(:param) { '14:23:02' }

      it 'is a formated time string' do
        expect(BrDanfe::DanfeLib::NfeLib::Helper.format_time(param)).to eq '14:23:02'
      end
    end

    describe 'when param is blank' do
      let(:param) { '' }

      it 'is empty' do
        expect(BrDanfe::DanfeLib::NfeLib::Helper.format_time(param)).to eq ''
      end
    end
  end

  describe '.no_fiscal_value?' do
    let(:xml_homologation) do
      xml = <<-eos
        <nfeProc>
          <NFe>
            <infNFe>
              <ide>
                <tpAmb>2</tpAmb>
              </ide>
            </infNFe>
            <protNFe>
              <infProt>
                <dhRecbto>2011-10-29T14:37:09</dhRecbto>
              </infProt>
            </protNFe>
          </NFe>
        </nfeProc>
      eos

      Nokogiri::XML(xml)
    end

    let(:xml_unauthorized) do
      xml = <<-eos
        <nfeProc>
          <protNFe>
            <infProt></infProt>
          </protNFe>
        </nfeProc>
      eos

      Nokogiri::XML(xml)
    end

    let(:xml_authorized) do
      xml = <<-eos
        <nfeProc>
          <NFe>
            <infNFe>
              <ide>
                <tpAmb>1</tpAmb>
              </ide>
            </infNFe>
          </NFe>
          <protNFe>
            <infProt>
              <dhRecbto>2011-10-29T14:37:09</dhRecbto>
            </infProt>
          </protNFe>
        </nfeProc>
      eos

      Nokogiri::XML(xml)
    end

    context 'when XML is unauthorized' do
      it 'returns true' do
        expect(BrDanfe::DanfeLib::NfeLib::Helper.no_fiscal_value?(xml_unauthorized)).to eq true
      end
    end

    context 'when XML is in homologation environment' do
      it 'returns true' do
        expect(BrDanfe::DanfeLib::NfeLib::Helper.no_fiscal_value?(xml_homologation)).to eq true
      end
    end

    context 'when XML is authorized' do
      it 'returns false' do
        expect(BrDanfe::DanfeLib::NfeLib::Helper.no_fiscal_value?(xml_authorized)).to eq false
      end
    end
  end

  describe '.address_is_too_big' do
    let(:pdf) { BrDanfe::DanfeLib::NfeLib::Document.new }

    context 'when the address is too big for the street field at DANFE' do
      let(:address) { 'Rua do governo do estado 1125 - Em anexo ao super mercado maior do bairro' }

      it 'returns true' do
        expect(BrDanfe::DanfeLib::NfeLib::Helper.address_is_too_big(pdf, address)).to be true
      end
    end

    context 'when the address fits in the street field in DANFE' do
      let(:address) { 'Rua do governo do estado 1125 - Salas 1 e 2' }

      it 'returns false' do
        expect(BrDanfe::DanfeLib::NfeLib::Helper.address_is_too_big(pdf, address)).to be false
      end
    end
  end

  describe '.generate_address' do
    let(:xml) do
      <<-eos
        <enderDest>
          <xLgr>Rua do governo do estado</xLgr>
          <nro>1125</nro>
          <xCpl>Em anexo ao super mercado maior do bairro</xCpl>
        </enderDest>
      eos
    end

    let(:xml_street) do
      Nokogiri::XML(xml)
    end

    it 'returns the address with the street, number and complement' do
      expect(BrDanfe::DanfeLib::NfeLib::Helper.generate_address(xml_street))
        .to eq 'Rua do governo do estado 1125 - Em anexo ao super mercado maior do bairro'
    end

    context "when recipient address hasn't complement" do
      let(:xml) do
        <<-eos
        <enderDest>
          <xLgr>Rua do governo do estado</xLgr>
          <nro>1125</nro>
          <xCpl></xCpl>
        </enderDest>
        eos
      end

      it 'returns the address with the street and number' do
        expect(BrDanfe::DanfeLib::NfeLib::Helper.generate_address(xml_street))
          .to eq 'Rua do governo do estado 1125'
      end
    end

    context "when recipient address hasn't complement and number" do
      let(:xml) do
        <<-eos
        <enderDest>
          <xLgr>Rua do governo do estado</xLgr>
          <nro></nro>
          <xCpl></xCpl>
        </enderDest>
        eos
      end

      it 'returns the address with the street only' do
        expect(BrDanfe::DanfeLib::NfeLib::Helper.generate_address(xml_street))
          .to eq 'Rua do governo do estado'
      end
    end

    context "when recipient address hasn't number" do
      let(:xml) do
        <<-eos
        <enderDest>
          <xLgr>Rua do governo do estado</xLgr>
          <nro></nro>
          <xCpl>Em anexo ao super mercado maior do bairro</xCpl>
        </enderDest>
        eos
      end

      it 'returns the address with the street and complement' do
        expect(BrDanfe::DanfeLib::NfeLib::Helper.generate_address(xml_street))
          .to eq 'Rua do governo do estado - Em anexo ao super mercado maior do bairro'
      end
    end
  end
end
