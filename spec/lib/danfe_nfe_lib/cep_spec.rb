require 'spec_helper'

describe BrDanfe::DanfeNfeLib::Cep do
  describe '.format' do
    it 'returns a formated CEP' do
      cep = '12345678'
      expect(BrDanfe::DanfeNfeLib::Cep.format(cep)).to eq '12.345-678'
    end
  end
end
