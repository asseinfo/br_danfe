require 'spec_helper'

describe BrDanfe::DanfeLib::NfeLib::InfadicVol do
  let(:base_dir) { './spec/fixtures/nfe/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }
  let(:pdf) { BrDanfe::DanfeLib::NfeLib::Document.new }
  let(:xml) { BrDanfe::XML.new(xml_as_string) }

  subject { described_class.new(xml, pdf) }

  describe '#render' do
    let(:xml_as_string) do
      <<~XML
        <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
          <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
            <dest>
            <CNPJ>82743287000880</CNPJ>
            <xNome>Schneider Electric Brasil Ltda</xNome>
            <enderDest>
              <xLgr>Av da Saudade</xLgr>
              <nro>1125</nro>
              <xBairro>Frutal</xBairro>
              <xCpl>Em anexo ao super mercado maior do bairro</xCpl>
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
            <transp>
              <vol>
                <qVol>1</qVol>
                <esp>VOLUMES 1</esp>
                <marca>DIVERSOS 1</marca>
                <nVol>1</nVol>
                <pesoL>1000.000</pesoL>
                <pesoB>1100.000</pesoB>
              </vol>
              <vol>
                <qVol>2</qVol>
                <esp>VOLUMES 2</esp>
                <marca>DIVERSOS 2</marca>
                <nVol>2</nVol>
                <pesoL>2000.000</pesoL>
                <pesoB>2200.000</pesoB>
              </vol>
              <vol>
                <qVol>3</qVol>
                <esp>VOLUMES 3</esp>
                <marca>DIVERSOS 3</marca>
                <nVol>3</nVol>
                <pesoL>3000.000</pesoL>
                <pesoB>3300.000</pesoB>
              </vol>
              <vol>
                <qVol>4</qVol>
                <esp>VOLUMES 4</esp>
                <marca>DIVERSOS 4</marca>
                <nVol>4</nVol>
                <pesoL>4000.000</pesoL>
                <pesoB>4400.000</pesoB>
              </vol>
            </transp>
            <infAdic>
              <infCpl>Uma observação</infCpl>
            </infAdic>
            <ICMSTot>
              <vFCPUFDest>4892.78</vFCPUFDest>
              <vICMSUFDest>2915.78</vICMSUFDest>
              <vICMSUFRemet>75394.78</vICMSUFRemet>
            </ICMSTot>
          </infNFe>
        </NFe>
      XML
    end

    before do
      subject.render
      File.delete(output_pdf) if File.exist?(output_pdf)
    end

    it 'renders extra volumes to the pdf' do
      expect(File.exist?(output_pdf)).to be_falsey

      pdf.render_file output_pdf

      expect("#{base_dir}infadic_vol#render-extra_volume.pdf").to have_same_content_of file: output_pdf
    end
  end
end
