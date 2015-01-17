module BrDanfe
  LINE_HEIGHT = 0.80
  SPACE_BETWEEN_GROUPS = 0.52

  class Danfe
    attr_reader :options

    def initialize(xml)
      @xml = XML.new(xml)
      @pdf = Document.new
      @options = Options.new

      create_watermark
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
    def create_watermark
      @pdf.create_stamp("has_no_fiscal_value") do
        @pdf.fill_color "7d7d7d"
        @pdf.text_box I18n.t("danfe.others.has_no_fiscal_value"),
          size: 2.2.cm,
          width: @pdf.bounds.width,
          height: @pdf.bounds.height,
          align: :center,
          valign: :center,
          at: [0, @pdf.bounds.height],
          rotate: 45,
          rotate_around: :center
      end
    end

    def generate
      @pdf.stamp("has_no_fiscal_value") if Helper.has_no_fiscal_value?(@xml)

      @pdf.repeat(:all) { repeat_on_each_page }

      DetBody.new(@pdf, @xml).render

      @pdf.page_count.times do |i|
        @pdf.go_to_page(i + 1)
        @pdf.ibox 1.00, 2.08, 8.71, 5.54, "",
          I18n.t("danfe.others.page", current: i+1, total: @pdf.page_count),
          { size: 8, align: :center, valign: :center, border: 0, style: :bold }
      end

      @pdf
    end

    def repeat_on_each_page
      Ticket.render(@pdf, @xml)
      EmitHeader.new(@pdf, @xml, @options.logo_path).render
      Emit.new(@pdf, @xml).render
      Dest.new(@pdf, @xml).render
      Dup.new(@pdf, @xml).render
      Icmstot.new(@pdf, @xml).render
      Transp.new(@pdf, @xml).render
      nVol = Vol.new(@pdf, @xml).render
      DetHeader.new(@pdf, @xml).render
      Issqn.new(@pdf, @xml).render
      Infadic.new(@pdf, @xml).render(nVol)
    end
  end
end
