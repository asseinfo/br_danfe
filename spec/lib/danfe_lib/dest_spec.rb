require "spec_helper"

describe BrDanfe::DanfeLib::Dest do
  let(:base_dir) { "./spec/fixtures/nfe/lib/" }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:pdf) { BrDanfe::DanfeLib::Document.new }
  let(:xml) { BrDanfe::DanfeLib::XML.new(xml_as_string) }

  subject { described_class.new(pdf, xml) }

  describe "#render" do
    before do
      subject.render
      File.delete(output_pdf) if File.exist?(output_pdf)
    end

    context "when nf-e's version is 2.00" do
      let(:xml_as_string) do
        <<-eos
        <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
          <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
            <ide>
              <dEmi>2011-10-29</dEmi>
              <dSaiEnt>2011-10-30</dSaiEnt>
              <hSaiEnt>15:32:45</hSaiEnt>
            </ide>
            <dest>
              <CNPJ>82743287000880</CNPJ>
              <xNome>Schneider Electric Brasil Ltda</xNome>
              <enderDest>
                <xLgr>Av da Saudade</xLgr>
                <nro>1125</nro>
                <xBairro>Frutal</xBairro>
                <xCpl>Sala 01 e 02</xCpl>
                <cMun>3552403</cMun>
                <xMun>SUMARE</xMun>
                <UF>SP</UF>
                <CEP>13171320</CEP>
                <cPais>1058</cPais>
                <xPais>BRASIL</xPais>
                <fone>1921046300</fone>
              </enderDest>
              <IE>671008375110</IE>
            </dest>
          </infNFe>
        </NFe>
        eos
      end

      it "renders xml to the pdf" do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}dest#render-v2.00.pdf").to have_same_content_of file: output_pdf
      end
    end

    context "when nf-e's version is 3.10" do
      let(:xml_as_string) do
        <<-eos
        <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
          <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="3.10">
            <ide>
              <dhEmi>2011-10-29T13:02:59+00:00</dhEmi>
              <dhSaiEnt>2011-10-30T12:32:45-03:00</dhSaiEnt>
            </ide>
            <dest>
              <CNPJ>82743287000880</CNPJ>
              <xNome>Schneider Electric Brasil Ltda</xNome>
              <enderDest>
                <xLgr>Av da Saudade</xLgr>
                <nro>1125</nro>
                <xBairro>Frutal</xBairro>
                <xCpl>Sala 01 e 02</xCpl>
                <cMun>3552403</cMun>
                <xMun>SUMARE</xMun>
                <UF>SP</UF>
                <CEP>13171320</CEP>
                <cPais>1058</cPais>
                <xPais>BRASIL</xPais>
                <fone>1921046300</fone>
              </enderDest>
              <IE>671008375110</IE>
            </dest>
          </infNFe>
        </NFe>
        eos
      end

      it "renders xml to the pdf" do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}dest#render-v3.10.pdf").to have_same_content_of file: output_pdf
      end
    end

    context "when recipient has CNPJ" do
      let(:xml_as_string) do
        <<-eos
        <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
          <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="3.10">
            <dest>
              <CNPJ>71058884000183</CNPJ>
            </dest>
          </infNFe>
        </NFe>
        eos
      end

      it "renders xml to the pdf" do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}dest#render-with_cnpj.pdf").to have_same_content_of file: output_pdf
      end
    end

    context "when recipient has CPF" do
      let(:xml_as_string) do
        <<-eos
        <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
          <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="3.10">
            <dest>
              <CPF>48532557457</CPF>
            </dest>
          </infNFe>
        </NFe>
        eos
      end

      it "renders xml to the pdf" do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}dest#render-with_cpf.pdf").to have_same_content_of file: output_pdf
      end
    end

    context "when recipient has IE" do
      let(:xml_as_string) do
        <<-eos
        <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
          <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="3.10">
            <dest>
              <enderDest>
                <UF>SP</UF>
              </enderDest>
              <IE>671008375110</IE>
            </dest>
          </infNFe>
        </NFe>
        eos
      end

      it "renders xml to the pdf" do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}dest#render-with_ie.pdf").to have_same_content_of file: output_pdf
      end
    end

    context "when recipient doesn't have address complement" do
      let(:xml_as_string) do
        <<-eos
        <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
          <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="3.10">
            <ide>
              <dhEmi>2011-10-29T13:02:59+00:00</dhEmi>
              <dhSaiEnt>2011-10-30T12:32:45-03:00</dhSaiEnt>
            </ide>
            <dest>
              <CNPJ>82743287000880</CNPJ>
              <xNome>Schneider Electric Brasil Ltda</xNome>
              <enderDest>
                <xLgr>Av da Saudade</xLgr>
                <nro>1125</nro>
                <xBairro>Frutal</xBairro>
                <cMun>3552403</cMun>
                <xMun>SUMARE</xMun>
                <UF>SP</UF>
                <CEP>13171320</CEP>
                <cPais>1058</cPais>
                <xPais>BRASIL</xPais>
                <fone>1921046300</fone>
              </enderDest>
              <IE>671008375110</IE>
            </dest>
          </infNFe>
        </NFe>
        eos
      end

      it "renders xml to the pdf" do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}dest#render-without-address-complement.pdf").to have_same_content_of file: output_pdf
      end
    end

    context "when recipient address (xLgr + nro + xCpl) has more than 63 characters" do
      let(:xml_as_string) do
        <<-eos
        <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
          <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="3.10">
            <ide>
              <dhEmi>2011-10-29T13:02:59+00:00</dhEmi>
              <dhSaiEnt>2011-10-30T12:32:45-03:00</dhSaiEnt>
            </ide>
            <dest>
              <CNPJ>82743287000880</CNPJ>
              <xNome>Schneider Electric Brasil Ltda</xNome>
              <enderDest>
                <xLgr>Rua do governo do estado</xLgr>
                <nro>1125</nro>
                <xCpl>Em anexo ao super mercado maior do bairro</xCpl>
                <xBairro>Frutal</xBairro>
                <cMun>3552403</cMun>
                <xMun>SUMARE</xMun>
                <UF>SP</UF>
                <CEP>13171320</CEP>
                <cPais>1058</cPais>
                <xPais>BRASIL</xPais>
                <fone>1921046300</fone>
              </enderDest>
              <IE>671008375110</IE>
            </dest>
          </infNFe>
        </NFe>
        eos
      end

      it "it renders xml to pdf trimming the address of after 63 characters" do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}dest#render-with-address-bigger.pdf").to have_same_content_of file: output_pdf
      end
    end
  end
end
