require 'spec_helper'

describe BrDanfe::DanfeNfceLib::NfceIdentification do
  let(:file_name) { 'nfce_identification' }
  let(:base_dir) { './spec/fixtures/nfce/lib/' }
  let(:output_pdf) { "#{base_dir}#{file_name}.pdf" }

  let(:xml) do
    xml = <<-eos
      <ide>
        <cUF>42</cUF>
        <cNF>18291023</cNF>
        <natOp>Venda</natOp>
        <mod>55</mod>
        <serie>1</serie>
        <nNF>1629</nNF>
        <dhEmi>2020-03-24T13:33:20-05:00</dhEmi>
        <tpNF>1</tpNF>
        <idDest>1</idDest>
        <cMunFG>4202859</cMunFG>
        <tpImp>1</tpImp>
        <tpEmis>1</tpEmis>
        <cDV>2</cDV>
        <tpAmb>2</tpAmb>
        <finNFe>1</finNFe>
        <indFinal>1</indFinal>
        <indPres>9</indPres>
        <procEmi>0</procEmi>
        <verProc>facil123.com.br</verProc>
      </ide>
    eos

    BrDanfe::XML.new(xml)
  end

  let(:danfe) { BrDanfe::DanfeNfceLib::Document.new(8.cm, 3.5.cm) }

  before { File.delete(output_pdf) if File.exist?(output_pdf) }
  after { File.delete(output_pdf) if File.exist?(output_pdf) }

  it 'renders the document' do
    expect(File.exist?(output_pdf)).to be_falsey

    subject = described_class.new(danfe, xml)
    subject.render

    danfe.render_file output_pdf

    expect("#{base_dir}#{file_name}.fixture.pdf").to have_same_content_of file: output_pdf
  end
end
