require 'spec_helper'

describe BrDanfe::MdfeLib::Drivers do
  let(:xml_as_string) do
    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <mdfeProc xmlns="http://www.portalfiscal.inf.br/mdfe" versao="3.00">
        <MDFe xmlns="http://www.portalfiscal.inf.br/mdfe">
          <infMDFe Id="MDFe32210717781119000141580010000001211000000003" versao="3.00">
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
                <veicReboque>
                  <placa>DFE4U78</placa>
                  <RENAVAM>045784572</RENAVAM>
                  <tara>0</tara>
                  <capKG>1500</capKG>
                  <capM3>0</capM3>
                  <condutor>
                    <xNome>ANTÔNIO DA SILVA</xNome>
                    <CPF>9856478238</CPF>
                  </condutor>
                  <tpRod>04</tpRod>
                  <tpCar>02</tpCar>
                  <UF>SC</UF>
                </veicReboque>
              </rodo>
            </infModal>
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

  describe '#generate' do
    it 'generates the title' do
      title = 'Condutor'

      subject.generate
      expect(pdf_text).to include title
    end

    it 'generates the title of table' do
      cpf = 'CPF'
      name = 'Nome'

      subject.generate
      expect(pdf_text).to include cpf, name
    end
  end
end
