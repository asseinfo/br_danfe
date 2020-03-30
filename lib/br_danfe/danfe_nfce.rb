module BrDanfe
  class DanfeNfce
    PAGE_WIDTH = 8.cm
    PAGE_HEIGHT = 100.cm

    attr_reader :options

    def initialize(xml)
      @xml = BrDanfe::XML.new(xml)
      @pdf = DanfeNfceLib::Document.new(PAGE_WIDTH, PAGE_HEIGHT)
      @options = BrDanfe::Logo::Config.new
    end

    def save_pdf(filename)
      generate
      @pdf.render_file filename
    end

    def render_pdf
      generate
      @pdf.render
    end

    private

    def generate
      DanfeNfceLib::Header.new(@pdf, @xml, @options.logo, @options.logo_dimensions).render
      DanfeNfceLib::ProductList.new(@pdf, @xml).render
      DanfeNfceLib::TotalList.new(@pdf, @xml).render
      DanfeNfceLib::Key.new(@pdf, @xml).render
      DanfeNfceLib::Recipient.new(@pdf, @xml).render
      DanfeNfceLib::NfceIdentification.new(@pdf, @xml).render
      DanfeNfceLib::QrCode.new(@pdf, @xml).render
      DanfeNfceLib::Footer.new(@pdf, @xml).render

      resize_page_height
    end

    def resize_page_height
      @pdf.page.dictionary.data[:MediaBox] = [0, @pdf.y - 10, PAGE_WIDTH, PAGE_HEIGHT]
    end
  end
end
