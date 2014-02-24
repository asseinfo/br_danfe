require "spec_helper"

describe BrDanfe::Cpf do
  describe ".format" do
    it "returns a formated CPF " do
      cpf = "61092121480"
      expect(BrDanfe::Cpf.format(cpf)).to eq "610.921.214-80"
    end
  end
end
