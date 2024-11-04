require 'spec_helper'

describe BrDanfe::DanfeLib::NfeLib::Entrega do
  let(:path_of_expected_pdf) { './spec/fixtures/nfe/lib/output.pdf' }

  let(:pdf) { BrDanfe::DanfeLib::NfeLib::Document.new }
  let(:xml) { BrDanfe::XML.new(xml_as_string) }

  subject { described_class.new(pdf, xml) }

  describe '#render' do
    before do
      subject.render
      File.delete(path_of_expected_pdf) if File.exist?(path_of_expected_pdf)
    end

    context "when nf-e's version is 2.00" do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
              <ide>
                <dEmi>2011-10-29</dEmi>
                <dSaiEnt>2011-10-30</dSaiEnt>
                <hSaiEnt>15:32:45</hSaiEnt>
              </ide>
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
        expect(File.exist?(path_of_expected_pdf)).to be false

        pdf.render_file path_of_expected_pdf

        expect('./spec/fixtures/nfe/lib/entrega#render-v2.00.pdf').to have_same_content_of file: path_of_expected_pdf
      end
    end

    context 'when recipient address (xLgr + nro + xCpl) has more than 63 characters' do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="3.10">
              <ide>
                <dhEmi>2018-07-30T13:30:59+00:00</dhEmi>
                <dhSaiEnt>2018-07-30T14:32:45-03:00</dhSaiEnt>
              </ide>
              <entrega>
                <CNPJ>82743287000880</CNPJ>
                <xNome>Schneider Electric Brasil Ltda</xNome>
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
                <IE>671008375110</IE>
              </entrega>
            </infNFe>
          </NFe>
        XML
      end

      it 'renders xml to pdf discarding the address of after 63 characters' do
        expect(File.exist?(path_of_expected_pdf)).to be false

        pdf.render_file path_of_expected_pdf

        expect('./spec/fixtures/nfe/lib/entrega#render-with-address-bigger.pdf')
          .to have_same_content_of file: path_of_expected_pdf
      end
    end
  end

  describe '.delivery_local' do
    context 'when entrega/xLgr is present in the XML' do
      let(:xml_with_address) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="3.10">
              <dest>
                <idEstrangeiro>123456789</idEstrangeiro>
                <xNome>John Doe</xNome>
                <enderDest>
                  <xLgr>Av. Bayer Filho</xLgr>
                  <nro>1999</nro>
                  <xBairro>Centro</xBairro>
                  <xMun>Tijucas</xMun>
                  <UF>SC</UF>
                </enderDest>
              </dest>
              <entrega>
                <CNPJ>82743287000880</CNPJ>
                <xNome>Schneider Electric Brasil Ltda</xNome>
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
                <IE>671008375110</IE>
              </entrega>
            </infNFe>
          </NFe>
        XML
      end

      it 'returns true' do
        expect(described_class.delivery_local?(xml_with_address)).to be true
      end
    end

    context 'when entrega/xLgr is not present in the XML' do
      let(:xml_without_entrega) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="3.10">
            </infNFe>
          </NFe>
        XML
      end

      it 'returns false' do
        expect(described_class.delivery_local?(xml_without_entrega)).to be false
      end
    end
  end
end
