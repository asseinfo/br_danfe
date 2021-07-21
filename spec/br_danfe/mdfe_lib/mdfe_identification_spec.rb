require 'spec_helper'

describe BrDanfe::MdfeLib::MdfeIdentification do
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
      				<UFFim>SC</UFFim>
      				<infMunCarrega>
      					<cMunCarrega>3205069</cMunCarrega>
      					<xMunCarrega>VENDA NOVA DO IMIGRANTE</xMunCarrega>
      				</infMunCarrega>
      				<dhIniViagem>2021-07-01T17:30:00-03:00</dhIniViagem>
      			</ide>
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
    it 'renders the model' do
      model = "Modelo\n58"

      subject.render(1)

      expect(pdf_text).to include model
    end

    it 'renders the series' do
      series = "Série\n1"

      subject.render(1)

      expect(pdf_text).to include series
    end

    it 'renders the number' do
      number = "Número\n121"

      subject.render(1)

      expect(pdf_text).to include number
    end

    it 'renders the page number' do
      pages = "FL\n1/1"

      subject.render(1)

      expect(pdf_text).to include pages
    end

    it 'renders the emitted date and hour' do
      datetime = "Data e hora de Emissão\n01/07/2021 17:30:00"

      subject.render(1)

      expect(pdf_text).to include datetime
    end

    it 'renders the origin uf' do
      origin_uf = "UF Carreg.\nES"

      subject.render(1)

      expect(pdf_text).to include origin_uf
    end

    it 'renders the destination uf' do
      destination_uf = "UF Descarreg.\nSC"

      subject.render(1)

      expect(pdf_text).to include destination_uf
    end
  end
end
