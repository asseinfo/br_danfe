require 'spec_helper'

describe BrDanfe::DanfeLib::NfceLib::Helper do
  let(:xml) do
    xml = <<-eos
      <enderDest>
        <xLgr>Rua Tijucas</xLgr>
        <nro>99</nro>
        <xCpl>dwdwa</xCpl>
        <xBairro>Centro</xBairro>
        <cMun>4218004</cMun>
        <xMun>TIJUCAS</xMun>
        <UF>SC</UF>
        <CEP>88200000</CEP>
        <cPais>1058</cPais>
        <xPais>Brasil</xPais>
      </enderDest>
    eos

    BrDanfe::XML.new(xml)
  end

  describe '#address' do
    it 'returns a formated address string' do
      expect(described_class.address(xml)).to eql 'Rua Tijucas, 99, Centro, TIJUCAS - SC'
    end
  end
end
