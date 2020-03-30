require 'spec_helper'

describe BrDanfe::DanfeNfceLib::Key do
  let(:base_dir) { './spec/fixtures/nfce/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:xml_as_string) do
    xml = <<-eos
      <nfeProc>
        <NFe>
          <infNFeSupl>
            <qrCode><![CDATA[http://sistemas.sefaz.am.gov.br/nfceweb/consultarNFCe.jsp?p=13130901144012000152651231234567891123456786|2|2|1|A604FD51E40ED8465B787B3E9CF8C1D90E61DB13]]></qrCode>
            <urlChave>www.sefaz.am.gov.br/nfce/consulta</urlChave>
          </infNFeSupl>
        </NFe>
        <protNFe versao="4.00">
          <infProt>
            <chNFe>42200310845180000166550010000016291182910232</chNFe>
          </infProt>
        </protNFe>
      </nfeProc>
    eos
  end

  let(:xml_key) { BrDanfe::DanfeNfceLib::XML.new(xml_as_string) }
  let(:pdf) { BrDanfe::DanfeNfceLib::Document.new(8.cm, 5.cm) }

  subject { described_class.new pdf, xml_key }

  describe '#render' do
    before do
      subject.render
      File.delete(output_pdf) if File.exist?(output_pdf)
    end

    it 'renders key to the pdf' do
      expect(File.exist?(output_pdf)).to be_falsey

      pdf.render_file output_pdf

      expect("#{base_dir}key#render.pdf").to have_same_content_of file: output_pdf
    end
  end
end
