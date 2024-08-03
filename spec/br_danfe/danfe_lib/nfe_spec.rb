require 'spec_helper'

describe BrDanfe::DanfeLib::Nfe do
  let(:output_pdf) { "#{base_dir}output.pdf" }
  let(:xml_file) {}
  let(:xml) { BrDanfe::XML.new(xml_file) }

  subject { described_class.new [xml] }

  describe '#render_pdf' do
    let(:base_dir) { './spec/fixtures/nfe/v3.10/' }
    let(:xml_file) { File.read("#{base_dir}nfe_simples_nacional.xml") }

    it 'renders a Simples Nacional NF-e using CSOSN' do
      expected = IO.binread("#{base_dir}nfe_simples_nacional.xml.fixture.pdf")
      expect(subject.render_pdf).to eq expected
    end

    context 'with cancellation event' do
      let(:xml_file) { File.read("#{base_dir}nfe_simples_nacional_authorized.xml") }
      let(:xml_event_file) { File.read("#{base_dir}nfe_simples_nacional_cancellation_event.xml") }
      let(:xml_event) { BrDanfe::XML.new(xml_event_file) }

      subject { described_class.new [xml, xml_event] }

      it 'renders a canceled Simples Nacional NF-e using CSOSN' do
        expected = IO.binread("#{base_dir}nfe_simples_nacional_cancellation_event.xml.fixture.pdf")
        expect(subject.render_pdf).to eq expected
      end
    end
  end

  describe '#save_pdf' do
    context 'when danfe has custom options' do
      let(:base_dir) { './spec/fixtures/nfe/v2.00/' }
      let(:xml_file) { File.read("#{base_dir}custom_options.fixture.xml") }

      before { File.delete(output_pdf) if File.exist?(output_pdf) }

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

      before { File.delete(output_pdf) if File.exist?(output_pdf) }

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
    end

    context "when xml's version is v3.10" do
      let(:base_dir) { './spec/fixtures/nfe/v3.10/' }
      let(:xml_file) { File.read("#{base_dir}nfe_simples_nacional.xml") }

      before { File.delete(output_pdf) if File.exist?(output_pdf) }

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

        context 'with cancellation event' do
          let(:xml_file) { File.read("#{base_dir}with_three_pages_authorized.xml") }
          let(:xml_event_file) { File.read("#{base_dir}with_three_pages_cancellation_event.xml") }
          let(:xml_event) { BrDanfe::XML.new(xml_event_file) }

          subject { described_class.new [xml, xml_event] }

          it 'renders xml to the pdf' do
            expect(File.exist?(output_pdf)).to be_falsey
            subject.save_pdf output_pdf

            expect("#{base_dir}with_three_pages_canceled.fixture.pdf").to have_same_content_of file: output_pdf
          end
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

      let(:xml_file2) { File.read("#{base_dir}nfe_simples_nacional_authorized.xml") }
      let(:xml2) { BrDanfe::XML.new(xml_file2) }

      let(:xml_file2_event) { File.read("#{base_dir}nfe_simples_nacional_cancellation_event.xml") }
      let(:xml2_event) { BrDanfe::XML.new(xml_file2_event) }

      before { File.delete(output_pdf) if File.exist?(output_pdf) }

      it 'renders multiple danfes on the same pdf' do
        expect(File.exist?(output_pdf)).to be_falsey
        subject = described_class.new([xml, xml2, xml2_event])

        subject.save_pdf(output_pdf)

        expect("#{base_dir}multiples.xmls.on.the.same.pdf.pdf").to have_same_content_of file: output_pdf
      end
    end
  end
end
