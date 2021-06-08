module BrDanfe
  module DanfeLib
    class Nfce < Base
      PAGE_WIDTH = 8.cm
      PAGE_HEIGHT = 100.cm

      private

      def document
        NfceLib::Document.new(PAGE_WIDTH, PAGE_HEIGHT)
      end

      def create_watermark
        @document.create_stamp('has_no_fiscal_value') do
          @document.fill_color '7d7d7d'
          @document.text_box I18n.t('danfe.others.has_no_fiscal_value'),
                    size: 0.8.cm,
                    width: 10.cm,
                    height: 1.2.cm,
                    at: [0, PAGE_HEIGHT - 3.8.cm],
                    rotate: 45,
                    rotate_around: :center
        end
      end

      def generate(footer_info)
        @xmls.each do |xml|
          NfceLib::Header.new(@document, xml, @options.logo, @options.logo_dimensions).render
          NfceLib::ProductList.new(@document, xml).render
          NfceLib::TotalList.new(@document, xml).render
          NfceLib::Key.new(@document, xml).render
          NfceLib::Recipient.new(@document, xml).render
          NfceLib::NfceIdentification.new(@document, xml).render
          NfceLib::QrCode.new(@document, xml).render
          NfceLib::Footer.new(@document, xml).render(footer_info)

          render_no_fiscal_value(xml)
          resize_page_height
        end
      end

      def render_no_fiscal_value(xml)
        @document.stamp('has_no_fiscal_value') if BrDanfe::Helper.unauthorized?(xml)
      end

      def resize_page_height
        @document.page.dictionary.data[:MediaBox] = [0, @document.y - 10, PAGE_WIDTH, PAGE_HEIGHT]
      end
    end
  end
end
