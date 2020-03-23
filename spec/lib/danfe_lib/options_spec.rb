require 'spec_helper'

describe BrDanfe::DanfeLib::Options do
  it 'returns the default config set in the code' do
    options = BrDanfe::DanfeLib::Options.new
    expect(options.logo).to eq('')
    expect(options.logo_dimensions).to eq({})
  end

  it 'returns the config set in params' do
    custom_options = { logo: '/fake/path/file.png', logo_dimensions: { width: 50, height: 50 } }

    options = BrDanfe::DanfeLib::Options.new(custom_options)
    expect(options.logo).to eq('/fake/path/file.png')
    expect(options.logo_dimensions).to eq({ width: 50, height: 50 })
  end
end
