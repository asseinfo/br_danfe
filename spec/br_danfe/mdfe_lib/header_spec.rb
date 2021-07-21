require 'spec_helper'

describe BrDanfe::MdfeLib::Header do
  let(:xml_as_string) do
    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <mdfeProc xmlns="http://www.portalfiscal.inf.br/mdfe" versao="3.00">
        <MDFe xmlns="http://www.portalfiscal.inf.br/mdfe">
          <infMDFe Id="MDFe32210717781119000141580010000001211000000003" versao="3.00">
            <ide>
              <mod>58</mod>
              <serie>1</serie>
              <nMDF>121</nMDF>
              <cMDF>00000000</cMDF>
              <dhEmi>2021-07-01T17:30:00-03:00</dhEmi>
              <UFIni>ES</UFIni>
              <UFFim>ES</UFFim>
            </ide>
            <emit>
              <CNPJ>17781119000141</CNPJ>
              <IE>082942625</IE>
              <xNome>VENTURIM AGROCRIATIVA LTDA EPP</xNome>
              <xFant>VENTURIM CONSERVAS</xFant>
              <enderEmit>
                <xLgr>RODOVIA ES 473 KM 13</xLgr>
                <nro>0</nro>
                <cMun>3205069</cMun>
                <xMun>VENDA NOVA DO IMIGRANTE</xMun>
                <CEP>29375000</CEP>
                <UF>ES</UF>
              </enderEmit>
            </emit>
          </infMDFe>
          <infMDFeSupl>
            <qrCodMDFe>https://dfe-portal.svrs.rs.gov.br/mdfe/QRCode?chMDFe=32210717781119000141580010000001211000000003&amp;tpAmb=1</qrCodMDFe>
          </infMDFeSupl>
        </MDFe>
      </mdfeProc>
    XML
  end

  let(:pdf) { BrDanfe::MdfeLib::Document.new }
  let(:xml) { BrDanfe::XML.new(xml_as_string) }

  let(:base_dir) { './spec/fixtures/mdfe/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:logo_dimensions) { { width: 100, height: 100 } }
  let(:logo) { 'spec/fixtures/logo.png' }

  subject { described_class.new(pdf, xml, logo, logo_dimensions) }

  let(:pdf_text) do
    PDF::Inspector::Text.analyze(pdf.render).strings.join("\n")
  end

  after { File.delete(output_pdf) if File.exist?(output_pdf) }

  describe '#generate' do
    it 'generates the emitter informations' do
      emitter_name = 'VENTURIM AGROCRIATIVA LTDA EPP'
      emitter_address = "RODOVIA ES 473 KM 13, nº 0\nVENDA NOVA DO IMIGRANTE - ES   CEP 29.375-000"

      emitter_cnpj = "CNPJ: \n17781119000141"
      emitter_ie = "IE: \n082942625"

      subject.generate

      expect(pdf_text).to include emitter_name
      expect(pdf_text).to include emitter_address
      expect(pdf_text).to include emitter_cnpj
      expect(pdf_text).to include emitter_ie
    end

    it'generates the DAMDFE title' do
      title = "DAMDFE\n - Documento Auxiliar de Manifesto Eletrônico de Documentos Fiscais"

      subject.generate

      expect(pdf_text).to include title
    end

    it 'generates the qr code' do
      expect(File.exist?(output_pdf)).to be false

      subject.generate
      pdf.render_file output_pdf

      expect("#{base_dir}header#render-qr-code.pdf").to have_same_content_of file: output_pdf
    end

    it 'generates the company CNPJ' do
      cnpj = "CNPJ: \n17781119000141"

      subject.generate

      expect(pdf_text).to include cnpj
    end

    describe 'logo' do
      context 'with logo' do
        it 'generates the logo' do
          expect(File.exist?(output_pdf)).to be false

          subject.generate
          pdf.render_file output_pdf

          expect("#{base_dir}header#render-with_logo.pdf").to have_same_content_of file: output_pdf
        end
      end

      context 'without logo' do
        let(:logo) { '' }

        it 'does not generate the logo' do
          expect(File.exist?(output_pdf)).to be false

          subject.generate
          pdf.render_file output_pdf

          expect("#{base_dir}header#render-without_logo.pdf").to have_same_content_of file: output_pdf
        end
      end
    end
  end
end
