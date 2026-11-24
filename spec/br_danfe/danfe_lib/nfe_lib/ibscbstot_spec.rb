require 'spec_helper'

describe BrDanfe::DanfeLib::NfeLib::Ibscbstot do
  let(:pdf) { BrDanfe::DanfeLib::NfeLib::Document.new }
  let(:xml) { BrDanfe::XML.new(xml_as_string) }
  let(:pdf_text) { PDF::Inspector::Text.analyze(pdf.render).strings.join("\n") }

  let(:issued_at) { '2026-12-02T10:00:00-03:00' }
  let(:totals) { '' }
  let(:xml_as_string) do
    <<~XML
      <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
        <infNFe versao="4.00">
          <ide><dhEmi>#{issued_at}</dhEmi></ide>
          <total>#{totals}</total>
        </infNFe>
      </NFe>
    XML
  end

  let(:ibscbs_totals) do
    <<~XML
      <ISTot><vIS>18.00</vIS></ISTot>
      <IBSCBSTot>
        <vBCIBSCBS>3075.00</vBCIBSCBS>
        <gIBS>
          <gIBSUF><vIBSUF>2.22</vIBSUF></gIBSUF>
          <gIBSMun><vIBSMun>0.00</vIBSMun></gIBSMun>
        </gIBS>
        <gCBS><vCBS>19.98</vCBS></gCBS>
      </IBSCBSTot>
    XML
  end

  describe '.offset' do
    subject { described_class.offset(xml) }

    context 'when the NF-e uses the new layout' do
      it { is_expected.to eql 1.32 }
    end

    context 'when the NF-e informs the monophasic IBS/CBS group' do
      let(:totals) do
        '<IBSCBSTot><gMono><vIBSMono>0.00</vIBSMono><vCBSMono>0.00</vCBSMono></gMono></IBSCBSTot>'
      end

      it { is_expected.to eql 2.12 }
    end

    context 'when the NF-e uses the current layout' do
      let(:issued_at) { '2026-11-20T10:00:00-03:00' }

      it { is_expected.to eql 0.0 }
    end
  end

  describe '#render' do
    before { described_class.new(pdf, xml).render }

    context 'when the NF-e has IBS, CBS and IS' do
      let(:totals) { ibscbs_totals }

      it 'renders the IBS, CBS and IS totals' do
        expect(pdf_text).to include(
          "TOTAL DO IBS / CBS / IS\nVALOR DA CBS\n19,98\nVALOR DO IBS UF\n2,22\nVALOR DO IBS MUNICÍPIO\n0,00\n" \
          "VALOR DO IMPOSTO SELETIVO\n18,00"
        )
      end

      it 'does not render the monophasic totals' do
        expect(pdf_text).not_to include('MONOFÁSIC')
      end
    end

    context 'when the NF-e has no IBS/CBS group' do
      it 'renders the totals in blank' do
        expect(pdf_text).to eql "TOTAL DO IBS / CBS / IS\nVALOR DA CBS\nVALOR DO IBS UF\n" \
                                "VALOR DO IBS MUNICÍPIO\nVALOR DO IMPOSTO SELETIVO"
      end
    end

    context 'when the NF-e informs the monophasic IBS/CBS group' do
      let(:totals) do
        '<IBSCBSTot><gMono><vIBSMono>1.00</vIBSMono><vCBSMono>9.00</vCBSMono>' \
          '<vIBSMonoReten>0.00</vIBSMonoReten><vCBSMonoReten>0.00</vCBSMonoReten></gMono></IBSCBSTot>'
      end

      it 'renders the monophasic totals' do
        expect(pdf_text).to include("VALOR DO IBS MONOFÁSICO\n1,00\nVALOR DA CBS MONOFÁSICA\n9,00")
      end

      it 'renders the retention totals in blank' do
        expect(pdf_text).to end_with(
          "VALOR DO IBS MONOFÁSICO POR RETENÇÃO\nVALOR DA CBS MONOFÁSICA POR RETENÇÃO"
        )
      end
    end

    context 'when the NF-e has monophasic IBS/CBS subject to retention' do
      let(:totals) do
        '<IBSCBSTot><gMono><vIBSMono>1.00</vIBSMono><vCBSMono>9.00</vCBSMono>' \
          '<vIBSMonoReten>0.50</vIBSMonoReten><vCBSMonoReten>4.50</vCBSMonoReten></gMono></IBSCBSTot>'
      end

      it 'renders the retention totals' do
        expect(pdf_text).to include(
          "VALOR DO IBS MONOFÁSICO POR RETENÇÃO\n0,50\nVALOR DA CBS MONOFÁSICA POR RETENÇÃO\n4,50"
        )
      end
    end

    context 'when the NF-e uses the current layout' do
      let(:issued_at) { '2026-11-20T10:00:00-03:00' }

      it 'renders nothing' do
        expect(pdf_text).to eql ''
      end
    end
  end
end
