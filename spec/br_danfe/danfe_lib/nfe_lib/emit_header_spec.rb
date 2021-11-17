require 'spec_helper'

describe BrDanfe::DanfeLib::NfeLib::EmitHeader do
  let(:base_dir) { './spec/fixtures/nfe/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:pdf) { BrDanfe::DanfeLib::NfeLib::Document.new }
  let(:xml) { BrDanfe::XML.new(xml_as_string) }
  let(:logo) { 'spec/fixtures/logo.png' }

  subject { described_class.new(pdf, xml, logo, width: 100, height: 100) }

  describe '#render' do
    let(:xml_as_string) do
      <<~XML
        <nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="2.00">
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
              <ide>
                <tpNF>1</tpNF>
                <nNF>1</nNF>
                <serie>1</serie>
                <natOp>Vendas de producao do estabelecimento</natOp>
              </ide>
              <emit>
                <xNome>Nome do Remetente Ltda</xNome>
                <CNPJ>62013294000143</CNPJ>
                <IE>526926313553</IE>
                <IEST>611724092039</IEST>
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
              <dhRecbto>2011-10-29T14:37:09</dhRecbto>
              <nProt>325110012866320</nProt>
            </infProt>
          </protNFe>
        </nfeProc>
      XML
    end

    context 'render emitter on first page' do
      before do
        subject.render 1, 3.96, 1
        File.delete(output_pdf) if File.exist?(output_pdf)
      end

      context 'with logo' do
        it 'renders xml to the pdf' do
          expect(File.exist?(output_pdf)).to be_falsey

          pdf.render_file output_pdf

          expect("#{base_dir}emit_header#render-with_logo.pdf").to have_same_content_of file: output_pdf
        end
      end

      context 'without logo' do
        let(:logo) { '' }

        it 'renders xml to the pdf' do
          expect(File.exist?(output_pdf)).to be_falsey

          pdf.render_file output_pdf

          expect("#{base_dir}emit_header#render-without_logo.pdf").to have_same_content_of file: output_pdf
        end
      end
    end

    context 'render emitter on second page' do
      before do
        subject.render 2, 1.85, 2
        File.delete(output_pdf) if File.exist?(output_pdf)
      end

      context 'with logo' do
        it 'renders xml to the pdf' do
          expect(File.exist?(output_pdf)).to be_falsey

          pdf.render_file output_pdf

          expect("#{base_dir}emit_header#render-second_page.pdf").to have_same_content_of file: output_pdf
        end
      end
    end
  end
end
