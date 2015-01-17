require "spec_helper"

describe BrDanfe::Transp do
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
          <transp>
            <modFrete>0</modFrete>
            <transporta>
              <CNPJ>71434064000149</CNPJ>
              <xNome>Nome do Transportador Ltda</xNome>
              <IE>964508990089</IE>
              <xEnder>Rua do Transportador, 456</xEnder>
              <xMun>Votorantim</xMun>
              <UF>SP</UF>
            </transporta>
            <veicTransp>
              <placa>ABC-1234</placa>
              <UF>SP</UF>
              <RNTC>123456</RNTC>
            </veicTransp>
          </transp>
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

      expect("#{base_dir}transp#render.pdf").to be_same_file_as(output_pdf)
    end
  end
end
