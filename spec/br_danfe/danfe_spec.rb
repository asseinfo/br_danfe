require 'spec_helper'

describe BrDanfe::Danfe do
  let(:output_pdf) { "#{base_dir}output.pdf" }

  describe '#render_pdf' do
    let(:base_dir) { './spec/fixtures/nfe/v3.10/' }

    it 'renders a Simples Nacional NF-e using CSOSN' do
      BrDanfe::Danfe.new(File.read("#{base_dir}nfe_simples_nacional.xml"))
    end
  end
end
