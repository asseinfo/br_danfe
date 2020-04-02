module BrDanfe
  module DanfeLib
    class Nfce < Base
      PAGE_WIDTH = 8.cm
      PAGE_HEIGHT = 100.cm

      private

      def document
        NfceLib::Document.new(PAGE_WIDTH, PAGE_HEIGHT)
      end

      def generate(footer_info)
        NfceLib::Header.new(@document, @xml, @options.logo, @options.logo_dimensions).render
        NfceLib::ProductList.new(@document, @xml).render
        NfceLib::TotalList.new(@document, @xml).render
        NfceLib::Key.new(@document, @xml).render
        NfceLib::Recipient.new(@document, @xml).render
        NfceLib::NfceIdentification.new(@document, @xml).render
        NfceLib::QrCode.new(@document, @xml).render
        NfceLib::Footer.new(@document, @xml).render(footer_info)

        resize_page_height
      end

      def resize_page_height
        @document.page.dictionary.data[:MediaBox] = [0, @document.y - 10, PAGE_WIDTH, PAGE_HEIGHT]
      end
    end
  end
end
