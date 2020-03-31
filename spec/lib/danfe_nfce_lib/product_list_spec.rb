require 'spec_helper'

describe BrDanfe::DanfeNfceLib::ProductList do
  let(:file_name) {}
  let(:base_dir) { './spec/fixtures/nfce/lib/' }
  let(:output_pdf) { "#{base_dir}#{file_name}.pdf" }
  let(:xml) { BrDanfe::XML.new(File.read("#{base_dir}#{file_name}.xml")) }
  let(:danfe) { BrDanfe::DanfeNfceLib::Document.new(8.cm, 3.5.cm) }

  before { File.delete(output_pdf) if File.exist?(output_pdf) }
  after { File.delete(output_pdf) if File.exist?(output_pdf) }

  context 'when does not have a larger names' do
    describe 'when has a single product' do
      let(:file_name) { 'product_list_with_a_single_item' }

      it 'render the product list' do
        expect(File.exist?(output_pdf)).to be_falsey

        subject = described_class.new(danfe, xml)
        subject.render

        danfe.render_file output_pdf

        expect("#{base_dir}#{file_name}.fixture.pdf").to have_same_content_of file: output_pdf
      end
    end

    describe 'when has many products' do
      let(:file_name) { 'product_list_with_many_items' }

      it 'render the product list' do
        expect(File.exist?(output_pdf)).to be_falsey

        subject = described_class.new(danfe, xml)
        subject.render

        danfe.render_file output_pdf

        expect("#{base_dir}#{file_name}.fixture.pdf").to have_same_content_of file: output_pdf
      end
    end
  end

  context 'when does have a larger names' do
    describe 'when has a single product' do
      let(:file_name) { 'product_list_with_a_single_item_and_larger_names' }

      it 'render the product list' do
        expect(File.exist?(output_pdf)).to be_falsey

        subject = described_class.new(danfe, xml)
        subject.render

        danfe.render_file output_pdf

        expect("#{base_dir}#{file_name}.fixture.pdf").to have_same_content_of file: output_pdf
      end
    end

    describe 'when has many products' do
      let(:file_name) { 'product_list_with_many_items_and_larger_names' }

      it 'render the product list' do
        expect(File.exist?(output_pdf)).to be_falsey

        subject = described_class.new(danfe, xml)
        subject.render

        danfe.render_file output_pdf

        expect("#{base_dir}#{file_name}.fixture.pdf").to have_same_content_of file: output_pdf
      end
    end
  end
end
