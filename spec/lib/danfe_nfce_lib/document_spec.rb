require 'spec_helper'

describe BrDanfe::DanfeNfceLib::ProductList do
  let(:file_name) { 'document' }
  let(:base_dir) { './spec/fixtures/nfce/lib/' }
  let(:output_pdf) { "#{base_dir}#{file_name}.pdf" }
  let(:danfe) { BrDanfe::DanfeNfceLib::Document.new(8.cm, 3.5.cm) }

  before { File.delete(output_pdf) if File.exist?(output_pdf) }
  after { File.delete(output_pdf) if File.exist?(output_pdf) }

  context 'when does not have a larger names' do
    it 'render the document' do
      expect(File.exist?(output_pdf)).to be_falsey

      danfe.render_file output_pdf

      expect("#{base_dir}#{file_name}.fixture.pdf").to have_same_content_of file: output_pdf
    end
  end
end
