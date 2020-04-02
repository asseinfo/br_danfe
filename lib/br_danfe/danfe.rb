module BrDanfe
  class Danfe
    attr_reader :options

    def initialize(xml)
      @xml = BrDanfe::XML.new(xml)
      @options = BrDanfe::Logo::Config.new
      @document = create_document
    end

    def save_pdf(filename, footer_info = '')
      @document.save_pdf filename, footer_info
    end

    def render_pdf(footer_info = '')
      @document.render_pdf footer_info
    end

    private

    def create_document
      nfe_code = 55
      @xml['mod'] == nfe_code ? DanfeNfe.new(@xml, @options) : DanfeNfce.new(@xml)
    end
  end
end
