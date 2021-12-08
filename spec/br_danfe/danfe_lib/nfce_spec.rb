require 'spec_helper'

describe BrDanfe::DanfeLib::Nfce do
  let(:output_pdf) { "#{base_dir}output.pdf" }
  let(:base_dir) { './spec/fixtures/nfce/v4.00/' }
  # let(:xml) { BrDanfe::XML.new(File.read("#{base_dir}nfce.xml")) }

  let(:xml_string) do
    <<~XML
      <nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00">
      <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
        <infNFe versao="4.00" Id="NFe42211232855114000100650010000001221182910236">
          <ide>
            <cUF>42</cUF>
            <cNF>18291023</cNF>
            <natOp>Venda</natOp>
            <mod>65</mod>
            <serie>1</serie>
            <nNF>122</nNF>
            <dhEmi>2021-12-07T21:23:23-03:00</dhEmi>
            <tpNF>1</tpNF>
            <idDest>1</idDest>
            <cMunFG>4218004</cMunFG>
            <tpImp>4</tpImp>
            <tpEmis>1</tpEmis>
            <cDV>6</cDV>
            <tpAmb>1</tpAmb>
            <finNFe>1</finNFe>
            <indFinal>1</indFinal>
            <indPres>1</indPres>
            <procEmi>0</procEmi>
            <verProc>facil123.com.br</verProc>
          </ide>
          <emit>
            <CNPJ>32855114000100</CNPJ>
            <xNome>DISTRITO 92 RESTAURANTE E BAR LTDAAAAAAAAAAAAAAAAS ASDAKLSDJALKSDASDAA</xNome>
            <xFant>DISTRITO 92</xFant>
            <enderEmit>
              <xLgr>Avenida Bayer Filho</xLgr>
              <nro>958</nro>
              <xBairro>Centro</xBairro>
              <cMun>4218004</cMun>
              <xMun>TIJUCAS</xMun>
              <UF>SC</UF>
              <CEP>88200000</CEP>
              <cPais>1058</cPais>
              <xPais>Brasil</xPais>
              <fone>4832630362</fone>
            </enderEmit>
            <IE>260975753</IE>
            <CRT>1</CRT>
          </emit>
          <autXML>
            <CNPJ>17733183000157</CNPJ>
          </autXML>
          <det nItem="1">
            <prod>
              <cProd>52</cProd>
              <cEAN>SEM GTIN</cEAN>
              <xProd>Suco de Laranja</xProd>
              <NCM>21069090</NCM>
              <CFOP>5102</CFOP>
              <uCom>UN</uCom>
              <qCom>1.0</qCom>
              <vUnCom>8.0</vUnCom>
              <vProd>8.00</vProd>
              <cEANTrib>SEM GTIN</cEANTrib>
              <uTrib>UN</uTrib>
              <qTrib>1.0</qTrib>
              <vUnTrib>8.0</vUnTrib>
              <indTot>1</indTot>
            </prod>
            <imposto>
              <ICMS>
                <ICMSSN102>
                  <orig>0</orig>
                  <CSOSN>102</CSOSN>
                </ICMSSN102>
              </ICMS>
              <PIS>
                <PISOutr>
                  <CST>99</CST>
                  <vBC>0.00</vBC>
                  <pPIS>0.00</pPIS>
                  <vPIS>0.00</vPIS>
                </PISOutr>
              </PIS>
              <COFINS>
                <COFINSOutr>
                  <CST>99</CST>
                  <vBC>0.00</vBC>
                  <pCOFINS>0.00</pCOFINS>
                  <vCOFINS>0.00</vCOFINS>
                </COFINSOutr>
              </COFINS>
            </imposto>
          </det>
          <det nItem="2">
            <prod>
              <cProd>32</cProd>
              <cEAN>SEM GTIN</cEAN>
              <xProd>Burger Duplo</xProd>
              <NCM>21069090</NCM>
              <CFOP>5102</CFOP>
              <uCom>UN</uCom>
              <qCom>1.0</qCom>
              <vUnCom>35.0</vUnCom>
              <vProd>35.00</vProd>
              <cEANTrib>SEM GTIN</cEANTrib>
              <uTrib>UN</uTrib>
              <qTrib>1.0</qTrib>
              <vUnTrib>35.0</vUnTrib>
              <indTot>1</indTot>
            </prod>
            <imposto>
              <ICMS>
                <ICMSSN102>
                  <orig>0</orig>
                  <CSOSN>102</CSOSN>
                </ICMSSN102>
              </ICMS>
              <PIS>
                <PISOutr>
                  <CST>99</CST>
                  <vBC>0.00</vBC>
                  <pPIS>0.00</pPIS>
                  <vPIS>0.00</vPIS>
                </PISOutr>
              </PIS>
              <COFINS>
                <COFINSOutr>
                  <CST>99</CST>
                  <vBC>0.00</vBC>
                  <pCOFINS>0.00</pCOFINS>
                  <vCOFINS>0.00</vCOFINS>
                </COFINSOutr>
              </COFINS>
            </imposto>
          </det>
          <total>
            <ICMSTot>
              <vBC>0.00</vBC>
              <vICMS>0.00</vICMS>
              <vICMSDeson>0.00</vICMSDeson>
              <vFCPUFDest>0.00</vFCPUFDest>
              <vICMSUFDest>0.00</vICMSUFDest>
              <vICMSUFRemet>0.00</vICMSUFRemet>
              <vFCP>0.00</vFCP>
              <vBCST>0.00</vBCST>
              <vST>0.00</vST>
              <vFCPST>0.00</vFCPST>
              <vFCPSTRet>0.00</vFCPSTRet>
              <vProd>43.00</vProd>
              <vFrete>0.00</vFrete>
              <vSeg>0.00</vSeg>
              <vDesc>0.00</vDesc>
              <vII>0.00</vII>
              <vIPI>0.00</vIPI>
              <vIPIDevol>0.00</vIPIDevol>
              <vPIS>0.00</vPIS>
              <vCOFINS>0.00</vCOFINS>
              <vOutro>0.00</vOutro>
              <vNF>43.00</vNF>
            </ICMSTot>
          </total>
          <transp>
            <modFrete>9</modFrete>
          </transp>
          <pag>
            <detPag>
              <indPag>1</indPag>
              <tPag>03</tPag>
              <vPag>43.00</vPag>
            </detPag>
          </pag>
          <infAdic>
            <infCpl>DOCUMENTO EMITIDO POR ME OU EPP OPTANTE PELO SIMPLES NACIONAL * NÃO GERA DIREITO A CRÉDITO FISCAL DE IPI</infCpl>
          </infAdic>
          <infRespTec>
            <CNPJ>04267593000108</CNPJ>
            <xContato>César Luiz dos Anjos Júnior</xContato>
            <email>desenvolvedores@asseinfo.com.br</email>
            <fone>4832637137</fone>
          </infRespTec>
        </infNFe>
        <infNFeSupl>
          <qrCode>https://sat.sef.sc.gov.br/nfce/consulta?p=42211232855114000100650010000001221182910236|2|1|1|406D810A8056D7F2623FE4DE2F6A8AEFD5C574F6</qrCode>
          <urlChave>https://sat.sef.sc.gov.br/nfce/consulta</urlChave>
        </infNFeSupl>
        <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
          <SignedInfo>
            <CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />
            <SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" />
            <Reference URI="#NFe42211232855114000100650010000001221182910236">
              <Transforms>
                <Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />
                <Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />
              </Transforms>
              <DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" />
              <DigestValue>pgtizRrM414Uy8BSEKurL/EJWnM=</DigestValue>
            </Reference>
          </SignedInfo>
          <SignatureValue>Wm58xWvsBsU0eTIo3VisZ6FnKu0H7+hq6coCS9linPwuykCoRlp+ogvkOzim
    Xx4KvMYw+4ZBqYzOXtAwP1/3BtNF471CH3KuD+GDC+J/XwGCFEVyKT7pNJiE
    mRCTwlGmNUe4urJJ2VIfPQnXAwk3oLjbQUVrsyEkQq+IgXfEmBuD/OyV4+H2
    JNAh4aAO405oN2H5m+BrFMpPeeo+TceqO9Ua131+cuIEt7sxEQ+gWXVn9AMx
    fS6EaFvZm1GqUQTwoq8+mvNXU7DUVAfRB6sLIsLV7faDMNLmaZUrk3QaEd02
    s6JybiyAwxAWsIXLkcVjp3PgZ7S3LKyRwP+r76diGw==</SignatureValue>
          <KeyInfo>
            <X509Data>
              <X509Certificate>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</X509Certificate>
            </X509Data>
          </KeyInfo>
        </Signature>
      </NFe>
      <protNFe versao="4.00">
        <infProt>
          <tpAmb>1</tpAmb>
          <verAplic>SVRSnfce202111190951</verAplic>
          <chNFe>42211232855114000100650010000001221182910236</chNFe>
          <dhRecbto>2021-12-07T21:23:26-03:00</dhRecbto>
          <nProt>342210042308836</nProt>
          <digVal>pgtizRrM414Uy8BSEKurL/EJWnM=</digVal>
          <cStat>100</cStat>
          <xMotivo>Autorizado o uso da NF-e</xMotivo>
        </infProt>
      </protNFe>
    </nfeProc>
    XML
    
  end

  let(:xml) { BrDanfe::XML.new(xml_string) }

  subject { described_class.new [xml] }

  before do
    subject.options.logo = 'spec/fixtures/logo.png'
    subject.options.logo_dimensions = { width: 100, height: 100 }
  end

  describe '#render_pdf' do
    it 'renders the NFC-e pdf' do
      expected = IO.binread("#{base_dir}rendered_nfce.fixture.pdf")
      expect(subject.render_pdf).to eq expected
    end
  end

  describe '#save_pdf' do
    before { File.delete(output_pdf) if File.exist?(output_pdf) }
    # after { File.delete(output_pdf) if File.exist?(output_pdf) }

    fit 'saves the NFC-e as pdf' do
      expect(File.exist?(output_pdf)).to be_falsey
      subject.save_pdf output_pdf

      expect("#{base_dir}saved_nfce.fixture.pdf").to have_same_content_of file: output_pdf
    end

    context 'when nfc-e is unauthorized' do
      context 'when nfc-e is in homologation environment' do
        let(:xml) { BrDanfe::XML.new(File.read("#{base_dir}nfce-unauthorized-hom.xml")) }

        it 'render watermark at pdf' do
          expect(File.exist?(output_pdf)).to be_falsey
          subject.save_pdf output_pdf

          expect("#{base_dir}nfce-unauthorized-hom.fixture.pdf").to have_same_content_of file: output_pdf
        end
      end

      context 'when nfc-e is in production environment' do
        let(:xml) { BrDanfe::XML.new(File.read("#{base_dir}nfce-unauthorized-prod.xml")) }

        it 'render watermark at pdf' do
          expect(File.exist?(output_pdf)).to be_falsey
          subject.save_pdf output_pdf

          expect("#{base_dir}nfce-unauthorized-prod.fixture.pdf").to have_same_content_of file: output_pdf
        end
      end
    end

    context 'when there is more than one xml' do
      it 'renders multiple danfes on the same pdf' do
        subject = described_class.new [xml, xml]

        expect(File.exist?(output_pdf)).to be_falsey
        subject.save_pdf output_pdf

        expect("#{base_dir}multiples_xmls_on_the_same_pdf.pdf").to have_same_content_of file: output_pdf
      end
    end
  end
end
