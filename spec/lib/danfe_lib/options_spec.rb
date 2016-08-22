require "spec_helper"

describe BrDanfe::DanfeLib::Options do
  it "returns the default config set in the code" do
    options = BrDanfe::DanfeLib::Options.new
    expect(options.logo).to eq("")
    expect(options.products_unit_price_precision).to eq(2)
    expect(options.products_quantity_precision).to eq(2)
  end

  it "returns the config set in params" do
    custom_options = { logo: "/fake/path/file.png",
      products_unit_price_precision: 3, products_quantity_precision: 4 }

    options = BrDanfe::DanfeLib::Options.new(custom_options)
    expect(options.logo).to eq("/fake/path/file.png")
    expect(options.products_unit_price_precision).to eq(3)
    expect(options.products_quantity_precision).to eq(4)
  end
end
