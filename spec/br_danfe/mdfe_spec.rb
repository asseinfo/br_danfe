require 'spec_helper'

describe BrDanfe::Mdfe do
  let(:base_dir) { './spec/fixtures/mdfe/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:xml_as_string) do
    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <mdfeProc xmlns="http://www.portalfiscal.inf.br/mdfe" versao="3.00">
        <MDFe xmlns="http://www.portalfiscal.inf.br/mdfe">
          <infMDFe Id="MDFe32210717781119000141580010000001211000000003" versao="3.00">
            <ide>
              <cUF>32</cUF>
              <tpAmb>1</tpAmb>
              <tpEmit>2</tpEmit>
              <mod>58</mod>
              <serie>1</serie>
              <nMDF>121</nMDF>
              <cMDF>00000000</cMDF>
              <cDV>3</cDV>
              <modal>1</modal>
              <dhEmi>2021-07-01T17:30:00-03:00</dhEmi>
              <tpEmis>1</tpEmis>
              <procEmi>0</procEmi>
              <verProc>hivelog-mdfe-0.1.0</verProc>
              <UFIni>ES</UFIni>
              <UFFim>ES</UFFim>
              <infMunCarrega>
                <cMunCarrega>3205069</cMunCarrega>
                <xMunCarrega>VENDA NOVA DO IMIGRANTE</xMunCarrega>
              </infMunCarrega>
              <dhIniViagem>2021-07-01T17:30:00-03:00</dhIniViagem>
            </ide>
            <emit>
              <CNPJ>17781119000141</CNPJ>
              <IE>082942625</IE>
              <xNome>VENTURIM AGROCRIATIVA LTDA EPP</xNome>
              <xFant>VENTURIM CONSERVAS</xFant>
              <enderEmit>
                <xLgr>RODOVIA ES 473 KM 13</xLgr>
                <nro>0</nro>
                <xCpl>ZONA RURAL</xCpl>
                <xBairro>SAO JOAO DE VICOSA</xBairro>
                <cMun>3205069</cMun>
                <xMun>VENDA NOVA DO IMIGRANTE</xMun>
                <CEP>29375000</CEP>
                <UF>ES</UF>
                <fone>2835466272</fone>
                <email>VENTURIMCONSERVAS@GMAIL.COM</email>
              </enderEmit>
            </emit>
            <infModal versaoModal="3.00">
              <rodo>
                <infANTT/>
                <veicTracao>
                  <placa>RQM8B64</placa>
                  <RENAVAM>01259587867</RENAVAM>
                  <tara>0</tara>
                  <capKG>1500</capKG>
                  <capM3>0</capM3>
                  <condutor>
                    <xNome>EDUARDO DANIEL</xNome>
                    <CPF>11585756709</CPF>
                  </condutor>
                  <tpRod>04</tpRod>
                  <tpCar>02</tpCar>
                  <UF>ES</UF>
                </veicTracao>
                <veicReboque>
                  <placa>RVA1B90</placa>
                  <RENAVAM>123456789</RENAVAM>
                  <tara>0</tara>
                  <capKG>1500</capKG>
                  <capM3>0</capM3>
                  <condutor>
                    <xNome>JOAO DA SILVA</xNome>
                    <CPF>9876654312</CPF>
                  </condutor>
                  <tpRod>04</tpRod>
                  <tpCar>02</tpCar>
                  <UF>SC</UF>
                </veicReboque>
              </rodo>
            </infModal>
            <infDoc>
              <infMunDescarga>
                <cMunDescarga>3205069</cMunDescarga>
                <xMunDescarga>VENDA NOVA DO IMIGRANTE</xMunDescarga>
                <infNFe>
                  <chNFe>32210717781119000141550010000119601182910239</chNFe>
                </infNFe>
              </infMunDescarga>
              <infMunDescarga>
                <cMunDescarga>3201209</cMunDescarga>
                <xMunDescarga>CACHOEIRO DE ITAPEMIRIM</xMunDescarga>
                <infNFe>
                  <chNFe>32210717781119000141550010000119611182910236</chNFe>
                </infNFe>
                <infNFe>
                  <chNFe>32210717781119000141550010000119631182910230</chNFe>
                </infNFe>
                <infNFe>
                  <chNFe>32210717781119000141550010000119641182910238</chNFe>
                </infNFe>
                <infNFe>
                  <chNFe>32210717781119000141550010000119671182910230</chNFe>
                </infNFe>
                <infNFe>
                  <chNFe>32210717781119000141550010000119681182910237</chNFe>
                </infNFe>
              </infMunDescarga>
              <infMunDescarga>
                <cMunDescarga>3203403</cMunDescarga>
                <xMunDescarga>MIMOSO DO SUL</xMunDescarga>
                <infNFe>
                  <chNFe>32210717781119000141550010000119621182910233</chNFe>
                </infNFe>
              </infMunDescarga>
              <infMunDescarga>
                <cMunDescarga>3201407</cMunDescarga>
                <xMunDescarga>CASTELO</xMunDescarga>
                <infNFe>
                  <chNFe>32210717781119000141550010000119651182910235</chNFe>
                </infNFe>
                <infNFe>
                  <chNFe>32210717781119000141550010000119691182910234</chNFe>
                </infNFe>
              </infMunDescarga>
              <infMunDescarga>
                <cMunDescarga>3204302</cMunDescarga>
                <xMunDescarga>PRESIDENTE KENNEDY</xMunDescarga>
                <infNFe>
                  <chNFe>32210717781119000141550010000119701182910235</chNFe>
                </infNFe>
              </infMunDescarga>
            </infDoc>
            <tot>
              <qNFe>10</qNFe>
              <vCarga>8222.10</vCarga>
              <cUnid>01</cUnid>
              <qCarga>615.1400</qCarga>
            </tot>
            <autXML>
              <CNPJ>04898488000177</CNPJ>
            </autXML>
            <infAdic>
              <infAdFisco>Exemplo de observação para o Fisco</infAdFisco>
              <infCpl>Exemplo de observação para o Contribuinte</infCpl>
            </infAdic>
            <infRespTec>
              <CNPJ>07960929000101</CNPJ>
              <xContato>Hivelog Soluções em Tecnologia da Informação.</xContato>
              <email>desenvolvimento@hivecloud.com.br</email>
              <fone>8140628262</fone>
            </infRespTec>
          </infMDFe>
          <infMDFeSupl>
            <qrCodMDFe>https://dfe-portal.svrs.rs.gov.br/mdfe/QRCode?chMDFe=32210717781119000141580010000001211000000003&amp;tpAmb=1</qrCodMDFe>
          </infMDFeSupl>
          <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
            <SignedInfo>
              <CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>
              <SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>
              <Reference URI="#MDFe32210717781119000141580010000001211000000003">
                <Transforms>
                  <Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>
                  <Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>
                </Transforms>
                <DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/>
                <DigestValue>gLsHvKfPe3saxayj/JruXLmwRDM=</DigestValue>
              </Reference>
            </SignedInfo>
            <SignatureValue>pG5XoCc3nbhfVMk1G91ptTkX69nXGiKgL0NrhYRHfbnisS0KL9JP3/cKza+SxCiNCxGicP97cZoW
      /shglzGBnW81fhy9IeZ5H4KCTJbV0IEbc5Z2Orj2fX7+SBfX/E4OAw4puQk7TOAAFRrMsjXFnOjP
      DBpcM11i0XzixizrnBVL5JtmWDePx5PBCbjbeamCM+jNa5QjbNw8RKQGxZC5K4FnwmX8wW0HPujk
      0pYkbSRR7UIFjJSXnjgYbRyH/Ojm5wTGDv8JxzV4HN5XtIeggrJuh0enQIAEhMd/WW/0Ne5jj3VS
      X3LPy3cLWQPINdLfIAm7v1sQAtifgGcfINmsjw==</SignatureValue>
            <KeyInfo>
              <X509Data>
                <X509Certificate>MIIHUDCCBTigAwIBAgIIQXshAShT68AwDQYJKoZIhvcNAQELBQAwWTELMAkGA1UEBhMCQlIxEzAR
      BgNVBAoTCklDUC1CcmFzaWwxFTATBgNVBAsTDEFDIFNPTFVUSSB2NTEeMBwGA1UEAxMVQUMgU09M
      VVRJIE11bHRpcGxhIHY1MB4XDTIxMDEyOTE4MTgwMFoXDTIyMDEyOTE4MTgwMFowge8xCzAJBgNV
      BAYTAkJSMRMwEQYDVQQKEwpJQ1AtQnJhc2lsMQswCQYDVQQIEwJFUzEgMB4GA1UEBxMXVmVuZGEg
      Tm92YSBkbyBJbWlncmFudGUxHjAcBgNVBAsTFUFDIFNPTFVUSSBNdWx0aXBsYSB2NTEXMBUGA1UE
      CxMOMjkxMDgwOTEwMDAxNjUxEzARBgNVBAsTClByZXNlbmNpYWwxGjAYBgNVBAsTEUNlcnRpZmlj
      YWRvIFBKIEExMTIwMAYDVQQDEylWRU5UVVJJTSBBR1JPQ1JJQVRJVkEgTFREQToxNzc4MTExOTAw
      MDE0MTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMPI1XoIJEbr2Xi+4uVc6jLrTeKV
      jnho2f0f0Kx+z+n+kkcQx0BXdN/ZnR/BXtqgixoBOnnSUx1VIlNOsxaXHY0t77ZNax34US7elpjf
      P8FXlQuYYiI3C7mso7o29x17dFp0+D0888DCoOMGcItWQPwi/5/9W1m44CWgTrhOLZ2eY15Lk563
      V1LJ4g4FoPS/xx3mFVstBHX5emsuHSzmf9vMuvW1bCV4AqdNFCwadVjOYxYqWzM17q2zxyfQggTB
      goNjWFo32i6ko2oOiPWP3nPSNBoUWimp5hMPPCg02vgzWuFYk9BiKz1RxSkLDpKwC80wO+S827Ou
      0M3YvRmPZQ8CAwEAAaOCAoMwggJ/MAkGA1UdEwQCMAAwHwYDVR0jBBgwFoAUxVLtJYAJ35yCyJ9H
      xt20XzHdubEwVAYIKwYBBQUHAQEESDBGMEQGCCsGAQUFBzAChjhodHRwOi8vY2NkLmFjc29sdXRp
      LmNvbS5ici9sY3IvYWMtc29sdXRpLW11bHRpcGxhLXY1LnA3YjCBvgYDVR0RBIG2MIGzgRxjb25z
      ZXJ2YXN2ZW5kYW5vdmFAZ21haWwuY29toCUGBWBMAQMCoBwTGkxPUkVOWkEgRkFMQ0hFVFRPIFZF
      TlRVUklNoBkGBWBMAQMDoBATDjE3NzgxMTE5MDAwMTQxoDgGBWBMAQMEoC8TLTA2MDgxOTg5MTMw
      NDU1NjQ3NjMwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMKAXBgVgTAEDB6AOEwwwMDAwMDAwMDAw
      MDAwXQYDVR0gBFYwVDBSBgZgTAECASYwSDBGBggrBgEFBQcCARY6aHR0cDovL2NjZC5hY3NvbHV0
      aS5jb20uYnIvZG9jcy9kcGMtYWMtc29sdXRpLW11bHRpcGxhLnBkZjAdBgNVHSUEFjAUBggrBgEF
      BQcDAgYIKwYBBQUHAwQwgYwGA1UdHwSBhDCBgTA+oDygOoY4aHR0cDovL2NjZC5hY3NvbHV0aS5j
      b20uYnIvbGNyL2FjLXNvbHV0aS1tdWx0aXBsYS12NS5jcmwwP6A9oDuGOWh0dHA6Ly9jY2QyLmFj
      c29sdXRpLmNvbS5ici9sY3IvYWMtc29sdXRpLW11bHRpcGxhLXY1LmNybDAdBgNVHQ4EFgQUrp4N
      Lavrr3l4CWS5uA1vCEdazF4wDgYDVR0PAQH/BAQDAgXgMA0GCSqGSIb3DQEBCwUAA4ICAQCNZY0z
      sIgFoFvqh41wabo9CVzwYtftczCCTo3xuk3NSx7MHOpd+mhN9Y+HWJCdcXLaLk4+ds3PhX9ZwOzD
      K8DXPiI//tcYgf+aEhJxfZKIGkrOUVNNCtD1986Ih09pWLdkkmfISYE6Jypm7UyuV0P7F9N9DweT
      9Qp5n3K1GobCIcEdBiSppIabTWTHEmjI8hpf9CE8djYACwI/Dh686t1DL33kfiw+0vHS6fDIttP6
      XRpOXoBClF1y+lP91YCV/+p767jfKjdD6glRuSNrF8zxjO6b52YlwO0mm6wqChBkUuBxoCybxdE0
      2bDjAybOdAcVihnUTu7DibIQQJu18bF9f/XYbmOHvxUErSAvyW72/ZRolzr21z2RS0vrqse2RtpL
      +pkfnowU3PA6SJpHjkd6Qc887E7jveKwHdq3tCqk4XCfl7sKa1rF/h7dSZpJ/m/gSMZy00jtX5TU
      dTxXcYSrLfpWtJAvFMePQZ3BNADHT/hd5SOanS1gN9qf213iQVMu9+wHCRg24UoZJmhXHsHrx2h7
      AEy5mOweDLL3VsO9NdWmce58VjOrvMsP3MlE8WSSEcLbm7XerYtOgTDYHYhVPo7xNvKpI0jsiGH9
      mGq0jwS+S+/STyaaAVQ0UOZQ9/MzDIwo9GRuTlZCTyh99KtSej3BF3oPfBajnY32Oc71WA==</X509Certificate>
              </X509Data>
            </KeyInfo>
          </Signature>
        </MDFe>
        <protMDFe versao="3.00" xmlns="http://www.portalfiscal.inf.br/mdfe">
          <infProt Id="MDFe932210002534081">
            <tpAmb>1</tpAmb>
            <verAplic>RS20210607092041</verAplic>
            <chMDFe>32210717781119000141580010000001211000000003</chMDFe>
            <dhRecbto>2021-07-01T17:39:16-03:00</dhRecbto>
            <nProt>932210002534081</nProt>
            <digVal>gLsHvKfPe3saxayj/JruXLmwRDM=</digVal>
            <cStat>100</cStat>
            <xMotivo>Autorizado o uso do MDF-e</xMotivo>
          </infProt>
        </protMDFe>
      </mdfeProc>
    XML
  end

  let(:xml) { BrDanfe::XML.new(xml_as_string) }

  subject { described_class.new(xml) }
  # after { File.delete(output_pdf) if File.exist?(output_pdf) }

  before do
    subject.logo_options.logo_dimensions = { width: 100, height: 100 }
    subject.logo_options.logo = 'spec/fixtures/logo.png'
  end

  describe '#render_pdf' do
    it 'renders the mdfe' do
      expected = IO.binread("#{base_dir}mdfe.fixture.pdf")

      expect(subject.render_pdf).to eq expected
    end
  end

  describe '#save_pdf' do
    fit 'saves the mdfe' do
      # expect(File.exist?(output_pdf)).to be false

      subject.save_pdf output_pdf
      expect("#{base_dir}mdfe.fixture.pdf").to have_same_content_of file: output_pdf
    end
  end

  context 'when MDF-e has multiple pages' do
    let(:xml_as_string) do
      <<~XML
        <?xml version="1.0" encoding="UTF-8"?>
        <mdfeProc xmlns="http://www.portalfiscal.inf.br/mdfe" versao="3.00">
          <MDFe xmlns="http://www.portalfiscal.inf.br/mdfe">
            <infMDFe Id="MDFe32210717781119000141580010000001211000000003" versao="3.00">
              <ide>
                <mod>58</mod>
                <serie>1</serie>
                <nMDF>121</nMDF>
                <cMDF>00000000</cMDF>
                <modal>1</modal>
                <dhEmi>2021-07-01T17:30:00-03:00</dhEmi>
                <UFIni>ES</UFIni>
                <UFFim>ES</UFFim>
              </ide>
              <emit>
                <CNPJ>17781119000141</CNPJ>
                <IE>082942625</IE>
                <xNome>VENTURIM AGROCRIATIVA LTDA EPP</xNome>
                <xFant>VENTURIM CONSERVAS</xFant>
                <enderEmit>
                  <xLgr>RODOVIA ES 473 KM 13</xLgr>
                  <nro>0</nro>
                  <xMun>VENDA NOVA DO IMIGRANTE</xMun>
                  <CEP>29375000</CEP>
                  <UF>ES</UF>
                </enderEmit>
              </emit>
              <infModal versaoModal="3.00">
                <rodo>
                  <infANTT/>
                  <veicTracao>
                    <placa>RQM8B64</placa>
                    <RENAVAM>01259587867</RENAVAM>
                    <condutor>
                      <xNome>EDUARDO DANIEL</xNome>
                      <CPF>11585756709</CPF>
                    </condutor>
                  </veicTracao>
                  <veicReboque>
                    <placa>RVA1B90</placa>
                    <RENAVAM>123456789</RENAVAM>
                    <condutor>
                      <xNome>JOAO DA SILVA</xNome>
                      <CPF>9876654312</CPF>
                    </condutor>
                  </veicReboque>
                  <veicReboque>
                    <placa>DFE4U78</placa>
                    <RENAVAM>045784572</RENAVAM>
                    <condutor>
                      <xNome>PEDRO DE SOUZA</xNome>
                      <CPF>9876654312</CPF>
                    </condutor>
                  </veicReboque>
                  <veicReboque>
                    <placa>OPS4F78</placa>
                    <RENAVAM>045784572</RENAVAM>
                    <condutor>
                      <xNome>GABRIEL DE JESUS</xNome>
                      <CPF>9876654312</CPF>
                    </condutor>
                  </veicReboque>
                </rodo>
              </infModal>
              <tot>
                <qNFe>10</qNFe>
                <vCarga>8222.10</vCarga>
                <cUnid>01</cUnid>
                <qCarga>615.1400</qCarga>
              </tot>
              <autXML>
                <CNPJ>04898488000177</CNPJ>
              </autXML>
              <infAdic>
                <infAdFisco>Exemplo de observação para o Fisco#{'alguma coisa ' * 153}</infAdFisco>
                <infCpl>Exemplo de observação para o Contribuinte#{'alguma coisa ' * 2000}</infCpl>
              </infAdic>
            </infMDFe>
            <infMDFeSupl>
              <qrCodMDFe>https://dfe-portal.svrs.rs.gov.br/mdfe/QRCode?chMDFe=32210717781119000141580010000001211000000003&amp;tpAmb=1</qrCodMDFe>
            </infMDFeSupl>
          </MDFe>
          <protMDFe versao="3.00" xmlns="http://www.portalfiscal.inf.br/mdfe">
            <infProt Id="MDFe932210002534081">
              <tpAmb>1</tpAmb>
              <verAplic>RS20210607092041</verAplic>
              <chMDFe>32210717781119000141580010000001211000000003</chMDFe>
              <dhRecbto>2021-07-01T17:39:16-03:00</dhRecbto>
              <nProt>932210002534081</nProt>
              <digVal>gLsHvKfPe3saxayj/JruXLmwRDM=</digVal>
              <cStat>100</cStat>
              <xMotivo>Autorizado o uso do MDF-e</xMotivo>
            </infProt>
          </protMDFe>
        </mdfeProc>
      XML
    end

    it 'renders the header and the identification on each page' do
      expect(File.exist?(output_pdf)).to be false

      subject.save_pdf output_pdf
      expect("#{base_dir}mdfe-with-multiple-pages.pdf").to have_same_content_of file: output_pdf
    end
  end
end
