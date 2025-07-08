require 'spec_helper'

describe BrDanfe::Uf do
  describe '#include?' do
    ufs =
      %w[
        AC AL AP AM BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ
        RN RS RO RR SC SP SE TO
      ]

    context 'when uf is symbol' do
      ufs.each do |uf|
        it "returns true for uf #{uf}" do
          expect(BrDanfe::Uf.include?(uf.to_sym)).to be true
        end
      end
    end
  end
end
