require 'spec_helper'

describe BrDanfe::MdfeLib::Vehicles do
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
                </veicTracao>
                <veicReboque>
                  <placa>RVA1B90</placa>
                </veicReboque>
                <veicReboque>
                  <placa>MCU9123</placa>
                </veicReboque>
                <veicReboque>
                  <placa>QIU1239</placa>
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

  let(:pdf_text) { PDF::Inspector::Text.analyze(pdf.render).strings.join("\n") }

  describe '#generate' do
    it 'generates the title' do
      title = 'Veículo'

      subject.generate
      expect(pdf_text).to include title
    end

    it 'generates the title of table' do
      plate = 'Placa'
      rntrc = 'RNTR'

      subject.generate
      expect(pdf_text).to include plate, rntrc
    end

    it 'generates the list of vehicles' do
      vehicle1_plate = 'RQM8B64'
      vehicle2_plate = 'RVA1B90'
      vehicle3_plate = 'MCU9123'
      vehicle4_plate = 'QIU1239'

      subject.generate
      expect(pdf_text).to include vehicle1_plate, vehicle2_plate, vehicle3_plate, vehicle4_plate
    end
  end
end
