require 'spec_helper'

describe BrDanfe::DanfeNfe do
  let(:output_pdf) { "#{base_dir}output.pdf" }

  describe '#render_pdf' do
    let(:base_dir) { './spec/fixtures/nfe/v3.10/' }

    it 'renders a Simples Nacional NF-e using CSOSN' do
      danfe = BrDanfe::DanfeNfe.new(File.read("#{base_dir}nfe_simples_nacional.xml"))

      expected = IO.binread("#{base_dir}nfe_simples_nacional.xml.fixture.pdf")

      expect(danfe.render_pdf).to eq expected
    end
  end

  describe '#save_pdf' do
    context 'when danfe has custom options' do
      let(:base_dir) { './spec/fixtures/nfe/v2.00/' }

      before { File.delete(output_pdf) if File.exist?(output_pdf) }

      it 'render a NF-e with customized options' do
        expect(File.exist?(output_pdf)).to be_falsey

        danfe = BrDanfe::DanfeNfe.new(File.read("#{base_dir}custom_options.fixture.xml"))
        danfe.options.logo = 'spec/fixtures/logo.png'
        danfe.options.logo_dimensions = { width: 100, height: 100 }

        danfe.save_pdf output_pdf

        expect("#{base_dir}custom_options.fixture.pdf").to have_same_content_of file: output_pdf
      end
    end

    context "when xml's version is v2.00" do
      let(:base_dir) { './spec/fixtures/nfe/v2.00/' }

      before { File.delete(output_pdf) if File.exist?(output_pdf) }

      it 'renders a basic NF-e with namespace' do
        expect(File.exist?(output_pdf)).to be_falsey

        danfe = BrDanfe::DanfeNfe.new(File.read("#{base_dir}nfe_with_ns.xml"))
        danfe.save_pdf output_pdf

        expect("#{base_dir}nfe_with_ns.xml.fixture.pdf").to have_same_content_of file: output_pdf
      end

      it 'renders another basic NF-e without namespace' do
        expect(File.exist?(output_pdf)).to be_falsey

        danfe = BrDanfe::DanfeNfe.new(File.read("#{base_dir}nfe_without_ns.xml"))
        danfe.save_pdf output_pdf

        expect("#{base_dir}nfe_without_ns.xml.fixture.pdf").to have_same_content_of file: output_pdf
      end

      it 'renders a NF-e having FCI in its items' do
        expect(File.exist?(output_pdf)).to be_falsey

        danfe = BrDanfe::DanfeNfe.new(File.read("#{base_dir}nfe_with_fci.xml"))
        danfe.save_pdf output_pdf

        expect("#{base_dir}nfe_with_fci.xml.fixture.pdf").to have_same_content_of file: output_pdf
      end

      it 'renders a Simples Nacional NF-e using CSOSN' do
        expect(File.exist?(output_pdf)).to be_falsey

        danfe = BrDanfe::DanfeNfe.new(File.read("#{base_dir}nfe_simples_nacional.xml"))
        danfe.save_pdf output_pdf

        expect("#{base_dir}nfe_simples_nacional.xml.fixture.pdf").to have_same_content_of file: output_pdf
      end

      it 'renders a NF-e with extra volumes' do
        expect(File.exist?(output_pdf)).to be_falsey

        danfe = BrDanfe::DanfeNfe.new(File.read("#{base_dir}nfe_with_extra_volumes.xml"))
        danfe.save_pdf output_pdf

        expect("#{base_dir}nfe_with_extra_volumes.xml.fixture.pdf").to have_same_content_of file: output_pdf
      end
    end

    context "when xml's version is v3.10" do
      let(:base_dir) { './spec/fixtures/nfe/v3.10/' }

      before { File.delete(output_pdf) if File.exist?(output_pdf) }

      it 'renders a Simples Nacional NF-e using CSOSN' do
        expect(File.exist?(output_pdf)).to be_falsey

        danfe = BrDanfe::DanfeNfe.new(File.read("#{base_dir}nfe_simples_nacional.xml"))
        danfe.save_pdf output_pdf

        expect("#{base_dir}nfe_simples_nacional.xml.fixture.pdf").to have_same_content_of file: output_pdf
      end

      context 'when there are more than one page' do
        it 'renders xml to the pdf' do
          expect(File.exist?(output_pdf)).to be_falsey

          danfe = BrDanfe::DanfeNfe.new(File.read("#{base_dir}with_three_pages.xml"))
          danfe.save_pdf output_pdf

          expect("#{base_dir}with_three_pages.fixture.pdf").to have_same_content_of file: output_pdf
        end
      end

      context 'when there is ISSQN' do
        it 'renders xml to the pdf' do
          expect(File.exist?(output_pdf)).to be_falsey

          danfe = BrDanfe::DanfeNfe.new(File.read("#{base_dir}with_issqn.xml"))
          danfe.save_pdf output_pdf

          expect("#{base_dir}with_issqn.fixture.pdf").to have_same_content_of file: output_pdf
        end
      end

      context "when there isn't ISSQN" do
        it 'renders xml to the pdf' do
          expect(File.exist?(output_pdf)).to be_falsey

          danfe = BrDanfe::DanfeNfe.new(File.read("#{base_dir}without_issqn.xml"))
          danfe.save_pdf output_pdf

          expect("#{base_dir}without_issqn.fixture.pdf").to have_same_content_of file: output_pdf
        end
      end

      context 'when there is footer information' do
        it 'renders xml to the pdf' do
          expect(File.exist?(output_pdf)).to be_falsey

          footer = 'Gerado através do Teste'
          danfe = BrDanfe::DanfeNfe.new(File.read("#{base_dir}with_footer.xml"))
          danfe.save_pdf output_pdf, footer

          expect("#{base_dir}with_footer.fixture.pdf").to have_same_content_of file: output_pdf
        end
      end
    end
  end
end
