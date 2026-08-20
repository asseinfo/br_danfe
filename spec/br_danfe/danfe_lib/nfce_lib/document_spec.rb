require 'spec_helper'

describe BrDanfe::DanfeLib::NfceLib::ProductList do
  let(:base_dir) { './spec/fixtures/nfce/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:subject) { BrDanfe::DanfeLib::NfceLib::Document.new(8.cm, 1.8.cm) }

  before { FileUtils.rm_f(output_pdf) }

  it 'render the document with blank lines' do
    expect(File.exist?(output_pdf)).to be_falsey

    2.times { subject.render_blank_line }
    subject.render_file output_pdf

    expect("#{base_dir}document#render.pdf").to have_same_content_of file: output_pdf
  end

  describe 'delegating unknown methods to the underlying Prawn document' do
    context 'when the underlying document also does not know the method' do
      it 'raises NoMethodError' do
        expect { subject.this_method_does_not_exist }.to raise_error(NoMethodError)
      end

      it 'does not respond to it' do
        expect(subject.respond_to?(:this_method_does_not_exist)).to be_falsey
      end
    end
  end
end
