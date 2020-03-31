require 'spec_helper'

describe BrDanfe::DanfeNfceLib::QrCode do
  let(:file_name) { 'qrcode' }
  let(:base_dir) { './spec/fixtures/nfce/lib/' }
  let(:logo) { './spec/fixtures/logo.png' }
  let(:output_pdf) { "#{base_dir}#{file_name}.pdf" }
  let(:company_name) {}

  let(:xml) do
    xml = <<-eos
      <infNFeSupl>
        <qrCode><![CDATA[http://sistemas.sefaz.am.gov.br/nfceweb/consultarNFCe.jsp?p=13130901144012000152651231234567891123456786|2|2|1|A604FD51E40ED8465B787B3E9CF8C1D90E61DB13]]></qrCode>
        <urlChave>www.sefaz.am.gov.br/nfce/consulta</urlChave>
      </infNFeSupl>
    eos

    BrDanfe::XML.new(xml)
  end

  let(:danfe) { BrDanfe::DanfeNfceLib::Document.new(8.cm, 5.cm) }

  before { File.delete(output_pdf) if File.exist?(output_pdf) }
  after { File.delete(output_pdf) if File.exist?(output_pdf) }

  it 'renders the document' do
    expect(File.exist?(output_pdf)).to be_falsey

    subject = described_class.new(danfe, xml)
    subject.render

    danfe.render_file output_pdf

    expect("#{base_dir}#{file_name}.fixture.pdf").to have_same_content_of file: output_pdf
  end
end
