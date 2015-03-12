require "spec_helper"

describe BrDanfe::DanfeLib::Options do
  it "returns the default config set in the code" do
    options = BrDanfe::DanfeLib::Options.new
    expect(options.logo_path).to eq("")
  end

  it "returns the config set in params" do
    options = BrDanfe::DanfeLib::Options.new({"logo_path" => "/fake/path/file.png"})
    expect(options.logo_path).to eq("/fake/path/file.png")
  end
end
