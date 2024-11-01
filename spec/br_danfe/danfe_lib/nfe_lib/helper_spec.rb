require 'spec_helper'

describe BrDanfe::DanfeLib::NfeLib::Helper do
  describe '.format_date' do
    it 'returns a formated string' do
      string = '2013-10-18T13:54:04'
      expect(described_class.format_date(string)).to eq '18/10/2013'
    end

    describe 'when the source is blank' do
      it 'is empty' do
        expect(described_class.format_date('')).to eq ''
      end
    end
  end

  describe '.format_time' do
    describe 'when param is a complete datetime' do
      let(:param) { '2013-10-18T16:54:04-03:00' }

      it 'is a formated time string in localtime' do
        expect(described_class.format_time(param)).to eq '16:54:04'
      end
    end

    describe 'when param is only a time' do
      let(:param) { '14:23:02' }

      it 'is a formated time string' do
        expect(described_class.format_time(param)).to eq '14:23:02'
      end
    end

    describe 'when param is blank' do
      let(:param) { '' }

      it 'is empty' do
        expect(described_class.format_time(param)).to eq ''
      end
    end
  end

  describe '.address_is_too_big' do
    let(:pdf) { BrDanfe::DanfeLib::NfeLib::Document.new }

    context 'when the address is too big for the street field at DANFE' do
      let(:address) { 'Rua do governo do estado 1125 - Em anexo ao super mercado maior do bairro' }

      it 'returns true' do
        expect(described_class.address_is_too_big(pdf, address)).to be true
      end
    end

    context 'when the address fits in the street field in DANFE' do
      let(:address) { 'Rua do governo do estado 1125 - Salas 1 e 2' }

      it 'returns false' do
        expect(described_class.address_is_too_big(pdf, address)).to be false
      end
    end
  end

  describe '.generate_address' do
    let(:xml) do
      <<~XML
        <enderDest>
          <xLgr>Rua do governo do estado</xLgr>
          <nro>1125</nro>
          <xCpl>Em anexo ao super mercado maior do bairro</xCpl>
        </enderDest>
      XML
    end

    let(:xml_street) do
      Nokogiri::XML(xml)
    end

    it 'returns the address with the street, number and complement' do
      expect(described_class.generate_address(xml_street, 'enderDest'))
        .to eq 'Rua do governo do estado 1125 - Em anexo ao super mercado maior do bairro'
    end

    context "when recipient address hasn't complement" do
      let(:xml) do
        <<~XML
          <enderDest>
            <xLgr>Rua do governo do estado</xLgr>
            <nro>1125</nro>
            <xCpl></xCpl>
          </enderDest>
        XML
      end

      it 'returns the address with the street and number' do
        expect(described_class.generate_address(xml_street, 'enderDest'))
          .to eq 'Rua do governo do estado 1125'
      end
    end

    context "when recipient address hasn't complement and number" do
      let(:xml) do
        <<~XML
          <enderDest>
            <xLgr>Rua do governo do estado</xLgr>
            <nro></nro>
            <xCpl></xCpl>
          </enderDest>
        XML
      end

      it 'returns the address with the street only' do
        expect(described_class.generate_address(xml_street, 'enderDest'))
          .to eq 'Rua do governo do estado'
      end
    end

    context "when recipient address hasn't number" do
      let(:xml) do
        <<~XML
          <enderDest>
            <xLgr>Rua do governo do estado</xLgr>
            <nro></nro>
            <xCpl>Em anexo ao super mercado maior do bairro</xCpl>
          </enderDest>
        XML
      end

      it 'returns the address with the street and complement' do
        expect(described_class.generate_address(xml_street, 'enderDest'))
          .to eq 'Rua do governo do estado - Em anexo ao super mercado maior do bairro'
      end
    end

    context 'when receive the path' do
      let(:xml_entrega) do
        <<~XML
          <entrega>
            <xLgr>Rua estadual</xLgr>
            <nro>3341</nro>
            <xCpl>Em anexo ao bairro</xCpl>
          </entrega>
        XML
      end

      let(:xml_street_entrega) do
        Nokogiri::XML(xml_entrega)
      end

      it 'returns the address scoped by the given path' do
        expect(described_class.generate_address(xml_street_entrega, 'entrega'))
          .to eq 'Rua estadual 3341 - Em anexo ao bairro'
      end
    end
  end
end
