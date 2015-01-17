require "spec_helper"

describe BrDanfe::Emit do
  let(:base_dir) { "./spec/fixtures/lib/"}
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:pdf) { BrDanfe::Document.new }
  let(:xml) { BrDanfe::XML.new(xml_as_string) }

  subject { described_class.new(pdf, xml) }

  describe "#render" do
    let(:xml_as_string) do
      <<-eos
      <nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="2.00">
        <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
          <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
            <ide>
              <natOp>Vendas de producao do estabelecimento</natOp>
            </ide>
            <emit>
              <CNPJ>12345678901234</CNPJ>
              <enderEmit>
                <UF>PB</UF>
              </enderEmit>
              <IE>160158257</IE>
              <IE_ST>671008375110</IE_ST>
            </emit>
          </infNFe>
        </NFe>
        <protNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="2.00">
          <infProt Id="ID325110012866320">
            <dhRecbto>2011-10-29T14:37:09</dhRecbto>
            <nProt>325110012866320</nProt>
          </infProt>
        </protNFe>
      </nfeProc>
      eos
    end

    before do
      subject.render
      File.delete(output_pdf) if File.exist?(output_pdf)
    end

    it "renders xml to the pdf" do
      expect(File.exist?(output_pdf)).to be_falsey

      pdf.render_file output_pdf

      expect("#{base_dir}emit#render.pdf").to be_same_file_as(output_pdf)
    end
  end
end
