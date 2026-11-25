require 'spec_helper'

describe BrDanfe::DanfeLib::NfeLib::RtcDetRow do
  let(:pdf) { BrDanfe::DanfeLib::NfeLib::Document.new }
  let(:det) { BrDanfe::XML.new(xml_as_string).collect('xmlns', 'det') { _1 }.first }
  let(:pdf_text) { PDF::Inspector::Text.analyze(pdf.render).strings.join("\n") }

  let(:product) do
    <<~XML
      <prod>
        <cProd>TIJ-001</cProd><xProd>TIJOLO CERAMICO</xProd><NCM>69041000</NCM><CFOP>5101</CFOP>
        <uCom>UN</uCom><qCom>1000.00</qCom><vUnCom>1.20</vUnCom><vProd>1200.00</vProd>
      </prod>
    XML
  end
  let(:icms) { '<ICMS><ICMS00><orig>0</orig><CST>00</CST><vBC>1200.00</vBC><pICMS>17.00</pICMS><vICMS>204.00</vICMS></ICMS00></ICMS>' }
  let(:ibscbs) do
    <<~XML
      <IBSCBS><CST>000</CST><cClassTrib>000001</cClassTrib>
        <gIBSCBS><vBC>1200.00</vBC>
          <gIBSUF><pIBSUF>0.1234</pIBSUF><vIBSUF>1.48</vIBSUF></gIBSUF>
          <gIBSMun><pIBSMun>12.5000</pIBSMun><vIBSMun>150.00</vIBSMun></gIBSMun>
          <gCBS><pCBS>0.9000</pCBS><vCBS>10.80</vCBS></gCBS>
        </gIBSCBS>
      </IBSCBS>
    XML
  end
  let(:xml_as_string) do
    <<~XML
      <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
        <infNFe versao="4.00">
          <det nItem="1">#{product}<imposto>#{icms}#{ibscbs}</imposto></det>
        </infNFe>
      </NFe>
    XML
  end

  before do
    pdf.table([described_class.new(pdf, det).render], column_widths: described_class.column_widths)
  end

  describe '#render' do
    it 'renders the description with the product code, the NCM and the tax classification' do
      expect(pdf_text).to include("TIJOLO CERAMICO\n[CÓD TIJ-001] [NCM 69041000]", '[cClassTrib 000001]')
    end

    it 'renders the CST and the CFOP' do
      expect(pdf_text).to include("CST\n000\nCFOP\n5101")
    end

    it 'renders the quantity with the unit' do
      expect(pdf_text).to include("1.000,00\n[UN]")
    end

    it 'renders the bases of ICMS and IBS/CBS' do
      expect(pdf_text).to include("ICMS\n1.200,00\nIBS / CBS\n1.200,00")
    end

    it 'renders the rates with two to four decimal places' do
      expect(pdf_text).to include("ICMS\n17,00%\nCBS\n0,90%\nIBS UF\n0,1234%\nIBS MUN\n12,50%")
    end

    it 'renders the tax values' do
      expect(pdf_text).to include("ICMS\n204,00\nCBS\n10,80\nIBS UF\n1,48\nIBS MUN\n150,00")
    end

    context 'when the IBS/CBS rates are reduced' do
      let(:ibscbs) do
        <<~XML
          <IBSCBS><CST>200</CST><cClassTrib>200003</cClassTrib>
            <gIBSCBS><vBC>1200.00</vBC>
              <gIBSUF><pIBSUF>0.1000</pIBSUF><gRed><pRedAliq>60.0000</pRedAliq><pAliqEfet>0.0400</pAliqEfet></gRed><vIBSUF>0.48</vIBSUF></gIBSUF>
              <gIBSMun><pIBSMun>0.0000</pIBSMun><vIBSMun>0.00</vIBSMun></gIBSMun>
              <gCBS><pCBS>0.9000</pCBS><gRed><pRedAliq>60.0000</pRedAliq><pAliqEfet>0.3600</pAliqEfet></gRed><vCBS>4.32</vCBS></gCBS>
            </gIBSCBS>
          </IBSCBS>
        XML
      end

      it 'renders the effective rates' do
        expect(pdf_text).to include("CBS\n0,36%\nIBS UF\n0,04%\nIBS MUN\n0,00%")
      end
    end

    context 'when the item has the selective tax' do
      let(:icms) { '<IS><vBCIS>450.00</vBCIS><pIS>4.0000</pIS><vIS>18.00</vIS></IS>' }

      it 'renders the base, the rate and the value of the selective tax' do
        expect(pdf_text).to include("IS\n450,00", "IS\n4,00%", "IS\n18,00")
      end
    end

    context 'when the description has markup characters' do
      let(:product) do
        <<~XML
          <prod>
            <cProd>A&amp;B&lt;1&gt;</cProd><xProd>PARAFUSO &lt;M6&gt; &amp; PORCA</xProd><CFOP>5101</CFOP>
            <uCom>UN</uCom><qCom>1.00</qCom><vUnCom>1.00</vUnCom><vProd>1.00</vProd>
          </prod>
        XML
      end

      it 'renders the characters as text' do
        expect(pdf_text).to include("PARAFUSO <M6> & PORCA\n[CÓD A&B<1>]")
      end
    end

    context 'when a Simples Nacional item has no IBS/CBS' do
      let(:icms) { '<ICMS><ICMSSN102><orig>0</orig><CSOSN>102</CSOSN></ICMSSN102></ICMS>' }
      let(:ibscbs) { '' }

      it 'renders the description without the tax classification' do
        expect(pdf_text).to include("TIJOLO CERAMICO\n[CÓD TIJ-001] [NCM 69041000]\nCST\n0102")
      end

      it 'renders the bases, rates and tax values in blank' do
        expect(pdf_text).not_to include('ICMS', 'IBS', 'CBS')
      end
    end
  end
end
