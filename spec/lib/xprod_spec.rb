#encoding: utf-8

require "spec_helper"

describe BrDanfe::Xprod do
  describe "#render" do
    context "when have FCI" do
      let(:xml_fci) do
        xml = <<-eos
        <det nItem="1">
          <prod>
            <xProd>MONITOR DE ARCO ELETRICO</xProd>
            <nFCI>12232531-74B2-4FDD-87A6-CF0AD3E55386</nFCI>
          </prod>
        </det>
        eos

        Nokogiri::XML(xml)
      end

      subject { BrDanfe::Xprod.new(xml_fci) }

      it "returns product + FCI" do
        expected = "MONITOR DE ARCO ELETRICO"
        expected += "\n"
        expected +="FCI: 12232531-74B2-4FDD-87A6-CF0AD3E55386"
        expect(subject.render).to eq expected
      end
    end

    context "when have ST" do
      let(:xml_st) do
        xml = <<-eos
        <det nItem="1">
          <prod>
            <xProd>MONITOR DE ARCO ELETRICO</xProd>
          </prod>
          <imposto>
            <vTotTrib>96.73</vTotTrib>
            <ICMS>
              <ICMSSN202>
                <pMVAST>56.00</pMVAST>
                <vBCST>479.82</vBCST>
                <pICMSST>17.00</pICMSST>
                <vICMSST>29.28</vICMSST>
              </ICMSSN202>
            </ICMS>
          </imposto>
        </det>
        eos

        Nokogiri::XML(xml)
      end

      subject { BrDanfe::Xprod.new(xml_st) }

      it "returns product + ST" do
        expected = "MONITOR DE ARCO ELETRICO"
        expected += "\n"
        expected += "ST: MVA: 56.00% * Alíq: 17.00% * BC: 479.82 * Vlr: 29.28"

        expect(subject.render).to eq expected
      end
    end

    context "when have infAdProd" do
      let(:xml_infAdProd) do
        xml = <<-eos
        <det nItem="1">
          <prod>
            <xProd>MONITOR DE ARCO ELETRICO</xProd>
          </prod>
          <infAdProd>Informações adicionais do produto</infAdProd>
        </det>
        eos

        Nokogiri::XML(xml)
      end

      subject { BrDanfe::Xprod.new(xml_infAdProd) }

      it "returns product + infAdProd" do
        expected = "MONITOR DE ARCO ELETRICO"
        expected += "\n"
        expected += "Informações adicionais do produto"

        expect(subject.render).to eq expected
      end
    end

    context "when have FCI + ST + infAdProd" do
      let(:xml_IFC_ST_infAdProd) do
        xml = <<-eos
        <det nItem="1">
          <prod>
            <xProd>MONITOR DE ARCO ELETRICO</xProd>
            <nFCI>12232531-74B2-4FDD-87A6-CF0AD3E55386</nFCI>
          </prod>
          <imposto>
            <vTotTrib>96.73</vTotTrib>
            <ICMS>
              <ICMSSN202>
                <pMVAST>56.00</pMVAST>
                <vBCST>479.82</vBCST>
                <pICMSST>17.00</pICMSST>
                <vICMSST>29.28</vICMSST>
              </ICMSSN202>
            </ICMS>
          </imposto>
          <infAdProd>Informações adicionais do produto</infAdProd>
        </det>
        eos

        Nokogiri::XML(xml)
      end

      subject { BrDanfe::Xprod.new(xml_IFC_ST_infAdProd) }

      it "returns product + FCI + ST + infAdProd" do
        expected = "MONITOR DE ARCO ELETRICO"
        expected += "\n"
        expected += "Informações adicionais do produto"
        expected += "\n"
        expected +="FCI: 12232531-74B2-4FDD-87A6-CF0AD3E55386"
        expected += "\n"
        expected += "ST: MVA: 56.00% * Alíq: 17.00% * BC: 479.82 * Vlr: 29.28"

        expect(subject.render).to eq expected
      end
    end
  end
end
