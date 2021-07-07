require 'spec_helper'

describe BrDanfe::MdfeLib::MdfeIdentification do
  let(:xml_as_string) do
    <<-eos
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

  describe'#render' do
    it'renders the model identification' do
      model = '58'

      subject.render

      expect(pdf_text).to include model
      pdf.render_file output_pdf # TODO: remover
    end

    it'renders the serie identification' do
      serie = '1'

      subject.render

      expect(pdf_text).to include serie
      pdf.render_file output_pdf # TODO: remover
    end

    it'renders the number identification' do
      number = '121'

      subject.render

      expect(pdf_text).to include number
      pdf.render_file output_pdf # TODO: remover
    end
  end
end
