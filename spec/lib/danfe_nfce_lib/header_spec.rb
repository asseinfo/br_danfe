require 'spec_helper'

describe BrDanfe::DanfeNfceLib::Header do
  let(:file_name) {}
  let(:base_dir) { './spec/fixtures/nfce/lib/' }
  let(:logo) { './spec/fixtures/logo.png' }
  let(:output_pdf) { "#{base_dir}#{file_name}.pdf" }
  let(:company_name) {}

  let(:xml) do
    xml = <<-eos
      <infNFe>
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
    eos

    BrDanfe::XML.new(xml)
  end

  let(:danfe) { BrDanfe::DanfeNfceLib::Document.new(8.cm, 5.cm) }

  before { File.delete(output_pdf) if File.exist?(output_pdf) }
  after { File.delete(output_pdf) if File.exist?(output_pdf) }

  context 'when have a short name' do
    let(:company_name) { 'Test company' }

    context 'when have a logo' do
      let(:file_name) { 'header_with_logo_and_short_name' }

      it 'renders the document' do
        expect(File.exist?(output_pdf)).to be_falsey

        subject = described_class.new(danfe, xml, logo, { width: 100, height: 100 })
        subject.render

        danfe.render_file output_pdf

        expect("#{base_dir}#{file_name}.fixture.pdf").to have_same_content_of file: output_pdf
      end
    end

    context 'when does not have a logo' do
      let(:file_name) { 'header_without_a_logo_and_short_name' }

      it 'renders the document' do
        expect(File.exist?(output_pdf)).to be_falsey

        subject = described_class.new(danfe, xml, nil, nil)
        subject.render

        danfe.render_file output_pdf

        expect("#{base_dir}#{file_name}.fixture.pdf").to have_same_content_of file: output_pdf
      end
    end
  end

  context 'when does have a long name' do
    let(:company_name) { 'Test company with some very long name to do a line break' }

    context 'when have a logo' do
      let(:file_name) { 'header_with_logo_and_long_name' }

      it 'renders the document with company name line breaked' do
        expect(File.exist?(output_pdf)).to be_falsey

        subject = described_class.new(danfe, xml, logo, { width: 100, height: 100 })
        subject.render

        danfe.render_file output_pdf

        expect("#{base_dir}#{file_name}.fixture.pdf").to have_same_content_of file: output_pdf
      end
    end

    context 'when does not have a logo' do
      let(:file_name) { 'header_without_a_logo_and_long_name' }

      it 'renders the document' do
        expect(File.exist?(output_pdf)).to be_falsey

        subject = described_class.new(danfe, xml, nil, nil)
        subject.render

        danfe.render_file output_pdf

        expect("#{base_dir}#{file_name}.fixture.pdf").to have_same_content_of file: output_pdf
      end
    end
  end
end
