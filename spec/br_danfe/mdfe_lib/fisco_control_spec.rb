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

  describe '#generate' do
    before { FileUtils.rm_f(output_pdf) }

    it 'generates the title' do
      subject.generate
      expect(pdf_text).to include 'CONTROLE DO FISCO'
    end

    it 'generates the bar code' do
      expect(File.exist?(output_pdf)).to be false

      subject.generate
      pdf.render_file output_pdf

      expect("#{base_dir}fisco_control#barcode.pdf").to have_same_content_of file: output_pdf
    end

    it 'generates the nfe key' do
      subject.generate
      expect(pdf_text).to include "Chave de Acesso\n32210717781119000141580010000001211000000003"
    end

    context 'when the XML does not have protMDFe tag' do
      let(:xml_as_string) do
        <<~XML
          <?xml version="1.0" encoding="UTF-8"?>
          <mdfeProc xmlns="http://www.portalfiscal.inf.br/mdfe" versao="3.00"></mdfeProc>
        XML
      end

      it 'does not generate the bar code and the nfe key' do
        expect(File.exist?(output_pdf)).to be false

        subject.generate
        pdf.render_file output_pdf

        expect("#{base_dir}fisco_control#without-barcode.pdf").to have_same_content_of file: output_pdf
      end
    end
  end
end
