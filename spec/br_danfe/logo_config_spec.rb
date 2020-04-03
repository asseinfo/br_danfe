require 'spec_helper'

describe BrDanfe::Logo::Config do
  let(:options) { {} }

  subject { described_class.new options }

  it 'returns the default config set in the code' do
    expect(subject.logo).to eq('')
    expect(subject.logo_dimensions).to eq({})
  end

  context 'when there are custom options' do
    let(:options) { { logo: '/fake/path/file.png', logo_dimensions: { width: 50, height: 50 } } }

    it 'returns the config set in params' do
      expect(subject.logo).to eq('/fake/path/file.png')
      expect(subject.logo_dimensions).to eq(width: 50, height: 50)
    end
  end
end
