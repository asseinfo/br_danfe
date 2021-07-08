require 'spec_helper'

describe BrDanfe::MdfeLib::FiscoControl do
  let(:base_dir) { './spec/fixtures/mdfe/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:xml_as_string) do
    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <mdfeProc xmlns="http://www.portalfiscal.inf.br/mdfe" versao="3.00">
        <protMDFe versao="3.00" xmlns="http://www.portalfiscal.inf.br/mdfe">
          <infProt Id="MDFe932210002534081">
            <chMDFe>32210717781119000141580010000001211000000003</chMDFe>
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
    after { File.delete(output_pdf) if File.exist?(output_pdf) }

    it 'renders the title' do
      title = 'CONTROLE DO FISCO'

      subject.render
      expect(pdf_text).to include title
    end

    it 'renders the bar code' do
      expect(File.exist?(output_pdf)).to be_falsey

      subject.render
      pdf.render_file output_pdf

      expect("#{base_dir}barcode#render.pdf").to have_same_content_of file: output_pdf
    end

    it 'renders the nfe key' do
      nfe_key = "Chave de Acesso\n32210717781119000141580010000001211000000003"

      subject.render
      expect(pdf_text).to include nfe_key
    end
  end
end
