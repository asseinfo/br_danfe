require 'spec_helper'

describe BrDanfe::DanfeLib::NfceLib::Header do
  let(:base_dir) { './spec/fixtures/nfce/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }
  let(:logo) { './spec/fixtures/logo.png' }
  let(:logo_options) { { width: 100, height: 100 } }
  let(:environment) { 1 }

  let(:xml) do
    xml = <<~XML
      <nfeProc>
        <NFe>
          <infNFe>
            <ide>
              <tpAmb>#{environment}</tpAmb>
            </ide>
            <emit>
              <CNPJ>10845180000166</CNPJ>
              <xNome>#{company_name}</xNome>
              <xFant>Empresa teste</xFant>
              <enderEmit>
                <xLgr>R GEREMIAS EUGENIO DA SILVA</xLgr>
                <nro>85</nro>
                <xBairro>SERRARIA</xBairro>
                <cMun>4202859</cMun>
                <xMun>BRACO DO TROMBUDO</xMun>
                <UF>SC</UF>
                <CEP>88113160</CEP>
                <cPais>1058</cPais>
                <xPais>Brasil</xPais>
                <fone>4832579854</fone>
              </enderEmit>
              <IE>255916191</IE>
              <CRT>1</CRT>
            </emit>
          </infNFe>
        </NFe>
      </nfeProc>
    XML

    BrDanfe::XML.new(xml)
  end

  let(:pdf) { BrDanfe::DanfeLib::NfceLib::Document.new(8.cm, 6.cm) }

  subject { described_class.new pdf, xml, logo, logo_options }

  describe '#render' do
    before do
      subject.render
      File.delete(output_pdf) if File.exist?(output_pdf)
    end

    after { File.delete(output_pdf) if File.exist?(output_pdf) }

    context 'when has a short name' do
      let(:company_name) { 'Test company' }

      context 'when has a logo' do
        it 'renders header to the pdf' do
          expect(File.exist?(output_pdf)).to be_falsey
          pdf.render_file output_pdf

          expect("#{base_dir}header#render-short_name_with_logo.pdf").to have_same_content_of file: output_pdf
        end
      end

      context 'when does not have a logo' do
        let(:logo) { nil }
        let(:logo_options) { nil }

        it 'renders header to the pdf' do
          expect(File.exist?(output_pdf)).to be_falsey
          pdf.render_file output_pdf

          expect("#{base_dir}header#render-short_name_without_logo.pdf").to have_same_content_of file: output_pdf
        end
      end
    end

    context 'when has a long name' do
      let(:company_name) { 'Test company with some very long name to do a line break' }

      context 'when has a logo' do
        it 'renders the header with company name line breaked and shrinked to fit' do
          expect(File.exist?(output_pdf)).to be_falsey
          pdf.render_file output_pdf

          expect("#{base_dir}header#render-long_name_with_logo.pdf").to have_same_content_of file: output_pdf
        end
      end

      context 'when does not have a logo' do
        let(:logo) { nil }
        let(:logo_options) { nil }

        it 'renders header to the pdf' do
          expect(File.exist?(output_pdf)).to be_falsey
          pdf.render_file output_pdf

          expect("#{base_dir}header#render-long_name_without_logo.pdf").to have_same_content_of file: output_pdf
        end
      end
    end

    context 'when the environment is homologation' do
      let(:environment) { 2 }
      let(:company_name) { 'Homologation example' }

      it 'renders homologation label' do
        expect(File.exist?(output_pdf)).to be_falsey
        pdf.render_file output_pdf

        expect("#{base_dir}header#render-homologation.pdf").to have_same_content_of file: output_pdf
      end
    end
  end
end
