require 'spec_helper'

describe BrDanfe::DanfeLib::Xprod do
  describe '#render' do
    context 'when has FCI' do
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

      subject { BrDanfe::DanfeLib::Xprod.new(xml_fci) }

      it 'returns product + FCI' do
        expected = 'MONITOR DE ARCO ELETRICO'
        expected += "\n"
        expected += 'FCI: 12232531-74B2-4FDD-87A6-CF0AD3E55386'
        expect(subject.render).to eq expected
      end
    end

    context 'when has ST' do
      context 'when is Retido' do
        let(:vBCSTRet) { 0.00 }
        let(:pST) { 0.00 }
        let(:vICMSSTRet) { 0.00 }
        let(:xml) do
          xml = <<-eos
            <det nItem="1">
              <prod>
                <xProd>MONITOR DE ARCO ELETRICO</xProd>
              </prod>
              <imposto>
                <ICMS>
                  <ICMSST>
                    <orig>0</orig>
                    <CST>60</CST>
                    <pST>#{pST}</pST>
                    <vBCSTRet>#{vBCSTRet}</vBCSTRet>
                    <vICMSSTRet>#{vICMSSTRet}</vICMSSTRet>
                    <vBCSTDest>0.00</vBCSTDest>
                    <vICMSSTDest>0.00</vICMSSTDest>
                  </ICMSST>
                </ICMS>
                <PIS>
                  <PISNT>
                    <CST>04</CST>
                  </PISNT>
                </PIS>
                <COFINS>
                  <COFINSNT>
                    <CST>04</CST>
                  </COFINSNT>
                </COFINS>
              </imposto>
            </det>
          eos

          Nokogiri::XML(xml)
        end

        subject { BrDanfe::DanfeLib::Xprod.new(xml) }

        context 'when has vBCSTRet' do
          let(:vBCSTRet) { 50.00 }

          it 'returns product + ST Retido' do
            expected = 'MONITOR DE ARCO ELETRICO'
            expected += "\n"
            expected += 'ST Retido: Base: 50,00 * Alíq: 0,00% * Vlr: 0,00'

            expect(subject.render).to eq expected
          end
        end

        context 'when has vICMSSTRet' do
          let(:vICMSSTRet) { 50.00 }

          it 'returns product + ST Retido' do
            expected = 'MONITOR DE ARCO ELETRICO'
            expected += "\n"
            expected += 'ST Retido: Base: 0,00 * Alíq: 0,00% * Vlr: 50,00'

            expect(subject.render).to eq expected
          end
        end

        context 'when has pST' do
          let(:pST) { 50.00 }

          it 'returns product + ST Retido' do
            expected = 'MONITOR DE ARCO ELETRICO'
            expected += "\n"
            expected += 'ST Retido: Base: 0,00 * Alíq: 50,00% * Vlr: 0,00'

            expect(subject.render).to eq expected
          end
        end

        context "when doesn't have any fields" do
          it 'returns product' do
            expected = 'MONITOR DE ARCO ELETRICO'

            expect(subject.render).to eq expected
          end
        end
      end

      context "when isn't Retido" do
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

        subject { BrDanfe::DanfeLib::Xprod.new(xml_st) }

        it 'returns product + ST' do
          expected = 'MONITOR DE ARCO ELETRICO'
          expected += "\n"
          expected += 'ST: MVA: 56,00% * Alíq: 17,00% * BC: 479,82 * Vlr: 29,28'

          expect(subject.render).to eq expected
        end
      end
    end

    context 'when has infAdProd' do
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

      subject { BrDanfe::DanfeLib::Xprod.new(xml_infAdProd) }

      it 'returns product + infAdProd' do
        expected = 'MONITOR DE ARCO ELETRICO'
        expected += "\n"
        expected += 'Informações adicionais do produto'

        expect(subject.render).to eq expected
      end
    end

    context 'when has FCP on ICMS00 tag' do
      let(:xml_fcp) do
        xml = <<-eos
        <det nItem="1">
          <prod>
            <xProd>MONITOR DE ARCO ELETRICO</xProd>
          </prod>
          <imposto>
            <vTotTrib>23.56</vTotTrib>
            <ICMS>
              <ICMS00>
                <vFCP>4.71</vFCP>
                <pFCP>2.00</pFCP>
              </ICMS00>
            </ICMS>
          </imposto>
        </det>
        eos

        Nokogiri::XML(xml)
      end

      subject { BrDanfe::DanfeLib::Xprod.new(xml_fcp) }

      it 'returns product + FCP' do
        expected = 'MONITOR DE ARCO ELETRICO'
        expected += "\n"
        expected += 'FCP: Alíq: 2,00% * Vlr: 4,71'

        expect(subject.render).to eq expected
      end
    end

    context 'when has FCI + ST + infAdProd + FCP' do
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
              <ICMS00>
                <vFCP>4.71</vFCP>
                <pFCP>2.00</pFCP>
              </ICMS00>
            </ICMS>
          </imposto>
          <infAdProd>Informações adicionais do produto</infAdProd>
        </det>
        eos

        Nokogiri::XML(xml)
      end

      subject { BrDanfe::DanfeLib::Xprod.new(xml_IFC_ST_infAdProd) }

      it 'returns product + FCI + ST + infAdProd' do
        expected = 'MONITOR DE ARCO ELETRICO'
        expected += "\n"
        expected += 'Informações adicionais do produto'
        expected += "\n"
        expected += 'FCI: 12232531-74B2-4FDD-87A6-CF0AD3E55386'
        expected += "\n"
        expected += 'ST: MVA: 56,00% * Alíq: 17,00% * BC: 479,82 * Vlr: 29,28'
        expected += "\n"
        expected += 'FCP: Alíq: 2,00% * Vlr: 4,71'

        expect(subject.render).to eq expected
      end
    end

    context 'when FCP is not in a ICMS00 tag' do
      let(:xml_fcp) do
        xml = <<-eos
        <det nItem="1">
          <prod>
            <xProd>MONITOR DE ARCO ELETRICO</xProd>
          </prod>
          <imposto>
            <vTotTrib>23.56</vTotTrib>
            <ICMS>
              <ICMS10>
                <vBCFCP>235.50</vBCFCP>
                <vFCP>4.71</vFCP>
                <pFCP>2.00</pFCP>
              </ICMS10>
            </ICMS>
          </imposto>
        </det>
        eos

        Nokogiri::XML(xml)
      end

      subject { BrDanfe::DanfeLib::Xprod.new(xml_fcp) }

      it 'returns product + FCP' do
        expected = 'MONITOR DE ARCO ELETRICO'
        expected += "\n"
        expected += 'FCP: Base: 235,50 * Alíq: 2,00% * Vlr: 4,71'

        expect(subject.render).to eq expected
      end
    end

    context 'when has FCP ST' do
      let(:xml_fcp) do
        xml = <<-eos
        <det nItem="1">
          <prod>
            <xProd>MONITOR DE ARCO ELETRICO</xProd>
          </prod>
          <imposto>
            <vTotTrib>23.56</vTotTrib>
            <ICMS>
              <ICMS30>
                <vBCFCPST>235.50</vBCFCPST>
                <vFCPST>4.71</vFCPST>
                <pFCPST>2.00</pFCPST>
              </ICMS30>
            </ICMS>
          </imposto>
        </det>
        eos

        Nokogiri::XML(xml)
      end

      subject { BrDanfe::DanfeLib::Xprod.new(xml_fcp) }

      it 'returns product + FCP' do
        expected = 'MONITOR DE ARCO ELETRICO'
        expected += "\n"
        expected += 'FCP ST: Base: 235,50 * Alíq: 2,00% * Vlr: 4,71'

        expect(subject.render).to eq expected
      end
    end
  end
end
