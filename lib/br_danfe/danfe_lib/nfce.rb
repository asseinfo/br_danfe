module BrDanfe
  module DanfeLib
    class DanfeNfce
      PAGE_WIDTH = 8.cm
      PAGE_HEIGHT = 100.cm

      attr_reader :options

      def initialize(xml)
        @xml = BrDanfe::XML.new(xml)
        @pdf = Danfe::NfceLib::Document.new(PAGE_WIDTH, PAGE_HEIGHT)
        @options = BrDanfe::Logo::Config.new
      end

      def save_pdf(filename, footer_info = '')
        generate footer_info
        @pdf.render_file filename
      end

      def render_pdf(footer_info = '')
        generate footer_info
        @pdf.render
      end

      private

      def generate(footer_info)
        Danfe::NfceLib::Header.new(@pdf, @xml, @options.logo, @options.logo_dimensions).render
        Danfe::NfceLib::ProductList.new(@pdf, @xml).render
        Danfe::NfceLib::TotalList.new(@pdf, @xml).render
        Danfe::NfceLib::Key.new(@pdf, @xml).render
        Danfe::NfceLib::Recipient.new(@pdf, @xml).render
        Danfe::NfceLib::NfceIdentification.new(@pdf, @xml).render
        Danfe::NfceLib::QrCode.new(@pdf, @xml).render
        Danfe::NfceLib::Footer.new(@pdf, @xml).render(footer_info)

        resize_page_height
      end

      def resize_page_height
        @pdf.page.dictionary.data[:MediaBox] = [0, @pdf.y - 10, PAGE_WIDTH, PAGE_HEIGHT]
      end
    end
  end
end
