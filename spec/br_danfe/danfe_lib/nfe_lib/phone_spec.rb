require 'spec_helper'

describe BrDanfe::DanfeLib::NfeLib::Phone do
  describe '.format' do
    context 'when phone have 10 digits' do
      it 'returns a formated phone' do
        phone = '1234567890'
        expect(BrDanfe::DanfeLib::NfeLib::Phone.format(phone)).to eq '(12) 3456-7890'
      end
    end

    context 'when phone have 11 digits' do
      it 'returns a formated phone' do
        phone = '12345678901'
        expect(BrDanfe::DanfeLib::NfeLib::Phone.format(phone)).to eq '(12) 34567-8901'
      end
    end
  end
end
