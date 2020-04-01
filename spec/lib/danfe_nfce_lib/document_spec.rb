require 'spec_helper'

describe BrDanfe::DanfeNfceLib::ProductList do
  let(:base_dir) { './spec/fixtures/nfce/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:subject) { BrDanfe::DanfeNfceLib::Document.new(8.cm, 1.8.cm) }

  before { File.delete(output_pdf) if File.exist?(output_pdf) }

  it 'render the document with blank lines' do
    expect(File.exist?(output_pdf)).to be_falsey

    2.times { subject.render_blank_line }
    subject.render_file output_pdf

    expect("#{base_dir}document#render.pdf").to have_same_content_of file: output_pdf
  end
end
