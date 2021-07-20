require 'spec_helper'

describe BrDanfe::MdfeLib::Notes do
  def xml_as_string(options = {})
    params = {
      infAdFisco: '<infAdFisco>EXEMPLO INFORMAÇÕES ADICIONAIS FISCO</infAdFisco>',
      infCpl: '<infCpl>EXEMPLO INFORMAÇÕES ADICIONAIS CONTRIBUINTE</infCpl>',
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

  describe '#render' do
    it 'renders the title' do
      title = 'Observações'

      subject.render
      expect(pdf_text).to include title
    end

    it 'renders the aditional information for fisco when xml has infAdFisco tag' do
      fisco_information = "INFORMAÇÕES ADICIONAIS DE INTERESSE DO FISCO\nEXEMPLO INFORMAÇÕES ADICIONAIS FISCO"

      subject.render
      expect(pdf_text).to include fisco_information
    end

    it 'does not render the aditional information for fisco when xml does not have infAdFisco tag' do
      fisco_information = "INFORMAÇÕES ADICIONAIS DE INTERESSE DO FISCO\n"

      xml = BrDanfe::XML.new(xml_as_string(infAdFisco: '', infCpl: ''))
      subject = described_class.new(pdf, xml)
      subject.render
      expect(pdf_text).not_to include fisco_information
    end

    it 'renders the aditional information for taxpayer when xml has infCpl tag' do
      taxpayer_information = "INFORMAÇÕES ADICIONAIS DE INTERESSE DO CONTRIBUINTE\nEXEMPLO INFORMAÇÕES ADICIONAIS CONTRIBUINTE"

      subject.render
      expect(pdf_text).to include taxpayer_information
    end

    it 'does not render the aditional information for taxpayer when xml does not have infCpl tag' do
      taxpayer_information = "INFORMAÇÕES ADICIONAIS DE INTERESSE DO CONTRIBUINTE\n"

      xml = BrDanfe::XML.new(xml_as_string(infAdFisco: '', infCpl: ''))
      subject = described_class.new(pdf, xml)
      subject.render
      expect(pdf_text).not_to include taxpayer_information
    end

    # TODO: verificar esse teste com o Marquinhos, y das obrservações no topo da página de teste
    after { File.delete(output_pdf) if File.exist?(output_pdf) }

    it 'creates a new page if aditional information do not fit on first page' do
      expect(File.exist?(output_pdf)).to be_falsey

      xml = BrDanfe::XML.new(
        xml_as_string(
          infAdFisco: "<infAdFisco>#{'fisco' * 434}</infAdFisco>",
          infCpl: "<infCpl>#{'contribuinte' * 584}<infCpl>"
        )
      )
      subject = described_class.new(pdf, xml)
      subject.render
      pdf.render_file output_pdf

      expect("#{base_dir}notes#render-big-aditional-information.pdf").to have_same_content_of file: output_pdf
    end
  end
end
