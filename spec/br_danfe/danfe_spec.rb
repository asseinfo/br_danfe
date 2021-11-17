require 'spec_helper'

describe BrDanfe::Danfe do
  let(:xml) do
    <<~XML
      <nfeProc>
        <NFe>
          <infNFe>
            <ide>
              <mod>#{mod}</mod>
              <NFref>
                <refNFP>
                  <mod>04</mod>
                </refNFP>
              </NFref>
            </ide>
          </infNFe>
        </NFe>
      </nfeProc>
    XML
  end

  subject { described_class.new(xml) }

  context 'xmls parameter' do
    let(:mod) { 55 }

    it 'accepts one xml' do
      subject = described_class.new(xml)

      expect(subject.class).to eq BrDanfe::DanfeLib::Nfe
    end

    it 'accepts an array of xmls' do
      subject = described_class.new([xml, xml])

      expect(subject.class).to eq BrDanfe::DanfeLib::Nfe
    end
  end

  context 'when the xml document type is NF-e' do
    let(:mod) { 55 }

    it 'returns a NF-e danfe class' do
      expect(subject.class).to eq BrDanfe::DanfeLib::Nfe
    end
  end

  context 'when the xml document type is NFC-e' do
    let(:mod) { 65 }

    it 'returns a NFC-e danfe class' do
      expect(subject.class).to eq BrDanfe::DanfeLib::Nfce
    end
  end
end
