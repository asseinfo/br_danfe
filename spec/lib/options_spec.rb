require "spec_helper"

describe BrDanfe::Options do
  it "should return default config set in code" do
    options = BrDanfe::Options.new
    expect(options.logo_path).to eq("")
  end

  it "should return config set in params" do
    options = BrDanfe::Options.new({"logo_path" => "/fake/path/file.png"})
    expect(options.logo_path).to eq("/fake/path/file.png")
  end
end
