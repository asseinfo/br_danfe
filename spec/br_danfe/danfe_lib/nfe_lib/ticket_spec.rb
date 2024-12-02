require 'spec_helper'

describe BrDanfe::DanfeLib::NfeLib::Ticket do
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
            <ide>
              <nNF>1</nNF>
              <serie>1</serie>
            </ide>
            <emit>
              <xNome>Nome do Remetente Ltda</xNome>
            </emit>
          </infNFe>
        </NFe>
      XML
    end

    before do
      subject.render
      File.delete(output_pdf) if File.exist?(output_pdf)
    end

    it 'renders xml to the pdf' do
      expect(File.exist?(output_pdf)).to be_falsey

      pdf.render_file output_pdf

      expect("#{base_dir}ticket#render.pdf").to have_same_content_of file: output_pdf
    end

    context 'when has all the additional_data' do
      let(:xml_as_string) do
        <<~XML
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe versao=\"4.00\" Id=\"NFe42241038422761000104550010000023571114538052\">
              <ide>
                <dhEmi>2024-10-04T10:57:54-03:00</dhEmi>
              </ide>
              <emit>
                <xNome>Empresa teste</xNome>
              </emit>
              <dest>
                <CNPJ>18191228000171</CNPJ>
                <xNome>NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL</xNome>
                <indIEDest>9</indIEDest>
                <email>desenvolvedores@asseinfo.com.br</email>
              </dest>
              <total>
                <ICMSTot>
                  <vNF>40.00</vNF>
                </ICMSTot>
              </total>
            </infNFe>
          </NFe>
        XML
      end
      let(:volumes_number) { 3 }

      it 'renders ticket with name, recipient, emmited_at and total_value' do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}ticket#render-all_the_additional_data.pdf").to have_same_content_of file: output_pdf
      end
    end
  end
end
