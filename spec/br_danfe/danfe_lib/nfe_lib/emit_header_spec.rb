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
                <det nItem="1">
                  <prod>
                    <detExport>
                      <exportInd>
                        <chNFe>41211285493849000105550020000027171182910239</chNFe>
                      </exportInd>
                    </detExport>
                  </prod>
                </det>
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

    it 'renders only the nfe key' do
      subject.render 2, 1.85, 2
      FileUtils.rm_f(output_pdf)

      pdf.render_file output_pdf

      expect("#{base_dir}emit_header#render-nfe_key.pdf").to have_same_content_of file: output_pdf
    end

    context 'render emitter on first page' do
      before do
        subject.render 1, 3.96, 1
        FileUtils.rm_f(output_pdf)
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
        FileUtils.rm_f(output_pdf)
      end

      context 'with logo' do
        it 'renders xml to the pdf' do
          expect(File.exist?(output_pdf)).to be_falsey

          pdf.render_file output_pdf

          expect("#{base_dir}emit_header#render-second_page.pdf").to have_same_content_of file: output_pdf
        end
      end
    end

    context 'when emitter has CPF instead of CNPJ' do
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
                  <xNome>Nome do Remetente</xNome>
                  <CPF>86893723008</CPF>
                  <IE>526926313553</IE>
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
                <det nItem="1">
                  <prod>
                    <detExport>
                      <exportInd>
                        <chNFe>41211285493849000105550020000027171182910239</chNFe>
                      </exportInd>
                    </detExport>
                  </prod>
                </det>
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

      before do
        subject.render 1, 3.96, 1
        FileUtils.rm_f(output_pdf)
      end

      it 'renders xml with CPF to the pdf' do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}emit_header#render-with_cpf.pdf").to have_same_content_of file: output_pdf
      end
    end
  end

  describe '#render with the tax regime code' do
    let(:pdf_text) { PDF::Inspector::Text.analyze(pdf.render).strings.join("\n") }
    let(:issued_at) { '2026-12-02T10:00:00-03:00' }
    let(:crt) { '3' }
    let(:ibscbs_regime) { '' }
    let(:xml_as_string) do
      <<~XML
        <nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00">
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe versao="4.00">
              <ide><dhEmi>#{issued_at}</dhEmi><tpNF>1</tpNF><nNF>1</nNF><serie>1</serie></ide>
              <emit>
                <xNome>Nome do Remetente Ltda</xNome><CNPJ>62013294000143</CNPJ><CRT>#{crt}</CRT>#{ibscbs_regime}
              </emit>
            </infNFe>
          </NFe>
        </nfeProc>
      XML
    end

    before { subject.render(1, 3.96, 1) }

    context 'when the NF-e uses the NT 2026.010 layout' do
      it 'renders the tax regime code' do
        expect(pdf_text).to include("CÓDIGO DO REGIME TRIBUTÁRIO\n3 - REGIME NORMAL")
      end
    end

    context 'when the tax regime code is unknown' do
      let(:crt) { '9' }

      it 'renders the code as informed' do
        expect(pdf_text).to include("CÓDIGO DO REGIME TRIBUTÁRIO\n9")
      end
    end

    context 'when the NF-e uses the current layout' do
      let(:issued_at) { '2026-11-20T10:00:00-03:00' }

      it 'does not render the tax regime code' do
        expect(pdf_text).not_to include('CÓDIGO DO REGIME TRIBUTÁRIO')
      end

      it 'does not render the IBS/CBS regime type' do
        expect(pdf_text).not_to include('TIPO DE REGIME DE APURAÇÃO DO IBS E DA CBS')
      end
    end

    context 'when the NF-e has the IBS/CBS regime type' do
      let(:crt) { '1' }
      let(:ibscbs_regime) { '<tpRegimeIBSCBS>1</tpRegimeIBSCBS>' }

      it 'renders only the IBS/CBS regime type title' do
        expect(pdf_text).to end_with('TIPO DE REGIME DE APURAÇÃO DO IBS E DA CBS')
      end
    end
  end

  describe '.offset' do
    subject { described_class.offset(xml) }

    let(:issued_at) { '2026-12-02T10:00:00-03:00' }
    let(:xml_as_string) do
      <<~XML
        <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
          <infNFe versao="4.00"><ide><dhEmi>#{issued_at}</dhEmi></ide></infNFe>
        </NFe>
      XML
    end

    context 'when the NF-e uses the NT 2026.010 layout' do
      it('is the tax regime line') { is_expected.to eql 0.8 }
    end

    context 'when the NF-e uses the current layout' do
      let(:issued_at) { '2026-11-20T10:00:00-03:00' }

      it('adds nothing') { is_expected.to eql 0.0 }
    end
  end
end
