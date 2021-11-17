require 'spec_helper'

describe BrDanfe::Mdfe do
  let(:base_dir) { './spec/fixtures/mdfe/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:xml) { File.read('./spec/fixtures/mdfe/lib/xml-mdfe.xml') }

  subject { described_class.new(xml) }

  before { File.delete(output_pdf) if File.exist?(output_pdf) }

  before do
    subject.logo_options.logo_dimensions = { width: 100, height: 100 }
    subject.logo_options.logo = 'spec/fixtures/logo.png'
  end

  describe '#render_pdf' do
    it 'renders the mdfe' do
      expected = IO.binread("#{base_dir}mdfe.fixture.pdf")

      expect(subject.render_pdf).to eql expected
    end
  end

  describe '#save_pdf' do
    it 'saves the mdfe' do
      expect(File.exist?(output_pdf)).to be false

      subject.save_pdf output_pdf
      expect("#{base_dir}mdfe.fixture.pdf").to have_same_content_of file: output_pdf
    end
  end

  context 'when MDF-e has multiple pages' do
    let(:xml) { File.read('./spec/fixtures/mdfe/lib/xml-mdfe-multiples-pages.xml') }

    it 'renders the header and the identification on each page' do
      expect(File.exist?(output_pdf)).to be false

      subject.save_pdf output_pdf
      expect("#{base_dir}mdfe-with-multiple-pages.pdf").to have_same_content_of file: output_pdf
    end
  end
end
