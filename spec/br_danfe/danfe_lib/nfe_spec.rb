require 'spec_helper'

describe BrDanfe::DanfeLib::Nfe do
  let(:output_pdf) { "#{base_dir}output.pdf" }
  let(:xml_file) {} # rubocop:disable Lint/EmptyBlock
  let(:xml) { BrDanfe::XML.new(xml_file) }

  subject { described_class.new [xml] }

  describe '#render_pdf' do
    let(:base_dir) { './spec/fixtures/nfe/v3.10/' }
    let(:xml_file) { File.read("#{base_dir}nfe_simples_nacional.xml") }

    it 'renders a Simples Nacional NF-e using CSOSN' do
      expected = File.binread("#{base_dir}nfe_simples_nacional.xml.fixture.pdf")
      expect(subject.render_pdf).to eq expected
    end
  end

  describe '#save_pdf' do
    context 'when danfe has custom options' do
      let(:base_dir) { './spec/fixtures/nfe/v2.00/' }
      let(:xml_file) { File.read("#{base_dir}custom_options.fixture.xml") }

      before { FileUtils.rm_f(output_pdf) }

      it 'render a NF-e with customized options' do
        expect(File.exist?(output_pdf)).to be_falsey

        subject.options.logo = 'spec/fixtures/logo.png'
        subject.options.logo_dimensions = { width: 100, height: 100 }
        subject.save_pdf output_pdf

        expect("#{base_dir}custom_options.fixture.pdf").to have_same_content_of file: output_pdf
      end
    end

    context "when xml's version is v2.00" do
      let(:base_dir) { './spec/fixtures/nfe/v2.00/' }
      let(:xml_file) { File.read("#{base_dir}nfe_with_ns.xml") }

      before { FileUtils.rm_f(output_pdf) }

      it 'renders a basic NF-e with namespace' do
        expect(File.exist?(output_pdf)).to be_falsey
        subject.save_pdf output_pdf

        expect("#{base_dir}nfe_with_ns.xml.fixture.pdf").to have_same_content_of file: output_pdf
      end

      context 'when NF-e does not have namespace' do
        let(:xml_file) { File.read("#{base_dir}nfe_without_ns.xml") }

        it 'renders another basic NF-e without namespace' do
          expect(File.exist?(output_pdf)).to be_falsey
          subject.save_pdf output_pdf

          expect("#{base_dir}nfe_without_ns.xml.fixture.pdf").to have_same_content_of file: output_pdf
        end
      end

      context 'when NF-e items has FCI' do
        let(:xml_file) { File.read("#{base_dir}nfe_with_fci.xml") }

        it 'renders a NF-e having FCI in its items' do
          expect(File.exist?(output_pdf)).to be_falsey
          subject.save_pdf output_pdf

          expect("#{base_dir}nfe_with_fci.xml.fixture.pdf").to have_same_content_of file: output_pdf
        end
      end

      context 'when NF-e is Simples Nacional with CSOSN' do
        let(:xml_file) { File.read("#{base_dir}nfe_simples_nacional.xml") }

        it 'renders a Simples Nacional NF-e using CSOSN' do
          expect(File.exist?(output_pdf)).to be_falsey
          subject.save_pdf output_pdf

          expect("#{base_dir}nfe_simples_nacional.xml.fixture.pdf").to have_same_content_of file: output_pdf
        end
      end

      context 'when NF-e has extra volumes' do
        let(:xml_file) { File.read("#{base_dir}nfe_with_extra_volumes.xml") }

        it 'renders a NF-e with extra volumes' do
          expect(File.exist?(output_pdf)).to be_falsey
          subject.save_pdf output_pdf

          expect("#{base_dir}nfe_with_extra_volumes.xml.fixture.pdf").to have_same_content_of file: output_pdf
        end
      end

      context 'when NF-e has entrega' do
        let(:xml_file) { File.read("#{base_dir}nfe_with_entrega.xml") }

        it 'renders a NF-e with entrega' do
          expect(File.exist?(output_pdf)).to be_falsey
          subject.save_pdf output_pdf

          expect("#{base_dir}nfe_with_entrega.xml.fixture.pdf").to have_same_content_of file: output_pdf
        end
      end
    end

    context "when xml's version is v3.10" do
      let(:base_dir) { './spec/fixtures/nfe/v3.10/' }
      let(:xml_file) { File.read("#{base_dir}nfe_simples_nacional.xml") }

      before { FileUtils.rm_f(output_pdf) }

      it 'renders a Simples Nacional NF-e using CSOSN' do
        expect(File.exist?(output_pdf)).to be_falsey
        subject.save_pdf output_pdf

        expect("#{base_dir}nfe_simples_nacional.xml.fixture.pdf").to have_same_content_of file: output_pdf
      end

      context 'when there are more than one page' do
        let(:xml_file) { File.read("#{base_dir}with_three_pages.xml") }

        it 'renders xml to the pdf' do
          expect(File.exist?(output_pdf)).to be_falsey
          subject.save_pdf output_pdf

          expect("#{base_dir}with_three_pages.fixture.pdf").to have_same_content_of file: output_pdf
        end
      end

      context 'when there is ISSQN' do
        let(:xml_file) { File.read("#{base_dir}with_issqn.xml") }

        it 'renders xml to the pdf' do
          expect(File.exist?(output_pdf)).to be_falsey
          subject.save_pdf output_pdf

          expect("#{base_dir}with_issqn.fixture.pdf").to have_same_content_of file: output_pdf
        end
      end

      context "when there isn't ISSQN" do
        let(:xml_file) { File.read("#{base_dir}without_issqn.xml") }

        it 'renders xml to the pdf' do
          expect(File.exist?(output_pdf)).to be_falsey
          subject.save_pdf output_pdf

          expect("#{base_dir}without_issqn.fixture.pdf").to have_same_content_of file: output_pdf
        end
      end

      context 'when there is footer information' do
        let(:xml_file) { File.read("#{base_dir}with_footer.xml") }

        it 'renders xml to the pdf' do
          expect(File.exist?(output_pdf)).to be_falsey

          footer = 'Gerado através do Teste'
          subject.save_pdf output_pdf, footer

          expect("#{base_dir}with_footer.fixture.pdf").to have_same_content_of file: output_pdf
        end
      end
    end

    context 'when there is more than one xml' do
      let(:base_dir) { './spec/fixtures/nfe/v3.10/' }
      let(:xml_file) { File.read("#{base_dir}nfe_simples_nacional.xml") }

      before { FileUtils.rm_f(output_pdf) }

      it 'renders multiple danfes on the same pdf' do
        expect(File.exist?(output_pdf)).to be_falsey
        subject = described_class.new([xml, xml])

        subject.save_pdf(output_pdf)

        expect("#{base_dir}multiples.xmls.on.the.same.pdf.pdf").to have_same_content_of file: output_pdf
      end
    end
  end

  describe 'NT 2026.010 layout' do
    let(:base_dir) { './spec/fixtures/nfe/v4.00/' }
    let(:xml_file) { File.read("#{base_dir}#{fixture}.xml") }
    let(:pdf_text) { PDF::Inspector::Text.analyze(subject.render_pdf).strings.join("\n") }

    before { FileUtils.rm_f(output_pdf) }

    context 'when a Simples Nacional NF-e was issued before 01/12/2026' do
      let(:fixture) { 'rtc_simples_nacional_before_start_date' }

      it 'keeps the current layout' do
        expect(pdf_text).not_to include('CÓDIGO DO REGIME TRIBUTÁRIO', 'TOTAL DO IBS / CBS / IS', 'BASES DE CÁLCULO')
      end

      it 'renders xml to the pdf' do
        subject.save_pdf output_pdf

        expect("#{base_dir}#{fixture}.xml.fixture.pdf").to have_same_content_of file: output_pdf
      end
    end

    context 'when a Simples Nacional NF-e without IBS/CBS was issued from 01/12/2026' do
      let(:fixture) { 'rtc_simples_nacional' }

      it 'renders the tax regime and the IBS/CBS totals in blank' do
        expect(pdf_text).to include(
          "CÓDIGO DO REGIME TRIBUTÁRIO\n1 - SIMPLES NACIONAL",
          "TOTAL DO IBS / CBS / IS\nVALOR DA CBS\nVALOR DO IBS UF\nVALOR DO IBS MUNICÍPIO\nVALOR DO IMPOSTO SELETIVO\n"
        )
      end

      it 'renders xml to the pdf' do
        subject.save_pdf output_pdf

        expect("#{base_dir}#{fixture}.xml.fixture.pdf").to have_same_content_of file: output_pdf
      end
    end

    context 'when a Regime Normal NF-e has IBS, CBS and IS' do
      let(:fixture) { 'rtc_regime_normal' }

      it 'renders the tax regime and the IBS/CBS/IS totals' do
        expect(pdf_text).to include(
          "CÓDIGO DO REGIME TRIBUTÁRIO\n3 - REGIME NORMAL",
          "VALOR DA CBS\n19,98\nVALOR DO IBS UF\n2,22\nVALOR DO IBS MUNICÍPIO\n0,00\nVALOR DO IMPOSTO SELETIVO\n18,00"
        )
      end

      it 'renders the items with the NT 2026.010 columns' do
        expect(pdf_text).to include(
          "BASES DE CÁLCULO\nALÍQUOTAS\nVALOR DOS TRIBUTOS", '[cClassTrib 200003]', "CBS\n0,36%", "IS\n4,00%"
        )
      end

      it 'renders xml to the pdf' do
        subject.save_pdf output_pdf

        expect("#{base_dir}#{fixture}.xml.fixture.pdf").to have_same_content_of file: output_pdf
      end
    end

    context 'when a Regime Normal NF-e has FCP, DIFAL and monophasic taxes' do
      let(:fixture) { 'rtc_regime_normal_with_fcp_difal_and_monophasic' }

      it 'renders the FCP, DIFAL and monophasic totals' do
        expect(pdf_text).to include(
          "VALOR DO FCP\n24,00", "VALOR DO DIFAL NA UF DE DESTINO\n45,00", "VALOR DO ICMS MONOFÁSICO\n112,00",
          "VALOR DO IBS MONOFÁSICO\n1,00"
        )
      end

      it 'keeps the DIFAL in the complementary information' do
        expect(pdf_text).to include('Valores totais do ICMS Interestadual')
      end

      it 'renders xml to the pdf' do
        subject.save_pdf output_pdf

        expect("#{base_dir}#{fixture}.xml.fixture.pdf").to have_same_content_of file: output_pdf
      end
    end
  end
end
