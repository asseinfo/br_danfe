require 'spec_helper'

describe BrDanfe::DanfeNfceLib::TotalList do
  let(:base_dir) { './spec/fixtures/nfce/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:pdf) { BrDanfe::DanfeNfceLib::Document.new(8.cm, 5.cm) }
  let(:payment_xml) do
    <<-eos
      <pag>
        <detPag>
          <tPag>01</tPag>
          <vPag>10.00</vPag>
        </detPag>
        <detPag>
          <tPag>02</tPag>
          <vPag>15.30</vPag>
        </detPag>
        <detPag>
          <tPag>05</tPag>
          <vPag>66.70</vPag>
        </detPag>
      </pag>
    eos
  end
  let(:xml_as_string) do
    xml = <<-eos
      <nfeProc>
        <NFe>
          <infNFe>
            <det nItem="1"></det>
            <det nItem="2"></det>
            <det nItem="3"></det>
            <det nItem="4"></det>
            <total>
              <ICMSTot>
                <vProd>104.00</vProd>
                <vDesc>12.00</vDesc>
                <vNF>92.00</vNF>
              </ICMSTot>
            </total>
            #{payment_xml}
          </infNFe>
        </NFe>
      </nfeProc>
    eos
  end
  let(:xml_total_list) { BrDanfe::XML.new(xml_as_string) }

  subject { described_class.new pdf, xml_total_list }

  describe '#render' do
    before do
      subject.render
      File.delete(output_pdf) if File.exist?(output_pdf)
    end

    it 'renders the total list' do
      expect(File.exist?(output_pdf)).to be_falsey
      pdf.render_file output_pdf

      expect("#{base_dir}total_list#render.pdf").to have_same_content_of file: output_pdf
    end

    describe 'about totals' do
      let(:xml_as_string) do
        xml = <<-eos
          <nfeProc>
            <NFe>
              <infNFe>
                <det nItem="1"></det>
                <det nItem="2"></det>
                <det nItem="3"></det>
                <det nItem="4"></det>
                <total>
                  <ICMSTot>
                    <vProd>104.00</vProd>
                    <vDesc>12.00</vDesc>
                    <vNF>92.00</vNF>
                  </ICMSTot>
                </total>
              </infNFe>
            </NFe>
          </nfeProc>
        eos
      end

      it 'renders the totals' do
        expect(File.exist?(output_pdf)).to be_falsey
        pdf.render_file output_pdf

        expect("#{base_dir}total_list#render-totals.pdf").to have_same_content_of file: output_pdf
      end
    end

    describe 'about payment methods' do
      let(:payment_xml) do
        <<-eos
          <pag>
            <detPag>
              <tPag>01</tPag>
              <vPag>10.00</vPag>
            </detPag>
            <detPag>
              <tPag>02</tPag>
              <vPag>15.30</vPag>
            </detPag>
            <detPag>
              <tPag>05</tPag>
              <vPag>66.70</vPag>
            </detPag>
            <detPag>
              <tPag>90</tPag>
              <vPag>1.99</vPag>
            </detPag>
          </pag>
        eos
      end

      it 'does not render the ""without payment"" payment method ' do
        expect(File.exist?(output_pdf)).to be_falsey
        pdf.render_file output_pdf

        expect("#{base_dir}total_list#render-without_payment.pdf").to have_same_content_of file: output_pdf
      end

      context 'when there are repeated payment methods' do
        let(:payment_xml) do
          <<-eos
            <pag>
              <detPag>
                <tPag>01</tPag>
                <vPag>10.00</vPag>
              </detPag>
              <detPag>
                <tPag>01</tPag>
                <vPag>30.00</vPag>
              </detPag>
              <detPag>
                <tPag>02</tPag>
                <vPag>25.50</vPag>
              </detPag>
              <detPag>
                <tPag>02</tPag>
                <vPag>26.50</vPag>
              </detPag>
            </pag>
          eos
        end

        it 'renders grouped payment methods' do
          expect(File.exist?(output_pdf)).to be_falsey
          pdf.render_file output_pdf

          expect("#{base_dir}total_list#render-grouped_payment_methods.pdf").to have_same_content_of file: output_pdf
        end
      end

      context 'when there are only "without payment" payment methods' do
        let(:payment_xml) do
          <<-eos
            <pag>
              <detPag>
                <tPag>90</tPag>
                <vPag>10.00</vPag>
              </detPag>
              <detPag>
                <tPag>90</tPag>
                <vPag>15.30</vPag>
              </detPag>
              <detPag>
                <tPag>90</tPag>
                <vPag>66.70</vPag>
              </detPag>
            </pag>
          eos
        end

        it 'does not render payment methods' do
          expect(File.exist?(output_pdf)).to be_falsey
          pdf.render_file output_pdf

          expect("#{base_dir}total_list#does_not_render-payment_methods.pdf").to have_same_content_of file: output_pdf
        end
      end
    end
  end
end
