require 'spec_helper'

describe BrDanfe::DanfeNfceLib::Footer do
  let(:base_dir) { './spec/fixtures/nfce/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:pdf) { BrDanfe::DanfeNfceLib::Document.new(8.cm, 5.cm) }

  let(:xml_footer) do
    xml = <<-eos
      <nfeProc>
          <NFe>
          <infNFe>
            <total>
              <ICMSTot>
                <vTotTrib>7.50</vTotTrib>
              </ICMSTot>
           </total>
          </infNFe>
        </NFe>
      </nfeProc>
    eos

    Nokogiri::XML(xml)
  end

  subject { described_class.new pdf, xml_footer }

  describe '#render' do
    before do
      subject.render
      File.delete(output_pdf) if File.exist?(output_pdf)
    end

    it 'renders footer to the pdf' do
      expect(File.exist?(output_pdf)).to be_falsey

      pdf.render_file output_pdf

      expect("#{base_dir}footer#render.pdf").to have_same_content_of file: output_pdf
    end
  end
end
