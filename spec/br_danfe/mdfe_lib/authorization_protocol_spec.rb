require 'spec_helper'

describe BrDanfe::MdfeLib::AuthorizationProtocol do
  let(:xml_as_string) do
    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <mdfeProc xmlns="http://www.portalfiscal.inf.br/mdfe" versao="3.00">
        <protMDFe versao="3.00" xmlns="http://www.portalfiscal.inf.br/mdfe">
          <infProt Id="MDFe932210002534081">
            <dhRecbto>2021-07-01T17:39:16-03:00</dhRecbto>
            <nProt>932210002534081</nProt>
          </infProt>
        </protMDFe>
      </mdfeProc>
    XML
  end

  let(:pdf) { BrDanfe::MdfeLib::Document.new }
  let(:xml) { BrDanfe::XML.new(xml_as_string) }

  subject { described_class.new(pdf, xml) }

  let(:pdf_text) do
    PDF::Inspector::Text.analyze(pdf.render).strings.join("\n")
  end

  describe '#render' do
    it 'renders the authorization protocol' do
      authorization_protocol = "Protocolo de autorização\n932210002534081 - 01/07/2021 17:39:16-03:00"

      subject.render
      expect(pdf_text).to include authorization_protocol
    end
  end
end
