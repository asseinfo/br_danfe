require 'spec_helper'

describe BrDanfe::MdfeLib::Document do
  let(:base_dir) { './spec/fixtures/mdfe/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  describe '#method_missing' do
    context 'when prawn has the method' do
      it 'does not throws an error' do
        expect(subject).to respond_to :text
      end
    end

    context 'when prawn does not have the method' do
      it 'throws an error' do
        expect { subject.non_existent_method }.to raise_error NameError
      end
    end
  end
end
