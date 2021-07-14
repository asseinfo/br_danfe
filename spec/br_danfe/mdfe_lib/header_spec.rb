require 'spec_helper'

describe BrDanfe::MdfeLib::Header do
  let(:xml_as_string) do
    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <mdfeProc xmlns="http://www.portalfiscal.inf.br/mdfe" versao="3.00">
        <MDFe xmlns="http://www.portalfiscal.inf.br/mdfe">
          <infMDFe Id="MDFe32210717781119000141580010000001211000000003" versao="3.00">
            <ide>
              <cUF>32</cUF>
              <tpAmb>1</tpAmb>
              <tpEmit>2</tpEmit>
              <mod>58</mod>
              <serie>1</serie>
              <nMDF>121</nMDF>
              <cMDF>00000000</cMDF>
              <cDV>3</cDV>
              <modal>1</modal>
              <dhEmi>2021-07-01T17:30:00-03:00</dhEmi>
              <tpEmis>1</tpEmis>
              <procEmi>0</procEmi>
              <verProc>hivelog-mdfe-0.1.0</verProc>
              <UFIni>ES</UFIni>
              <UFFim>ES</UFFim>
              <infMunCarrega>
                <cMunCarrega>3205069</cMunCarrega>
                <xMunCarrega>VENDA NOVA DO IMIGRANTE</xMunCarrega>
              </infMunCarrega>
              <dhIniViagem>2021-07-01T17:30:00-03:00</dhIniViagem>
            </ide>
            <emit>
              <CNPJ>17781119000141</CNPJ>
              <IE>082942625</IE>
              <xNome>VENTURIM AGROCRIATIVA LTDA EPP</xNome>
              <xFant>VENTURIM CONSERVAS</xFant>
              <enderEmit>
                <xLgr>RODOVIA ES 473 KM 13</xLgr>
                <nro>0</nro>
                <xCpl>ZONA RURAL</xCpl>
                <xBairro>SAO JOAO DE VICOSA</xBairro>
                <cMun>3205069</cMun>
                <xMun>VENDA NOVA DO IMIGRANTE</xMun>
                <CEP>29375000</CEP>
                <UF>ES</UF>
                <fone>2835466272</fone>
                <email>VENTURIMCONSERVAS@GMAIL.COM</email>
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

  describe '#render' do
    it 'renders the emitter informations' do
      emitter_name = 'VENTURIM AGROCRIATIVA LTDA EPP'
      emitter_address = "RODOVIA ES 473 KM 13, nº 0\nVENDA NOVA DO IMIGRANTE - ES   CEP 29.375-000"

      # TODO: verificar o \n, isso acontece quando colocamos a tag <b>, o inspector do pdf acha que é uma quebra de linha
      emitter_cnpj = "CNPJ: \n17781119000141"
      emitter_ie = "IE: \n082942625"

      subject.render

      expect(pdf_text).to include emitter_name
      expect(pdf_text).to include emitter_address
      expect(pdf_text).to include emitter_cnpj
      expect(pdf_text).to include emitter_ie
    end

    it'renders the DAMDFE title' do
      title = "DAMDFE\n - Documento Auxiliar de Manifesto Eletrônico de Documentos Fiscais"

      subject.render

      expect(pdf_text).to include title
    end

    it 'renders the qr code' do
      expect(File.exist?(output_pdf)).to be_falsey

      subject.render
      pdf.render_file output_pdf

      expect("#{base_dir}header#render-qr-code.pdf").to have_same_content_of file: output_pdf
    end

    describe 'logo' do
      context 'with logo' do
        it 'renders the logo' do
          expect(File.exist?(output_pdf)).to be_falsey

          subject.render
          pdf.render_file output_pdf

          expect("#{base_dir}header#render-with_logo.pdf").to have_same_content_of file: output_pdf
        end
      end

      context 'without logo' do
        let(:logo) { '' }

        it 'does not render the logo' do
          expect(File.exist?(output_pdf)).to be_falsey

          subject.render
          pdf.render_file output_pdf

          expect("#{base_dir}header#render-without_logo.pdf").to have_same_content_of file: output_pdf
        end
      end
    end
  end
end
