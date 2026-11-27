require 'spec_helper'

describe BrDanfe::DanfeLib::NfeLib::Issqn do
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
      FileUtils.rm_f(output_pdf)
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

    describe 'with entrega' do
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

      it 'renders xml to the pdf' do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}issqn#render-with_entrega.pdf").to have_same_content_of file: output_pdf
      end

      it 'keeps the ISSQN above the complementary information' do
        expect(subject.y_position).to eql 26.24
      end
    end
  end

  describe 'NT 2026.010 layout' do
    let(:issued_at) { '2026-12-02T10:00:00-03:00' }
    let(:entrega) { '' }
    let(:issqn) { '<vServ>100.00</vServ><vBC>100.00</vBC><vISS>5.00</vISS>' }
    let(:xml_as_string) do
      <<~XML
        <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
          <infNFe versao="4.00">
            <ide><dhEmi>#{issued_at}</dhEmi></ide>
            #{entrega}
            <total><ISSQNtot>#{issqn}</ISSQNtot></total>
          </infNFe>
        </NFe>
      XML
    end

    let(:transporter_position) { 16.41 }
    let(:tax_regime_line) { 0.8 }
    let(:ibscbs_block) { 1.32 }

    describe '#y_position' do
      it 'is below the IBS/CBS/IS block, at the transporter position' do
        expect(subject.y_position).to eql transporter_position + tax_regime_line + 0.0 + ibscbs_block
      end

      context 'with entrega' do
        let(:entrega) { '<entrega><xLgr>Rua Entrega</xLgr></entrega>' }

        it 'moves down with the delivery place' do
          expect(subject.y_position).to eql transporter_position + 3.0 + tax_regime_line + 0.0 + ibscbs_block
        end
      end

      context 'when the NF-e uses the current layout' do
        let(:issued_at) { '2026-11-20T10:00:00-03:00' }

        it 'is above the complementary information' do
          expect(subject.y_position).to eql 26.24
        end
      end
    end

    describe '.offset' do
      subject { described_class.offset(xml) }

      let(:line_height) { 0.8 }
      let(:space_between_blocks) { 0.52 }

      it 'is one line and the space before the next block' do
        expect(subject).to eql line_height + space_between_blocks
      end

      context 'when the NF-e has no ISSQN' do
        let(:issqn) { '<vServ>0.00</vServ><vBC>0.00</vBC><vISS>0.00</vISS>' }

        it('adds nothing') { is_expected.to eql 0.0 }
      end

      context 'when the NF-e uses the current layout' do
        let(:issued_at) { '2026-11-20T10:00:00-03:00' }

        it('adds nothing') { is_expected.to eql 0.0 }
      end
    end
  end
end
