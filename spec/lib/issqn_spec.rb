require "spec_helper"

describe BrDanfe::Issqn do
  let(:base_dir) { "./spec/fixtures/lib/"}
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:pdf) { BrDanfe::Document.new }
  let(:xml) { BrDanfe::XML.new(xml_as_string) }

  subject { described_class.new(pdf, xml) }

  describe "#render" do
    let(:xml_as_string) do
      <<-eos
      <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
        <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
          <emit>
            <IM>2345</IM>
          </emit>
          <total>
            <ISSQNtot>
              <vServ>1.43</vServ>
              <vBC>2.34</vBC>
              <vISS>3.45</vISS>
            </ISSQNtot>
          </total>
        </infNFe>
      </NFe>
      eos
    end

    before do
      subject.render
      File.delete(output_pdf) if File.exist?(output_pdf)
    end

    it "renders xml to the pdf" do
      expect(File.exist?(output_pdf)).to be_falsey

      pdf.render_file output_pdf

      expect("#{base_dir}issqn#render.pdf").to have_same_content_of file: output_pdf
    end
  end
end
