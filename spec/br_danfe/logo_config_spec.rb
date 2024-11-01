require 'spec_helper'

describe BrDanfe::Logo::Config do
  subject { described_class.new({}) }

  it 'returns the default config set in the code' do
    expect(subject.logo).to eql ''
    expect(subject.logo_dimensions).to eql({})
  end

  context 'when there are custom options' do
    subject { described_class.new({ logo: '/fake/path/file.png', logo_dimensions: { width: 50, height: 50 } }) }

    it 'returns the config set in params' do
      expect(subject.logo).to eql '/fake/path/file.png'
      expect(subject.logo_dimensions).to eql width: 50, height: 50
    end
  end
end
