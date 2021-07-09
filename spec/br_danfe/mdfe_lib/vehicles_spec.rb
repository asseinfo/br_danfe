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

  let(:pdf_text) do
    PDF::Inspector::Text.analyze(pdf.render).strings.join("\n")
  end

  describe '#render' do
    it 'renders the title' do
      title = 'Veículo'

      subject.render
      expect(pdf_text).to include title
    end

    it 'renders the title of table' do
      plate = 'Placa'
      rntrc = 'RNTR'

      subject.render
      expect(pdf_text).to include plate, rntrc
    end

    it 'renders the list of vehicles' do
      vehicle1_plate = 'RQM8B64'
      vehicle1_rntrc = '01259587867'
      vehicle2_plate = 'RVA1B90'
      vehicle2_rntrc = '123456789'

      subject.render
      expect(pdf_text).to include vehicle1_plate, vehicle1_rntrc, vehicle2_plate, vehicle2_rntrc
    end

    xit 'renders the vehicle plate' do
      plate = "Placa\nRQM8B64"

      subject.render
      expect(pdf_text).to include plate
    end
  end
end
