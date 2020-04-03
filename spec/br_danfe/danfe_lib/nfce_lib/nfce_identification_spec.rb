require 'spec_helper'

describe BrDanfe::DanfeLib::NfceLib::NfceIdentification do
  let(:base_dir) { './spec/fixtures/nfce/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:pdf) { BrDanfe::DanfeLib::NfceLib::Document.new(8.cm, 5.cm) }

  let(:xml) do
    xml = <<-eos
      <nfeProc>
        <NFe>
          <infNFe>
            <ide>
              <dhEmi>2020-03-24T13:33:20-05:00</dhEmi>
              <serie>1</serie>
              <nNF>1629</nNF>
            </ide>
            <protNFe versao="4.00">
              <infProt>
                <nProt>342200000151784</nProt>
                <dhRecbto>2020-03-24T15:36:14-03:00</dhRecbto>
              </infProt>
            </protNFe>
          </infNFe>
        </NFe>
      </nfeProc>
    eos

    BrDanfe::XML.new(xml)
  end

  subject { described_class.new pdf, xml }

  describe '#render' do
    before do
      subject.render
      File.delete(output_pdf) if File.exist?(output_pdf)
    end

    it 'renders nfce identification to the pdf' do
      expect(File.exist?(output_pdf)).to be_falsey
      pdf.render_file output_pdf

      expect("#{base_dir}nfce_identification#render.pdf").to have_same_content_of file: output_pdf
    end
  end
end
