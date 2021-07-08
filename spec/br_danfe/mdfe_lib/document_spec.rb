require 'spec_helper'

describe BrDanfe::MdfeLib::Document do
  let(:base_dir) { './spec/fixtures/mdfe/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  describe '#text' do
    after { File.delete(output_pdf) if File.exist?(output_pdf) }
    context 'when is a simple text' do
      before do
        subject.text 'simple text'
      end

      it 'renders the text' do
        expect(File.exist?(output_pdf)).to be_falsey

        subject.render_file output_pdf

        expect("#{base_dir}document#text.simple.pdf").to have_same_content_of file: output_pdf
      end
    end

    context 'when is a text with style' do
      before do
        subject.text 'bold text', style: :bold
      end

      it 'renders the text' do
        expect(File.exist?(output_pdf)).to be_falsey

        subject.render_file output_pdf

        expect("#{base_dir}document#text.style.pdf").to have_same_content_of file: output_pdf
      end
    end

    context 'when is a text with size' do
      before do
        subject.text 'big text', size: 25
      end

      it 'renders the text' do
        expect(File.exist?(output_pdf)).to be_falsey

        subject.render_file output_pdf

        expect("#{base_dir}document#text.size.pdf").to have_same_content_of file: output_pdf
      end
    end

    context 'when is a text with pad' do
      before do
        subject.text 'text with pad', pad: 50
      end

      it 'renders the text' do
        expect(File.exist?(output_pdf)).to be_falsey

        subject.render_file output_pdf

        expect("#{base_dir}document#text.pad.pdf").to have_same_content_of file: output_pdf
      end
    end

    context 'when is a text with align' do
      before do
        subject.text 'text in center', align: :center
      end

      it 'renders the text' do
        expect(File.exist?(output_pdf)).to be_falsey

        subject.render_file output_pdf

        expect("#{base_dir}document#text.align.pdf").to have_same_content_of file: output_pdf
      end
    end
  end
end
