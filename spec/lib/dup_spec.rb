require "spec_helper"

describe BrDanfe::Dup do
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
          <cobr>
            <dup>
              <nDup>1</nDup>
              <dVenc>2015-02-13</dVenc>
              <vDup>25.56</vDup>
            </dup>
            <dup>
              <nDup>2</nDup>
              <dVenc>2015-03-15</dVenc>
              <vDup>25.56</vDup>
            </dup>
            <dup>
              <nDup>3</nDup>
              <dVenc>2015-04-14</dVenc>
              <vDup>25.55</vDup>
            </dup>
          </cobr>
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

      expect("#{base_dir}dup#render.pdf").to be_same_file_as(output_pdf)
    end
  end
end
