require "spec_helper"

describe BrDanfe::DanfeLib::Infadic do
  let(:base_dir) { "./spec/fixtures/nfe/lib/" }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:pdf) { BrDanfe::DanfeLib::Document.new }
  let(:xml) { BrDanfe::DanfeLib::XML.new(xml_as_string) }

  subject { described_class.new(pdf, xml) }

  describe "#render" do
    let(:xml_as_string) do
      <<-eos
      <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
        <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
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
          </transp>
          <infAdic>
            <infCpl>Uma observação</infCpl>
          </infAdic>
          <total>
            <ICMSTot>
              <vFCPUFDest>0.00</vFCPUFDest>
              <vICMSUFDest>0.00</vICMSUFDest>
              <vICMSUFRemet>0.00</vICMSUFRemet>
            </ICMSTot>
          </total>
        </infNFe>
      </NFe>
      eos
    end

    context "without extra volume" do
      before do
        subject.render(1)
        File.delete(output_pdf) if File.exist?(output_pdf)
      end

      it "renders xml to the pdf" do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}infadic#render.pdf").to have_same_content_of file: output_pdf
      end

      context "with difal" do
        let(:xml_as_string) do
          <<-eos
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
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
              </transp>
              <infAdic>
                <infCpl>Uma observação</infCpl>
              </infAdic>
              <total>
                <ICMSTot>
                  <vFCPUFDest>4892.78</vFCPUFDest>
                  <vICMSUFDest>2915.78</vICMSUFDest>
                  <vICMSUFRemet>75394.78</vICMSUFRemet>
                </ICMSTot>
              </total>
            </infNFe>
          </NFe>
          eos
        end

        it "renders xml to the pdf" do
          expect(File.exist?(output_pdf)).to be_falsey

          pdf.render_file output_pdf

          expect("#{base_dir}infadic#render-difal.pdf").to have_same_content_of file: output_pdf
        end
      end
    end

    context "with extra volume" do
      before do
        subject.render(3)
        File.delete(output_pdf) if File.exist?(output_pdf)
      end

      it "renders xml to the pdf" do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}infadic#render-extra_volume.pdf").to have_same_content_of file: output_pdf
      end

      context "with difal" do
        let(:xml_as_string) do
          <<-eos
        <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
          <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
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
          eos
        end

        it "renders xml to the pdf" do
          expect(File.exist?(output_pdf)).to be_falsey

          pdf.render_file output_pdf

          expect("#{base_dir}infadic#render-extra_volume_difal.pdf").to have_same_content_of file: output_pdf
        end
      end
    end
  end
end
