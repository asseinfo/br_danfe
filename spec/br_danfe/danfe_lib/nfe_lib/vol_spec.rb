require 'spec_helper'

describe BrDanfe::DanfeLib::NfeLib::Vol do
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
              <vol>
                <qVol>1</qVol>
                <esp>VOLUMES 1</esp>
                <marca>DIVERSOS 1</marca>
                <nVol>1</nVol>
                <pesoL>1000.000</pesoL>
                <pesoB>1100.000</pesoB>
              </vol>
              <vol>
                <qVol>2</qVol>
                <esp>VOLUMES 2</esp>
                <marca>DIVERSOS 2</marca>
                <nVol>2</nVol>
                <pesoL>2000.000</pesoL>
                <pesoB>2200.000</pesoB>
              </vol>
              <vol>
                <qVol>3</qVol>
                <esp>VOLUMES 3</esp>
                <marca>DIVERSOS 3</marca>
                <nVol>3</nVol>
                <pesoL>3000.000</pesoL>
                <pesoB>3300.000</pesoB>
              </vol>
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

      expect("#{base_dir}vol#render.pdf").to have_same_content_of file: output_pdf
    end

    it 'returns the quantity of volumes' do
      expect(subject.render).to eq 3
    end

    context 'when any <vol> tag is found' do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
              <transp>
              </transp>
            </infNFe>
          </NFe>
        XML
      end

      it 'renders blank boxes' do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}vol#render-blank-boxes.pdf").to have_same_content_of file: output_pdf
      end
    end

    describe 'with entrega' do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
              <transp>
                <vol>
                  <qVol>1</qVol>
                  <esp>VOLUMES 1</esp>
                  <marca>DIVERSOS 1</marca>
                  <nVol>1</nVol>
                  <pesoL>1000.000</pesoL>
                  <pesoB>1100.000</pesoB>
                </vol>
                <vol>
                  <qVol>2</qVol>
                  <esp>VOLUMES 2</esp>
                  <marca>DIVERSOS 2</marca>
                  <nVol>2</nVol>
                  <pesoL>2000.000</pesoL>
                  <pesoB>2200.000</pesoB>
                </vol>
                <vol>
                  <qVol>3</qVol>
                  <esp>VOLUMES 3</esp>
                  <marca>DIVERSOS 3</marca>
                  <nVol>3</nVol>
                  <pesoL>3000.000</pesoL>
                  <pesoB>3300.000</pesoB>
                </vol>
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

        expect("#{base_dir}vol#render-with_entrega.pdf").to have_same_content_of file: output_pdf
      end
    end
  end
end
