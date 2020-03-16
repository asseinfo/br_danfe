module BrDanfe
  class DanfeNfce
    def initialize(xml)
      @xml = xml
      @pdf = DanfeNfceLib::Document.new
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
      60.times do |i|
        @pdf.text('12345678901234567890123456789012345678901234567890123456789012345678901234567890')
        @pdf.text("I#{i}")
      end

      @pdf.page.dictionary.data[:MediaBox] = [0, @pdf.y - 10, 227, 2000]

      #   doc.page.dictionary.data[:MediaBox] = [0, doc.y - 10, 100, 2000]
      # end

      # DanfeNfceLib::Header.new(@pdf, @xml).render
      # DanfeNfceLib::ProductList.new(@pdf, @xml).render
      # DanfeNfceLib::TotalList.new(@pdf, @xml).render
      # DanfeNfceLib::Key.new(@pdf, @xml).render
      # DanfeNfceLib::QrCode.new(@pdf, @xml).render
      # DanfeNfceLib::Recipient.new(@pdf, @xml).render
      # DanfeNfceLib::NfceIdentification.new(@pdf, @xml).render
      # DanfeNfceLib::Footer.new(@pdf, @xml).render
    end
  end
end
