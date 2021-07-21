require 'spec_helper'

describe BrDanfe::QrCode do
  let(:base_dir) { './spec/fixtures/qr_code/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:pdf) do
    BrDanfe::DocumentBuilder.build(
      page_size: 'A4',
      page_layout: :portrait
    )
  end

  let(:xml) do
    xml = <<-eos
      <infNFeSupl>
        <qrCode><![CDATA[http://sistemas.sefaz.am.gov.br/nfceweb/consultarNFCe.jsp?p=13130901144012000152651231234567891123456786|2|2|1|A604FD51E40ED8465B787B3E9CF8C1D90E61DB13]]></qrCode>
        <urlChave>www.sefaz.am.gov.br/nfce/consulta</urlChave>
      </infNFeSupl>
    eos

    BrDanfe::XML.new(xml)
  end

  subject { described_class.new(pdf: pdf, xml: xml, qr_code_tag: xml['qrCode'], box_size: 3.cm) }

  describe '#render' do
    before do
      File.delete(output_pdf) if File.exist?(output_pdf)
    end

    it 'renders qr-code to the pdf' do
      expect(File.exist?(output_pdf)).to be_falsey
      subject.render
      pdf.render_file output_pdf

      expect("#{base_dir}qr_code#render.pdf").to have_same_content_of file: output_pdf
    end
  end
end
