require 'spec_helper'

describe BrDanfe::DanfeLib::Nfce do
  let(:output_pdf) { "#{base_dir}output.pdf" }
  let(:base_dir) { './spec/fixtures/nfce/v4.00/' }
  let(:xml) { BrDanfe::XML.new(File.read("#{base_dir}nfce.xml")) }

  subject { described_class.new xml }

  before do
    subject.options.logo = 'spec/fixtures/logo.png'
    subject.options.logo_dimensions = { width: 100, height: 100 }
  end

  describe '#render_pdf' do
    it 'renders the NFC-e pdf' do
      expected = IO.binread("#{base_dir}rendered_nfce.fixture.pdf")
      expect(subject.render_pdf).to eq expected
    end
  end

  describe '#save_pdf' do
    before { File.delete(output_pdf) if File.exist?(output_pdf) }
    after { File.delete(output_pdf) if File.exist?(output_pdf) }

    it 'saves the NFC-e as pdf' do
      expect(File.exist?(output_pdf)).to be_falsey
      subject.save_pdf output_pdf

      expect("#{base_dir}saved_nfce.fixture.pdf").to have_same_content_of file: output_pdf
    end
  end
end
