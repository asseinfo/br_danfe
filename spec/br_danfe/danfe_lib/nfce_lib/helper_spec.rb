require 'spec_helper'

describe BrDanfe::DanfeLib::NfceLib::Helper do
  describe '.address' do
    let(:ender_tag) { double('ender_tag') }

    it 'delegates to BrDanfe::Helper.address' do
      allow(BrDanfe::Helper).to receive(:address).with(ender_tag).and_return('formatted address')

      expect(described_class.address(ender_tag)).to eq 'formatted address'
      expect(BrDanfe::Helper).to have_received(:address).with(ender_tag)
    end
  end
end
