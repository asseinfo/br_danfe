require 'spec_helper'

describe BrDanfe::DanfeLib::NfeLib::Icmstot do
  let(:base_dir) { './spec/fixtures/nfe/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:pdf) { BrDanfe::DanfeLib::NfeLib::Document.new }
  let(:xml) { BrDanfe::XML.new(xml_as_string) }

  subject { described_class.new(pdf, xml) }

  describe '#render' do
    let(:xml_as_string) do
      <<~XML
        <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
          <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
            <ICMSTot>
              <vBC>1.23</vBC>
              <vICMS>2.34</vICMS>
              <vBCST>3.45</vBCST>
              <vST>4.56</vST>
              <vProd>5.67</vProd>
              <vFrete>6.78</vFrete>
              <vSeg>7.89</vSeg>
              <vDesc>9.01</vDesc>
              <vIPI>0.12</vIPI>
              <vOutro>1.34</vOutro>
              <vNF>4.35</vNF>
            </ICMSTot>
          </infNFe>
        </NFe>
      XML
    end

    before do
      subject.render
      FileUtils.rm_f(output_pdf)
    end

    it 'renders xml to the pdf' do
      expect(File.exist?(output_pdf)).to be_falsey

      pdf.render_file output_pdf

      expect("#{base_dir}icmstot#render.pdf").to have_same_content_of file: output_pdf
    end

    describe 'with entrega' do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
              <ICMSTot>
                <vBC>1.23</vBC>
                <vICMS>2.34</vICMS>
                <vBCST>3.45</vBCST>
                <vST>4.56</vST>
                <vProd>5.67</vProd>
                <vFrete>6.78</vFrete>
                <vSeg>7.89</vSeg>
                <vDesc>9.01</vDesc>
                <vIPI>0.12</vIPI>
                <vOutro>1.34</vOutro>
                <vNF>4.35</vNF>
              </ICMSTot>
              <entrega>
                <CNPJ>82743287000880</CNPJ>
                <xNome>Schneider Electric Brasil Ltda</xNome>
                <xLgr>Av da Saudade</xLgr>
                <nro>1125</nro>
                <xBairro>Frutal</xBairro>
                <xCpl>Sala 01 e 02</xCpl>
                <cMun>3552403</cMun>
                <xMun>SUMARE</xMun>
                <UF>SP</UF>
                <CEP>13171320</CEP>
                <fone>1921046300</fone>
                <IE>671008375110</IE>
              </entrega>
            </infNFe>
          </NFe>
        XML
      end

      it 'renders xml to the pdf' do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}icmstot#render-with_entrega.pdf").to have_same_content_of file: output_pdf
      end
    end
  end
end
