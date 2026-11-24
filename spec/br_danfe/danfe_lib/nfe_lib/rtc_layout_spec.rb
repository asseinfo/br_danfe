require 'spec_helper'

describe BrDanfe::DanfeLib::NfeLib::RtcLayout do
  let(:xml) { BrDanfe::XML.new(xml_as_string) }

  describe '.applies?' do
    subject { described_class.applies?(xml) }

    context 'when the NF-e has the IBS/CBS totals' do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe versao="4.00">
              <ide><dhEmi>2026-11-10T10:00:00-03:00</dhEmi></ide>
              <total><IBSCBSTot><vBCIBSCBS>100.00</vBCIBSCBS></IBSCBSTot></total>
            </infNFe>
          </NFe>
        XML
      end

      it { is_expected.to be true }
    end

    context 'when the NF-e was issued on the start date' do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe versao="4.00"><ide><dhEmi>2026-12-01T00:00:00-03:00</dhEmi></ide></infNFe>
          </NFe>
        XML
      end

      it { is_expected.to be true }
    end

    context 'when the NF-e was issued before the start date in its own time zone' do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe versao="4.00"><ide><dhEmi>2026-11-30T23:59:00-03:00</dhEmi></ide></infNFe>
          </NFe>
        XML
      end

      it { is_expected.to be false }
    end

    context 'when an NF-e 2.00 was issued from the start date' do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe versao="2.00"><ide><dEmi>2026-12-05</dEmi></ide></infNFe>
          </NFe>
        XML
      end

      it { is_expected.to be true }
    end

    context 'when an NF-e 2.00 was issued before the start date' do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe versao="2.00"><ide><dEmi>2015-01-14</dEmi></ide></infNFe>
          </NFe>
        XML
      end

      it { is_expected.to be false }
    end

    context 'when the NF-e has no issue date' do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe"><infNFe versao="4.00"><ide/></infNFe></NFe>
        XML
      end

      it { is_expected.to be false }
    end
  end
end
