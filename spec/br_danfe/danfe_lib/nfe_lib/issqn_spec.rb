require 'spec_helper'

describe BrDanfe::DanfeLib::NfeLib::Issqn do
  let(:base_dir) { './spec/fixtures/nfe/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:pdf) { BrDanfe::DanfeLib::NfeLib::Document.new }
  let(:xml) { BrDanfe::XML.new(xml_as_string) }

  subject { described_class.new(pdf, xml) }

  describe '#initialize' do
    let(:xml_as_string) do
      <<~XML
        <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
          <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
            <emit>
              <IM>2345</IM>
            </emit>
            <total>
              <ISSQNtot>
              #{issqn}
              </ISSQNtot>
            </total>
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

    let(:issqn) do
      <<~XML
        <vServ>1.43</vServ>
        <vBC>2.34</vBC>
        <vISS>3.45</vISS>
      XML
    end

    context 'when Entrega.delivery_local? returns true' do
      before do
        allow(BrDanfe::DanfeLib::NfeLib::Entrega).to receive(:delivery_local?).and_return(true)
      end

      it 'sets @y_position to 29.24' do
        expect(subject.y_position).to eq(29.24)
      end
    end

    context 'when Entrega.delivery_local? returns false' do
      before do
        allow(BrDanfe::DanfeLib::NfeLib::Entrega).to receive(:delivery_local?).and_return(false)
      end

      it 'sets @y_position to 26.24' do
        expect(subject.y_position).to eq(26.24)
      end
    end
  end

  describe '#render' do
    let(:xml_as_string) do
      <<~XML
        <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
          <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
            <emit>
              <IM>2345</IM>
            </emit>
            <total>
              <ISSQNtot>
              #{issqn}
              </ISSQNtot>
            </total>
          </infNFe>
        </NFe>
      XML
    end

    let(:issqn) do
      <<~XML
        <vServ>1.43</vServ>
        <vBC>2.34</vBC>
        <vISS>3.45</vISS>
      XML
    end

    before do
      subject.render
      File.delete(output_pdf) if File.exist?(output_pdf)
    end

    context 'with ISSQN' do
      it 'renders xml to the pdf' do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}issqn#render-with_issqn.pdf").to have_same_content_of file: output_pdf
      end

      context 'when there is only one issqn value' do
        let(:issqn) { '<vServ>1.43</vServ>' }

        it 'renders xml to the pdf' do
          expect(File.exist?(output_pdf)).to be_falsey

          pdf.render_file output_pdf

          expect("#{base_dir}issqn#render-with_one_issqn_value.pdf").to have_same_content_of file: output_pdf
        end
      end
    end

    context 'without ISSQN' do
      let(:issqn) { '' }

      it 'renders xml to the pdf' do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}issqn#render-without_issqn.pdf").to have_same_content_of file: output_pdf
      end
    end
  end
end
