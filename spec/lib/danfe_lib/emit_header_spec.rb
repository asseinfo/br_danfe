require "spec_helper"

describe BrDanfe::DanfeLib::EmitHeader do
  let(:base_dir) { "./spec/fixtures/nfe/lib/"}
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:pdf) { BrDanfe::DanfeLib::Document.new }
  let(:xml) { BrDanfe::DanfeLib::XML.new(xml_as_string) }

  subject { described_class.new(pdf, xml, logo, { width: 100, height: 100 }) }

  describe "#render" do
    let(:xml_as_string) do
      <<-eos
      <nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="2.00">
        <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
          <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
            <ide>
              <tpNF>1</tpNF>
              <nNF>1</nNF>
              <serie>1</serie>
            </ide>
            <emit>
              <xNome>Nome do Remetente Ltda</xNome>
              <enderEmit>
                <xLgr>Rua do Remetente, Casa</xLgr>
                <nro>123</nro>
                <xBairro>Bairro do Remetente</xBairro>
                <xMun>SAO PAULO</xMun>
                <UF>SP</UF>
                <CEP>12345678</CEP>
                <fone>1112345678</fone>
                <email>foo@bar.com</email>
              </enderEmit>
            </emit>
          </infNFe>
        </NFe>
        <protNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="2.00">
          <infProt Id="ID325110012866320">
            <chNFe>25111012345678901234550020000134151000134151</chNFe>
          </infProt>
        </protNFe>
      </nfeProc>
      eos
    end

    before do
      subject.render 3.96
      File.delete(output_pdf) if File.exist?(output_pdf)
    end

    context "without logo" do
      let(:logo) { "" }

      it "renders xml to the pdf" do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}emit_header#render-without_logo.pdf").to have_same_content_of file: output_pdf
      end
    end

    context "with logo" do
      let(:logo) { "spec/fixtures/logo.png" }

      it "renders xml to the pdf" do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}emit_header#render-with_logo.pdf").to have_same_content_of file: output_pdf
      end
    end
  end
end

=begin
require "spec_helper"

describe BrDanfe::DanfeLib::Emit do
  let(:base_dir) { "./spec/fixtures/nfe/lib/"}
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:pdf) { BrDanfe::DanfeLib::Document.new }
  let(:xml) { BrDanfe::DanfeLib::XML.new(xml_as_string) }

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
              <CNPJ>62013294000143</CNPJ>
              <enderEmit>
                <UF>SP</UF>
              </enderEmit>
              <IE>526926313553</IE>
              <IEST>611724092039</IEST>
            </emit>
            <dest>
              <CNPJ>08143375000112</CNPJ>
              <enderDest>
                <UF>SP</UF>
              </enderDest>
            </dest>
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

      expect("#{base_dir}emit#render.pdf").to have_same_content_of file: output_pdf
    end
  end
end
=end
