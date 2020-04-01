require 'spec_helper'

describe BrDanfe::DanfeNfceLib::ProductList do
  let(:base_dir) { './spec/fixtures/nfce/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }
  let(:xml) { BrDanfe::XML.new(File.read("#{base_dir}#{xml_name}.xml")) }

  let(:pdf) { BrDanfe::DanfeNfceLib::Document.new(8.cm, 5.cm) }

  subject { described_class.new pdf, xml }

  describe '#render' do
    before do
      subject.render
      File.delete(output_pdf) if File.exist?(output_pdf)
    end

    context 'when does not have a long name' do
      describe 'when has a single product' do
        let(:xml_name) { 'product_list_with_single_product' }

        it 'renders product list with single product to the pdf' do
          expect(File.exist?(output_pdf)).to be_falsey
          pdf.render_file output_pdf

          expect("#{base_dir}product_list#render-with_single_product.pdf").to have_same_content_of file: output_pdf
        end
      end

      describe 'when has many products' do
        let(:xml_name) { 'product_list_with_many_products' }

        it 'renders product list with many products to the pdf' do
          expect(File.exist?(output_pdf)).to be_falsey
          pdf.render_file output_pdf

          expect("#{base_dir}product_list#render-with_many_products.pdf").to have_same_content_of file: output_pdf
        end
      end
    end

    context 'when has a long name' do
      describe 'when has a single product' do
        let(:xml_name) { 'product_list_with_single_product_and_long_name' }

        it 'renders product list with single product to the pdf' do
          expect(File.exist?(output_pdf)).to be_falsey
          pdf.render_file output_pdf

          expect("#{base_dir}product_list#render-with_single_product_and_long_name.pdf").to have_same_content_of file: output_pdf
        end
      end

      describe 'when has many products' do
        let(:xml_name) { 'product_list_with_many_products_and_long_names' }

        it 'renders product list with many products to the pdf' do
          expect(File.exist?(output_pdf)).to be_falsey
          pdf.render_file output_pdf

          expect("#{base_dir}product_list#render-with_many_products_and_long_names.pdf").to have_same_content_of file: output_pdf
        end
      end
    end
  end
end
