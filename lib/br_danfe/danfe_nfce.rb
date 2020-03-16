module BrDanfe
  class DanfeNfce
    def initialize(xml)
      @xml = xml
      @pdf = DanfeNfce::Document.new
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
      # DanfeNfceLib::Header.new(@pdf).render
      # DanfeNfceLib::ProductList.new(@pdf).render
      # DanfeNfceLib::TotalList.new(@pdf).render
      # DanfeNfceLib::Key.new(@pdf).render
      # DanfeNfceLib::QrCode.new(@pdf).render
      # DanfeNfceLib::Recipient.new(@pdf).render
      # DanfeNfceLib::NfceIdentification.new(@pdf).render
      # DanfeNfceLib::Footer.new(@pdf).render
    end
  end
end
