require 'spec_helper'

describe BrDanfe::MdfeLib::Notes do
  def xml_as_string(options = {})
    params = {
      infAdFisco: '<infAdFisco>EXEMPLO INFORMAÇÕES ADICIONAIS FISCO</infAdFisco>',
      infCpl: '<infCpl>EXEMPLO INFORMAÇÕES ADICIONAIS CONTRIBUINTE</infCpl>'
    }.merge(options)

    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <mdfeProc xmlns="http://www.portalfiscal.inf.br/mdfe" versao="3.00">
        <MDFe xmlns="http://www.portalfiscal.inf.br/mdfe">
          <infMDFe Id="MDFe32210717781119000141580010000001211000000003" versao="3.00">
            <infAdic>
              #{params[:infAdFisco]}
              #{params[:infCpl]}
            </infAdic>
          </infMDFe>
        </MDFe>
      </mdfeProc>
    XML
  end

  let(:base_dir) { './spec/fixtures/mdfe/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:pdf) { BrDanfe::MdfeLib::Document.new }
  let(:xml) { BrDanfe::XML.new(xml_as_string) }

  subject { described_class.new(pdf, xml) }

  let(:pdf_text) do
    PDF::Inspector::Text.analyze(pdf.render).strings.join("\n")
  end

  before { pdf.move_cursor_to 345 }

  describe '#generate' do
    it 'generates the title' do
      title = 'Observações'

      subject.generate
      expect(pdf_text).to include title
    end

    it 'generates additional information for fisco when xml has content in infAdFisco tag' do
      fisco_information = "INFORMAÇÕES ADICIONAIS DE INTERESSE DO FISCO\nEXEMPLO INFORMAÇÕES ADICIONAIS FISCO"

      subject.generate
      expect(pdf_text).to include fisco_information
    end

    it 'does not generate the additional information for fisco when xml does not have content in infAdFisco tag' do
      fisco_information = "INFORMAÇÕES ADICIONAIS DE INTERESSE DO FISCO\n"

      xml = BrDanfe::XML.new(xml_as_string(infAdFisco: '', infCpl: ''))
      subject = described_class.new(pdf, xml)
      subject.generate
      expect(pdf_text).not_to include fisco_information
    end

    it 'generates the additional information for taxpayer when xml has content in infCpl tag' do
      taxpayer_information = "INFORMAÇÕES ADICIONAIS DE INTERESSE DO CONTRIBUINTE\nEXEMPLO INFORMAÇÕES ADICIONAIS CONTRIBUINTE"

      subject.generate
      expect(pdf_text).to include taxpayer_information
    end

    it 'does not generate the additional information for taxpayer when xml does not have content in infCpl tag' do
      taxpayer_information = "INFORMAÇÕES ADICIONAIS DE INTERESSE DO CONTRIBUINTE\n"

      xml = BrDanfe::XML.new(xml_as_string(infAdFisco: '', infCpl: ''))
      subject = described_class.new(pdf, xml)
      subject.generate
      expect(pdf_text).not_to include taxpayer_information
    end

    after { File.delete(output_pdf) if File.exist?(output_pdf) }

    it 'creates a new page if aditional information do not fit on first page' do
      expect(File.exist?(output_pdf)).to be false

      xml = BrDanfe::XML.new(
        xml_as_string(
          infAdFisco: "<infAdFisco>#{'alguma coisa ' * 153}</infAdFisco>",
          infCpl: "<infCpl>#{'alguma coisa ' * 2000}<infCpl>"
        )
      )
      subject = described_class.new(pdf, xml)
      subject.generate
      pdf.render_file output_pdf

      expect("#{base_dir}notes#render-big-aditional-information.pdf").to have_same_content_of file: output_pdf
    end
  end
end
