module BrDanfe
  BLACK_COLOR = '000000'.freeze
  GRAY_COLOR = 'A0A0A0'.freeze
  LIGHT_GRAY_COLOR = 'ECECEC'.freeze
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
      render_on_first_page
      render_on_each_page
    end

    def render_on_first_page
      MdfeLib::Totalizer.new(@pdf, @xml).render
      MdfeLib::AuthorizationProtocol.new(@pdf, @xml).render
      MdfeLib::FiscoControl.new(@pdf, @xml).render
      MdfeLib::Vehicles.new(@pdf, @xml).render
      MdfeLib::Drivers.new(@pdf, @xml).render
      MdfeLib::Notes.new(@pdf, @xml).render
    end

    def render_on_each_page
      header = MdfeLib::Header.new(@pdf, @xml, @logo_options.logo, @logo_options.logo_dimensions)
      mdfe_identification = MdfeLib::MdfeIdentification.new(@pdf, @xml)

      @pdf.page_count.times do |i|
        page = i + 1

        @pdf.go_to_page page

        header.render
        mdfe_identification.render(page)
      end
    end
  end
end
