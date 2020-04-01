require 'spec_helper'

describe BrDanfe::DanfeLib::Document do
  let(:base_dir) { './spec/fixtures/nfe/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:xml) { BrDanfe::XML.new(xml_as_string) }

  describe '#lie' do
    before do
      subject.render
      File.delete(output_pdf) if File.exist?(output_pdf)
    end

    context 'when IE is valid' do
      let(:xml_as_string) do
        <<-eos
        <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
          <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
            <transp>
              <transporta>
                <IE>964508990089</IE>
                <UF>SP</UF>
              </transporta>
            </transp>
          </infNFe>
        </NFe>
        eos
      end

      it 'renders a box with a formated IE to the pdf' do
        expect(File.exist?(output_pdf)).to be_falsey

        subject.lie 0.80, 3.94, 0.75, 1.85, xml, 'transporta/UF', 'transporta/IE'
        subject.render_file output_pdf

        expect("#{base_dir}document#lie-valid.pdf").to have_same_content_of file: output_pdf
      end
    end

    context 'when IE is invalid' do
      let(:xml_as_string) do
        <<-eos
        <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
          <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
            <transp>
              <transporta>
                <IE>123</IE>
                <UF>SC</UF>
              </transporta>
            </transp>
          </infNFe>
        </NFe>
        eos
      end

      it 'renders a blank box to the pdf' do
        expect(File.exist?(output_pdf)).to be_falsey

        subject.lie 0.80, 3.94, 0.75, 1.85, xml, 'transporta/UF', 'transporta/IE'
        subject.render_file output_pdf

        expect("#{base_dir}document#lie-invalid.pdf").to have_same_content_of file: output_pdf
      end
    end

    context 'when IE is blank' do
      let(:xml_as_string) do
        <<-eos
        <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
          <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
            <transp>
              <transporta>
              </transporta>
            </transp>
          </infNFe>
        </NFe>
        eos
      end

      it 'renders a blank box to the pdf' do
        expect(File.exist?(output_pdf)).to be_falsey

        subject.lie 0.80, 3.94, 0.75, 1.85, xml, 'transporta/UF', 'transporta/IE'
        subject.render_file output_pdf

        expect("#{base_dir}document#lie-blank.pdf").to have_same_content_of file: output_pdf
      end

      context 'when UF is invalid' do
        let(:xml_as_string) do
          <<-eos
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
              <transp>
                <transporta>
                  <UF>SC</UF>
                </transporta>
              </transp>
            </infNFe>
          </NFe>
          eos
        end

        it 'renders a blank box to the pdf' do
          expect(File.exist?(output_pdf)).to be_falsey

          subject.lie 0.80, 3.94, 0.75, 1.85, xml, 'transporta/UF', 'transporta/IE'
          subject.render_file output_pdf

          expect("#{base_dir}document#lie-blank-uf-invalid.pdf").to have_same_content_of file: output_pdf
        end
      end
    end
  end

  describe '#lcnpj' do
    before do
      subject.render
      File.delete(output_pdf) if File.exist?(output_pdf)
    end

    context 'when CNPJ is valid' do
      let(:xml_as_string) do
        <<-eos
        <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
          <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
            <transp>
              <transporta>
                <CNPJ>71434064000149</CNPJ>
              </transporta>
            </transp>
          </infNFe>
        </NFe>
        eos
      end

      it 'renders a box with a formated CNPJ to the pdf' do
        expect(File.exist?(output_pdf)).to be_falsey

        subject.lcnpj 0.80, 3.94, 0.75, 1.85, xml, 'transporta/CNPJ'
        subject.render_file output_pdf

        expect("#{base_dir}document#lcnpj-valid.pdf").to have_same_content_of file: output_pdf
      end
    end

    context 'when CNPJ is invalid' do
      let(:xml_as_string) do
        <<-eos
        <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
          <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
            <transp>
              <transporta>
                <CNPJ>714</CNPJ>
              </transporta>
            </transp>
          </infNFe>
        </NFe>
        eos
      end

      it 'renders a blank box to the pdf' do
        expect(File.exist?(output_pdf)).to be_falsey

        subject.lcnpj 0.80, 3.94, 0.75, 1.85, xml, 'transporta/CNPJ'
        subject.render_file output_pdf

        expect("#{base_dir}document#lcnpj-invalid.pdf").to have_same_content_of file: output_pdf
      end
    end

    context 'when CNPJ is blank' do
      let(:xml_as_string) do
        <<-eos
        <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
          <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
            <transp>
              <transporta>
              </transporta>
            </transp>
          </infNFe>
        </NFe>
        eos
      end

      it 'renders a blank box to the pdf' do
        expect(File.exist?(output_pdf)).to be_falsey

        subject.lcnpj 0.80, 3.94, 0.75, 1.85, xml, 'transporta/CNPJ'
        subject.render_file output_pdf

        expect("#{base_dir}document#lcnpj-blank.pdf").to have_same_content_of file: output_pdf
      end
    end
  end
end
