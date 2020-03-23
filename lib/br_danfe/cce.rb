module BrDanfe
  class Cce
    def initialize(xml)
      @xml = xml
      @pdf = CceLib::Document.new
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
      CceLib::Header.new(@pdf).render
      CceLib::Barcode.new(@pdf, @xml).render
      CceLib::NfeKey.new(@pdf, @xml).render
      CceLib::Protocol.new(@pdf, @xml).render
      CceLib::Correction.new(@pdf, @xml).render
      CceLib::Footer.new(@pdf).render
    end
  end
end
