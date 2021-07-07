module BrDanfe
  class Mdfe
    def initialize(xml)
      @xml = xml
      @pdf = MdfeLib::Document.new
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
      MdfeLib::Header.new(@pdf).render
    end
  end
end
