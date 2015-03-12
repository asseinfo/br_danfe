require "spec_helper"

describe BrDanfe::CceLib::Document do
  let(:base_dir) { "./spec/fixtures/cce/lib/"}
  let(:output_pdf) { "#{base_dir}output.pdf" }

  describe "#box" do
    context "when a block isn't passed" do
      before do
        File.delete(output_pdf) if File.exist?(output_pdf)
        subject.box(height: 50)
      end

      it "renders box with the page width" do
        expect(File.exist?(output_pdf)).to be_falsey

        subject.render_file output_pdf

        expect("#{base_dir}document#box.pdf").to have_same_content_of file: output_pdf
      end
    end

    context "when a block is passed" do
      before do
        File.delete(output_pdf) if File.exist?(output_pdf)
        subject.box(height: 50) { subject.text "sample text" }
      end

      it "renders box with the block" do
        expect(File.exist?(output_pdf)).to be_falsey

        subject.render_file output_pdf

        expect("#{base_dir}document#box.with.block.pdf").to have_same_content_of file: output_pdf
      end
    end
  end

  describe "#text" do
    context "when is a simple text" do
      before do
        File.delete(output_pdf) if File.exist?(output_pdf)
        subject.text "simple text"
      end

      it "renders the text" do
        expect(File.exist?(output_pdf)).to be_falsey

        subject.render_file output_pdf

        expect("#{base_dir}document#text.simple.pdf").to have_same_content_of file: output_pdf
      end
    end

    context "when is a text with style" do
      before do
        File.delete(output_pdf) if File.exist?(output_pdf)
        subject.text "bold text", style: :bold
      end

      it "renders the text" do
        expect(File.exist?(output_pdf)).to be_falsey

        subject.render_file output_pdf

        expect("#{base_dir}document#text.style.pdf").to have_same_content_of file: output_pdf
      end
    end

    context "when is a text with size" do
      before do
        File.delete(output_pdf) if File.exist?(output_pdf)
        subject.text "big text", size: 25
      end

      it "renders the text" do
        expect(File.exist?(output_pdf)).to be_falsey

        subject.render_file output_pdf

        expect("#{base_dir}document#text.size.pdf").to have_same_content_of file: output_pdf
      end
    end

    context "when is a text with pad" do
      before do
        File.delete(output_pdf) if File.exist?(output_pdf)
        subject.text "text with pad", pad: 50
      end

      it "renders the text" do
        expect(File.exist?(output_pdf)).to be_falsey

        subject.render_file output_pdf

        expect("#{base_dir}document#text.pad.pdf").to have_same_content_of file: output_pdf
      end
    end

    context "when is a text with align" do
      before do
        File.delete(output_pdf) if File.exist?(output_pdf)
        subject.text "text in center", align: :center
      end

      it "renders the text" do
        expect(File.exist?(output_pdf)).to be_falsey

        subject.render_file output_pdf

        expect("#{base_dir}document#text.align.pdf").to have_same_content_of file: output_pdf
      end
    end
  end
end
