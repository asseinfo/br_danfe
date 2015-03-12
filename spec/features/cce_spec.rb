require "spec_helper"

describe BrDanfe::Cce do
  let(:base_dir) { "./spec/fixtures/cce/v1.00/"}
  let(:output_pdf) { "#{base_dir}output.pdf" }
  let(:xml) { File.read("#{base_dir}cce.xml") }
  subject { described_class.new(xml) }

  describe "#render_pdf" do
    it "renders the correction letter" do
      expected = IO.binread("#{base_dir}cce.fixture.pdf")

      expect(subject.render_pdf).to eq expected
    end
  end

  describe "#save_pdf" do
    before { File.delete(output_pdf) if File.exist?(output_pdf) }

    it "saves the pdf" do
      expect(File.exist?(output_pdf)).to be_falsey

      subject.save_pdf output_pdf

      expect("#{base_dir}cce.fixture.pdf").to have_same_content_of file: output_pdf
    end
  end
end
