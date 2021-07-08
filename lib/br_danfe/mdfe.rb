module BrDanfe
  class Mdfe
    attr_reader :options

    def initialize(xml)
      @xml = xml
      @pdf = MdfeLib::Document.new
      @options = BrDanfe::Logo::Config.new
    end

    def save_pdf(filename)
      generate
      @pdf.render_file(filename)
    end

    def render_pdf
      generate
      @pdf.render
    end

    private

    def generate
      MdfeLib::Header.new(@pdf, @xml, @options.logo, @options.logo_dimensions).render
      MdfeLib::MdfeIdentification.new(@pdf, @xml).render
    end
  end
end
