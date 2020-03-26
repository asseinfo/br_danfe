require 'spec_helper'

RSpec.describe BrDanfe::Helper::Logo::Options do
  let(:box_size) { 100 }
  let(:logo_dimensions) {{ width: 50, height: 50 }}

  subject { described_class.new(box_size, logo_dimensions) }

  describe '#options' do
    context 'when the logo dimensions are smaller than the dimensions of the box' do
      context 'when the logo is square' do
        it 'returns the options with logo height' do
          expect(subject.options).to eq(height: 50, position: :center, vposition: :center)
        end
      end

      context 'when logo width is larger than logo height' do
        let(:logo_dimensions) {{ width: 75, height: 50 }}

        it 'returns the options with logo width' do
          expect(subject.options).to eq(width: 75, position: :center, vposition: :center)
        end
      end

      context 'when logo height is larger than logo width' do
        let(:logo_dimensions) {{ width: 50, height: 75 }}

        it 'returns the options with logo height' do
          expect(subject.options).to eq(height: 75, position: :center, vposition: :center)
        end
      end
    end

    context 'when the logo dimensions are equal to the dimensions of the box' do
      let(:logo_dimensions) {{ width: 100, height: 100 }}

      it 'returns the options with box size' do
        expect(subject.options).to eq(height: 100, position: :center, vposition: :center)
      end
    end

    context 'when the logo dimensions are larger than the dimensions of the box' do
      context 'when the logo is square' do
        let(:logo_dimensions) {{ width: 150, height: 150 }}

        it 'returns the options with box size' do
          expect(subject.options).to eq(height: 100, position: :center, vposition: :center)
        end
      end

      context 'when logo width is larger than logo height' do
        let(:logo_dimensions) {{ width: 175, height: 150 }}

        it 'returns the options with box size' do
          expect(subject.options).to eq(width: 100, position: :center, vposition: :center)
        end
      end

      context 'when logo height is larger than logo width' do
        let(:logo_dimensions) {{ width: 150, height: 175 }}

        it 'returns the options with box size' do
          expect(subject.options).to eq(height: 100, position: :center, vposition: :center)
        end
      end
    end
  end
end
