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

    BrDanfe::XML.new(xml)
  end

  subject { described_class.new pdf, xml_footer }

  describe '#render' do
    before { File.delete(output_pdf) if File.exist?(output_pdf) }
    it 'renders footer to the pdf' do
      subject.render
      expect(File.exist?(output_pdf)).to be_falsey

      pdf.render_file output_pdf

      expect("#{base_dir}footer#render.pdf").to have_same_content_of file: output_pdf
    end

    context 'when has footer info' do
      it 'renders footer with additional information to the pdf' do
        subject.render('Informação Adicional')
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}footer#render-with_additional_information.pdf").to have_same_content_of file: output_pdf
      end
    end
  end
end
