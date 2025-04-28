require 'spec_helper'

describe BrDanfe::DanfeLib::NfeLib::Transp do
  let(:base_dir) { './spec/fixtures/nfe/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:pdf) { BrDanfe::DanfeLib::NfeLib::Document.new }
  let(:xml) { BrDanfe::XML.new(xml_as_string) }

  subject { described_class.new(pdf, xml) }

  describe '#render' do
    let(:xml_as_string) do
      <<~XML
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
      XML
    end

    before do
      subject.render
      FileUtils.rm_f(output_pdf)
    end

    it 'renders xml to the pdf' do
      expect(File.exist?(output_pdf)).to be_falsey

      pdf.render_file output_pdf

      expect("#{base_dir}transp#render.pdf").to have_same_content_of file: output_pdf
    end

    context 'when modFrete is 0' do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
              <transp>
                <modFrete>0</modFrete>
              </transp>
            </infNFe>
          </NFe>
        XML
      end

      it "renders '0-Emitente' to the pdf" do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}transp#render-modfrete_0.pdf").to have_same_content_of file: output_pdf
      end
    end

    context 'when modFrete is 1' do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
              <transp>
                <modFrete>1</modFrete>
              </transp>
            </infNFe>
          </NFe>
        XML
      end

      it "renders '1-Destinatário' to the pdf" do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}transp#render-modfrete_1.pdf").to have_same_content_of file: output_pdf
      end
    end

    context 'when modFrete is 2' do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
              <transp>
                <modFrete>2</modFrete>
              </transp>
            </infNFe>
          </NFe>
        XML
      end

      it "renders '2-Terceiros' to the pdf" do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}transp#render-modfrete_2.pdf").to have_same_content_of file: output_pdf
      end
    end

    context 'when modFrete is 3' do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
              <transp>
                <modFrete>3</modFrete>
              </transp>
            </infNFe>
          </NFe>
        XML
      end

      it "renders '3-Prop/Rem' to the pdf" do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}transp#render-modfrete_3.pdf").to have_same_content_of file: output_pdf
      end
    end

    context 'when modFrete is 4' do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
              <transp>
                <modFrete>4</modFrete>
              </transp>
            </infNFe>
          </NFe>
        XML
      end

      it "renders '4-Prop/Dest' to the pdf" do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}transp#render-modfrete_4.pdf").to have_same_content_of file: output_pdf
      end
    end

    context 'when modFrete is 9' do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
              <transp>
                <modFrete>9</modFrete>
              </transp>
            </infNFe>
          </NFe>
        XML
      end

      it "renders '9-Sem Frete' to the pdf" do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}transp#render-modfrete_9.pdf").to have_same_content_of file: output_pdf
      end
    end

    describe 'with entrega' do
      let(:xml_as_string) do
        <<~XML
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
              <entrega>
                <CNPJ>82743287000880</CNPJ>
                <xNome>Schneider Electric Brasil Ltda</xNome>
                <xLgr>Av da Saudade</xLgr>
                <nro>1125</nro>
                <xBairro>Frutal</xBairro>
                <xCpl>Sala 01 e 02</xCpl>
                <cMun>3552403</cMun>
                <xMun>SUMARE</xMun>
                <UF>SP</UF>
                <CEP>13171320</CEP>
                <fone>1921046300</fone>
                <IE>671008375110</IE>
              </entrega>
            </infNFe>
          </NFe>
        XML
      end

      it 'renders xml to the pdf' do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}transp#render-with_entrega.pdf").to have_same_content_of file: output_pdf
      end
    end
  end
end
