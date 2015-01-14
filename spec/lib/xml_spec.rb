require "spec_helper"

describe BrDanfe::XML do
  subject { BrDanfe::XML.new(xml_as_string) }

  describe "#version_310?" do
    describe "when xml's version is 3.10" do
      let(:xml_as_string) do
        <<-eos
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe versao="3.10" Id="NFe35150162013294000143550010000000011000000017">
            </infNFe>
          </NFe>
        eos
      end

      it "is true" do
        expect(subject.version_310?).to be_truthy
      end
    end

    describe "when xml's version isn't 3.10" do
      let(:xml_as_string) do
        <<-eos
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe versao="2.00" Id="NFe35131260891033000109550010000000011000000016">
            </infNFe>
          </NFe>
        eos
      end

      it "is false" do
        expect(subject.version_310?).to be_falsey
      end
    end
  end
end
