require 'spec_helper'

describe BrDanfe::MdfeLib::Totalizer do
  let(:xml_as_string) do
    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <mdfeProc xmlns="http://www.portalfiscal.inf.br/mdfe" versao="3.00">
      	<MDFe xmlns="http://www.portalfiscal.inf.br/mdfe">
      		<infMDFe Id="MDFe32210717781119000141580010000001211000000003" versao="3.00">
            <tot>
      				<qNFe>10</qNFe>
      				<vCarga>8222.10</vCarga>
      				<cUnid>01</cUnid>
      				<qCarga>615.1400</qCarga>
      			</tot>
      		</infMDFe>
      	</MDFe>
      </mdfeProc>
    XML
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
    it 'renders the nfe quantity' do
      nfe_quantity = "QTD. NFe\n10"

      subject.render
      expect(pdf_text).to include nfe_quantity
    end

    it 'renders only the box of cte quantity' do
      cte_quantity = "QTD. CTe\n"

      subject.render
      expect(pdf_text).to include cte_quantity
    end

    it 'renders the total weight' do
      total_weight = "Peso total (Kg)\n615,14"

      subject.render
      expect(pdf_text).to include total_weight
    end

    it'renders the totalizer title' do
      title = 'Modelo Rodoviário de Carga'

      subject.render
      expect(pdf_text).to include title
    end
  end
end
