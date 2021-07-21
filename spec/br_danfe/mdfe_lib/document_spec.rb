require 'spec_helper'

describe BrDanfe::MdfeLib::Document do
  let(:base_dir) { './spec/fixtures/mdfe/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  describe '#method_missing' do
    context 'when prawn has the method' do
      it 'does not throws an error' do
        expect{ subject.text }.not_to raise_error NameError
      end
    end

    context 'when prawn does not have the method' do
      it 'throws an error' do
        expect{ subject.any_method }.to raise_error NameError
      end
    end
  end
end
