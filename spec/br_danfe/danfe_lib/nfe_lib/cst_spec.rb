require 'spec_helper'

describe BrDanfe::DanfeLib::NfeLib::Cst do
  let(:xml_cst) do
    xml = <<~XML
      <imposto>
        <ICMS>
          <ICMS00>
            <orig>5</orig>
            <CST>00</CST>
            <modBC>3</modBC>
            <vBC>49.23</vBC>
            <pICMS>12.00</pICMS>
            <vICMS>5.90</vICMS>
          </ICMS00>
        </ICMS>
      </imposto>
    XML

    Nokogiri::XML(xml)
  end

  let(:xml_csosn) do
    xml = <<~XML
      <imposto>
        <ICMS>
          <ICMSSN102>
            <orig>4</orig>
            <CSOSN>102</CSOSN>
          </ICMSSN102>
        </ICMS>
      </imposto>
    XML

    Nokogiri::XML(xml)
  end

  describe '.to_danfe' do
    context 'when CST' do
      it 'returns origin + CST' do
        expect(BrDanfe::DanfeLib::NfeLib::Cst.to_danfe(xml_cst)).to eq '500'
      end
    end

    context 'when CSOSN' do
      it 'returns origin + CSOSN' do
        expect(BrDanfe::DanfeLib::NfeLib::Cst.to_danfe(xml_csosn)).to eq '4102'
      end
    end
  end
end
