module BrDanfe
  class Mdfe
    attr_reader :logo_options

    def initialize(xml)
      @xml = xml
      @pdf = MdfeLib::Document.new
      @logo_options = BrDanfe::Logo::Config.new
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
      MdfeLib::Header.new(@pdf, @xml, @logo_options.logo, @logo_options.logo_dimensions).render
      MdfeLib::MdfeIdentification.new(@pdf, @xml).render
      MdfeLib::Totalizer.new(@pdf, @xml).render
      MdfeLib::AuthorizationProtocol.new(@pdf, @xml).render
      MdfeLib::FiscoControl.new(@pdf, @xml).render
    end
  end
end
