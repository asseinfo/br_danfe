require 'spec_helper'

describe BrDanfe::MdfeLib::Totalizer do
  let(:xml_as_string) do
    <<-eos
      <?xml version="1.0" encoding="UTF-8"?>
      <mdfeProc xmlns="http://www.portalfiscal.inf.br/mdfe" versao="3.00">
      	<MDFe xmlns="http://www.portalfiscal.inf.br/mdfe">
      		<infMDFe Id="MDFe32210717781119000141580010000001211000000003" versao="3.00">
              <tot>
      				<qNFe>10</qNFe>
              <qCTe>18</qCTe>
      				<vCarga>8222.10</vCarga>
      				<cUnid>01</cUnid>
      				<qCarga>615.1400</qCarga>
      			</tot>
      		</infMDFe>
      	</MDFe>
      </mdfeProc>
    eos
  end

  let(:pdf) { BrDanfe::MdfeLib::Document.new }
  let(:xml) { BrDanfe::XML.new(xml_as_string) }

  let(:base_dir) { './spec/fixtures/mdfe/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  subject { described_class.new(pdf, xml) }

  let(:pdf_text) do
    PDF::Inspector::Text.analyze(pdf.render).strings.join("\n")
  end

  describe '#render' do
    it 'renders the  informations' do

      cte_quantity = "QTD. CTe\n18"
      nfe_quantity = "QTD. NFe\n10"
      total_weight = "Peso Total (Kg)\n615,14"

      subject.render

      expect(pdf_text).to include cte_quantity
      expect(pdf_text).to include nfe_quantity
      expect(pdf_text).to include total_weight

    end

    it'renders the totalizer title' do
      title = "Modelo Rodoviário de Carga"

      subject.render

      expect(pdf_text).to include title
    end
  end
end
