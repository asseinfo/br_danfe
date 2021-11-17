require 'spec_helper'

describe BrDanfe::XML do
  subject { described_class.new(xml_as_string) }

  describe '#version_is_310_or_newer?' do
    describe "when xml's version is equal 3.10" do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe versao="3.10" Id="NFe35150162013294000143550010000000011000000017">
            </infNFe>
          </NFe>
        XML
      end

      it 'returns true' do
        expect(subject.version_is_310_or_newer?).to eql true
      end
    end

    describe "when xml's version is greather 3.10" do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe versao="4.00" Id="NFe35150162013294000143550010000000011000000017">
            </infNFe>
          </NFe>
        XML
      end

      it 'returns true' do
        expect(subject.version_is_310_or_newer?).to eql true
      end
    end

    describe "when xml's version is minor that 3.10" do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe versao="2.00" Id="NFe35131260891033000109550010000000011000000016">
            </infNFe>
          </NFe>
        XML
      end

      it 'returns false' do
        expect(subject.version_is_310_or_newer?).to eql false
      end
    end
  end
end
