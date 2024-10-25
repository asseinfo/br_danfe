require 'spec_helper'

describe BrDanfe::DanfeLib::NfeLib::Delivery do
  let(:base_dir) { './spec/fixtures/nfe/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:pdf) { BrDanfe::DanfeLib::NfeLib::Document.new }
  let(:xml) { BrDanfe::XML.new(xml_as_string) }

  subject { described_class.new(pdf, xml) }

  describe '#render' do
    context "when nf-e's version is 2.00" do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
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

      before do
        subject.render
        File.delete(output_pdf) if File.exist?(output_pdf)
      end

      fit 'renders xml to the pdf' do
        expect(File.exist?(output_pdf)).to be false

        pdf.render_file output_pdf

        expect('./spec/fixtures/nfe/lib/entrega#render-v2.00.pdf').to have_same_content_of file: output_pdf
      end
    end

    context 'when recipient has CNPJ' do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="3.10">
              <entrega>
                <CNPJ>71058884000183</CNPJ>
              </entrega>
            </infNFe>
          </NFe>
        XML
      end

      it 'renders xml to the pdf' do
        expect(File.exist?(path_of_expected_pdf)).to be false

        pdf.render_file path_of_expected_pdf

        expect('./spec/fixtures/nfe/lib/dest#render-with_cnpj.pdf').to have_same_content_of file: path_of_expected_pdf
      end
    end

    context 'when recipient has CPF' do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="3.10">
              <entrega>
                <CPF>48532557457</CPF>
              </entrega>
            </infNFe>
          </NFe>
        XML
      end

      it 'renders xml to the pdf' do
        expect(File.exist?(path_of_expected_pdf)).to be false

        pdf.render_file path_of_expected_pdf

        expect('./spec/fixtures/nfe/lib/dest#render-with_cpf.pdf').to have_same_content_of file: path_of_expected_pdf
      end
    end

    context 'when recipient has IE' do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="3.10">
              <entrega>
                <entrega>
                  <UF>SP</UF>
                </entrega>
                <IE>671008375110</IE>
              </entrega>
            </infNFe>
          </NFe>
        XML
      end

      it 'renders xml to the pdf' do
        expect(File.exist?(path_of_expected_pdf)).to be false

        pdf.render_file path_of_expected_pdf

        expect('./spec/fixtures/nfe/lib/dest#render-with_ie.pdf').to have_same_content_of file: path_of_expected_pdf
      end
    end

    context "when recipient doesn't have address complement" do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="3.10">
              <ide>
                <dhEmi>2011-09-29T13:02:59+00:00</dhEmi>
                <dhSaiEnt>2011-09-30T12:32:45-03:00</dhSaiEnt>
              </ide>
              <entrega>
                <CNPJ>82743287000880</CNPJ>
                <xNome>Schneider Electric Brasil Ltda</xNome>
                <entrega>
                  <xLgr>Av da Saudade</xLgr>
                  <nro>1125</nro>
                  <xBairro>Frutal</xBairro>
                  <cMun>3552403</cMun>
                  <xMun>SUMARE</xMun>
                  <UF>SP</UF>
                  <CEP>13171320</CEP>
                  <cPais>1058</cPais>
                  <xPais>BRASIL</xPais>
                  <fone>1921046300</fone>
                </entrega>
                <IE>671008375110</IE>
              </entrega>
            </infNFe>
          </NFe>
        XML
      end

      it 'renders xml to the pdf' do
        expect(File.exist?(path_of_expected_pdf)).to be false

        pdf.render_file path_of_expected_pdf

        expect('./spec/fixtures/nfe/lib/dest#render-without-address-complement.pdf')
          .to have_same_content_of file: path_of_expected_pdf
      end
    end

    context 'when recipient address (xLgr + nro + xCpl) has more than 63 characters' do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="3.10">
              <ide>
                <dhEmi>2011-09-29T13:02:59+00:00</dhEmi>
                <dhSaiEnt>2011-09-30T12:32:45-03:00</dhSaiEnt>
              </ide>
              <entrega>
                <CNPJ>82743287000880</CNPJ>
                <xNome>Schneider Electric Brasil Ltda</xNome>
                <entrega>
                  <xLgr>Rua do governo do estado</xLgr>
                  <nro>1125</nro>
                  <xCpl>Em anexo ao super mercado maior do bairro</xCpl>
                  <xBairro>Frutal</xBairro>
                  <cMun>3552403</cMun>
                  <xMun>SUMARE</xMun>
                  <UF>SP</UF>
                  <CEP>13171320</CEP>
                  <cPais>1058</cPais>
                  <xPais>BRASIL</xPais>
                  <fone>1921046300</fone>
                </entrega>
                <IE>671008375110</IE>
              </entrega>
            </infNFe>
          </NFe>
        XML
      end

      it 'renders xml to pdf discarding the address of after 63 characters' do
        expect(File.exist?(path_of_expected_pdf)).to be false

        pdf.render_file path_of_expected_pdf

        expect('./spec/fixtures/nfe/lib/dest#render-with-address-bigger.pdf')
          .to have_same_content_of file: path_of_expected_pdf
      end
    end
  end
end
