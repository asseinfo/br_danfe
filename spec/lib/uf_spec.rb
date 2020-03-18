require 'spec_helper'

describe BrDanfe::Uf do
  describe '#include?' do
    ufs =
      [
        'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ',
        'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'
      ]

    context 'when uf is symbol' do
      ufs.each do |uf|
        it "returns true for uf #{uf}" do
          expect(BrDanfe::Uf.include? uf.to_sym).to be true
        end
      end
    end

    context 'when uf is string' do
      ufs.each do |uf|
        it "returns true for uf #{uf}" do
          expect(BrDanfe::Uf.include? uf).to be true
        end
      end
    end

    context 'when uf is not from Brazil' do
      it "returns false" do
        expect(BrDanfe::Uf.include? 'EX').to be false
      end
    end

    context 'when uf is blank' do
      it "returns false" do
        expect(BrDanfe::Uf.include? '').to be false
      end
    end

    context 'when uf is nil' do
      it "returns false" do
        expect(BrDanfe::Uf.include? nil).to be false
      end
    end
  end
end