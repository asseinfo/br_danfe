module BrDanfe
  BLACK_COLOR = '000000'.freeze
  GRAY_COLOR = 'A0A0A0'.freeze
  LIGHT_GRAY_COLOR = 'ECECEC'.freeze

  class Mdfe
    attr_reader :logo_options

    def initialize(xml)
      @xml = BrDanfe::XML.new(xml)
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
      generate_on_first_page
      generate_on_each_page
    end

    def generate_on_first_page
      MdfeLib::Totalizer.new(@pdf, @xml).generate
      MdfeLib::AuthorizationProtocol.new(@pdf, @xml).generate
      MdfeLib::FiscoControl.new(@pdf, @xml).generate
      MdfeLib::Vehicles.new(@pdf, @xml).generate
      MdfeLib::Drivers.new(@pdf, @xml).generate
      MdfeLib::Notes.new(@pdf, @xml).generate
    end

    def generate_on_each_page
      header = MdfeLib::Header.new(@pdf, @xml, @logo_options.logo, @logo_options.logo_dimensions)
      mdfe_identification = MdfeLib::MdfeIdentification.new(@pdf, @xml)

      @pdf.page_count.times do |i|
        page = i + 1

        @pdf.go_to_page page

        header.generate
        mdfe_identification.generate(page)
      end
    end
  end
end
