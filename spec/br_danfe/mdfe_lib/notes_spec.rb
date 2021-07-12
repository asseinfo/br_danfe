require 'spec_helper'

describe BrDanfe::MdfeLib::Notes do
  let(:pdf) { BrDanfe::MdfeLib::Document.new }

  subject { described_class.new(pdf, xml) }

  let(:pdf_text) do
    PDF::Inspector::Text.analyze(pdf.render).strings.join("\n")
  end

  describe '#render' do
    it 'renders the title' do
      title = 'Observações'

      subject.render
      expect(pdf_text).to include title
    end
  end
end
