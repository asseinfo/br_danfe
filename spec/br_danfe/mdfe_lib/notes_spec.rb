require 'spec_helper'

describe BrDanfe::MdfeLib::Notes do
  let(:xml_as_string) do
    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <mdfeProc xmlns="http://www.portalfiscal.inf.br/mdfe" versao="3.00">
      	<MDFe xmlns="http://www.portalfiscal.inf.br/mdfe">
      		<infMDFe Id="MDFe32210717781119000141580010000001211000000003" versao="3.00">
            <infAdic>
              <infAdFisco>EXEMPLO INFORMAÇÕES ADICIONAIS FISCO</infAdFisco>
              <infCpl>EXEMPLO INFORMAÇÕES ADICIONAIS CONTRIBUINTE</infCpl>
            </infAdic>
      		</infMDFe>
      	</MDFe>
      </mdfeProc>
    XML
  end

  let(:xml_without_note_as_string) do
    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <mdfeProc xmlns="http://www.portalfiscal.inf.br/mdfe" versao="3.00">
      	<MDFe xmlns="http://www.portalfiscal.inf.br/mdfe">
      		<infMDFe Id="MDFe32210717781119000141580010000001211000000003" versao="3.00">
            <infAdic>
              <infAdFisco>EXEMPLO INFORMAÇÕES ADICIONAIS FISCO</infAdFisco>
              <infCpl>EXEMPLO INFORMAÇÕES ADICIONAIS CONTRIBUINTE</infCpl>
            </infAdic>
      		</infMDFe>
      	</MDFe>
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
    it 'renders the title' do
      title = 'Observações'

      subject.render
      expect(pdf_text).to include title
    end

    it 'renders the aditional information for fisco when xml has infAdFisco tag' do
      fisco_information = "Informações adicionais de interesse do Fisco:\nEXEMPLO INFORMAÇÕES ADICIONAIS FISCO"

      subject.render
      expect(pdf_text).to include fisco_information
    end

    it 'does not render the aditional information for fisco when xml does not have infAdFisco tag' do
      fisco_information = "Informações adicionais de interesse do Fisco:\n"

      xml = BrDanfe::XML.new(xml_without_note_as_string)
      subject = described_class.new(pdf, xml)
      subject.render
      expect(pdf_text).not_to include fisco_information
    end

    it 'renders the aditional information for taxpayer when xml has infCpl tag' do
      taxpayer_information = "Informações adicionais de interesse do Contribuinte:\nEXEMPLO INFORMAÇÕES ADICIONAIS CONTRIBUINTE"

      subject.render
      expect(pdf_text).to include taxpayer_information
    end

    it 'does not render the aditional information for taxpayer when xml does not have infCpl tag' do
      taxpayer_information = "Informações adicionais de interesse do Contribuinte:\n"

      xml = BrDanfe::XML.new(xml_without_note_as_string)
      subject = described_class.new(pdf, xml)
      subject.render
      expect(pdf_text).not_to include taxpayer_information
    end
  end
end
