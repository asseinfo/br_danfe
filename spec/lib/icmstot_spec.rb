require "spec_helper"

describe BrDanfe::Icmstot do
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
          <ICMSTot>
            <vBC>1.23</vBC>
            <vICMS>2.34</vICMS>
            <vBCST>3.45</vBCST>
            <vST>4.56</vST>
            <vProd>5.67</vProd>
            <vFrete>6.78</vFrete>
            <vSeg>7.89</vSeg>
            <vDesc>9.01</vDesc>
            <vIPI>0.12</vIPI>
            <vOutro>1.34</vOutro>
            <vNF>4.35</vNF>
          </ICMSTot>
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

      expect("#{base_dir}icmstot#render.pdf").to be_same_file_as(output_pdf)
    end
  end
end
