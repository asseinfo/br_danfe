require 'spec_helper'

describe BrDanfe::DanfeLib::NfceLib::Recipient do
  let(:base_dir) { './spec/fixtures/nfce/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:pdf) { BrDanfe::DanfeLib::NfceLib::Document.new(8.cm, 5.cm) }
  let(:xml_recipient) { BrDanfe::XML.new(xml_as_string) }

  subject { described_class.new pdf, xml_recipient }

  describe '#render' do
    before do
      subject.render
      File.delete(output_pdf) if File.exist?(output_pdf)
    end

    context 'when has identified recipient' do
      context 'when the recipient is a company' do
        let(:xml_as_string) do
          <<~XML
            <nfeProc>
              <NFe>
                <dest>
                  <CNPJ>18191228000171</CNPJ>
                  <xNome>John Doe</xNome>
                  <enderDest>
                    <xLgr>Av. Bayer Filho</xLgr>
                    <nro>1999</nro>
                    <xBairro>Centro</xBairro>
                    <xMun>Tijucas</xMun>
                    <UF>SC</UF>
                  </enderDest>
                </dest>
              </NFe>
            </nfeProc>
          XML
        end

        it 'renders the CNPJ and company informations' do
          expect(File.exist?(output_pdf)).to be_falsey
          pdf.render_file output_pdf

          expect("#{base_dir}recipient#render-company.pdf").to have_same_content_of file: output_pdf
        end
      end

      context 'when the recipient is an individual person' do
        let(:xml_as_string) do
          <<~XML
            <nfeProc>
              <NFe>
                <dest>
                  <CPF>37626406028</CPF>
                  <xNome>John Doe</xNome>
                  <enderDest>
                    <xLgr>Av. Bayer Filho</xLgr>
                    <nro>1999</nro>
                    <xBairro>Centro</xBairro>
                    <xMun>Tijucas</xMun>
                    <UF>SC</UF>
                  </enderDest>
                </dest>
              </NFe>
            </nfeProc>
          XML
        end

        it 'renders the CPF and individual informations' do
          expect(File.exist?(output_pdf)).to be_falsey
          pdf.render_file output_pdf

          expect("#{base_dir}recipient#render-individual.pdf").to have_same_content_of file: output_pdf
        end
      end

      context 'when the recipient is a foreign' do
        let(:xml_as_string) do
          <<~XML
            <nfeProc>
              <NFe>
                <dest>
                  <idEstrangeiro>123456789</idEstrangeiro>
                  <xNome>John Doe</xNome>
                  <enderDest>
                    <xLgr>Av. Bayer Filho</xLgr>
                    <nro>1999</nro>
                    <xBairro>Centro</xBairro>
                    <xMun>Tijucas</xMun>
                    <UF>SC</UF>
                  </enderDest>
                </dest>
              </NFe>
            </nfeProc>
          XML
        end

        it 'renders the ID Estrangeiro and foreign informations' do
          expect(File.exist?(output_pdf)).to be_falsey
          pdf.render_file output_pdf

          expect("#{base_dir}recipient#render-foreign.pdf").to have_same_content_of file: output_pdf
        end
      end

      context 'when the recipient does not have document' do
        let(:xml_as_string) do
          <<~XML
            <nfeProc>
              <NFe>
                <dest>
                  <xNome>John Doe</xNome>
                  <enderDest>
                    <xLgr>Av. Bayer Filho</xLgr>
                    <nro>1999</nro>
                    <xBairro>Centro</xBairro>
                    <xMun>Tijucas</xMun>
                    <UF>SC</UF>
                  </enderDest>
                </dest>
              </NFe>
            </nfeProc>
          XML
        end

        it 'renders the name and the address of the consumer' do
          expect(File.exist?(output_pdf)).to be_falsey
          pdf.render_file output_pdf

          expect("#{base_dir}recipient#render-consumer_without_document.pdf").to have_same_content_of file: output_pdf
        end
      end
    end

    context 'when does not have identified recipient' do
      let(:xml_as_string) do
        <<~XML
          <nfeProc>
            <NFe>
              <dest>
                <CNPJ>18191228000171</CNPJ>
                <enderDest>
                  <xLgr>Rua Tijucas</xLgr>
                  <nro>99</nro>
                  <xBairro>Centro</xBairro>
                  <xMun>TIJUCAS</xMun>
                  <UF>SC</UF>
                </enderDest>
              </dest>
            </NFe>
          </nfeProc>
        XML
      end

      it 'renders unidentified consumer' do
        expect(File.exist?(output_pdf)).to be_falsey
        pdf.render_file output_pdf

        expect("#{base_dir}recipient#render-unidentified_consumer.pdf").to have_same_content_of file: output_pdf
      end
    end
  end
end
