require "spec_helper"

describe BrDanfe::Plate do
  describe ".format_plate" do
    it "returns a formated plate" do
      plate = "ABC1234"
      expect(BrDanfe::Plate.format(plate)).to eq "ABC-1234"
    end
  end
end
