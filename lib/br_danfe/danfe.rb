module BrDanfe
  class Danfe
    attr_reader :options

    def initialize(xml)
      @xml = DanfeLib::XML.new(xml)
      @pdf = DanfeLib::Document.new
      @options = DanfeLib::Options.new

      create_watermark
    end

    def save_pdf(filename, footer_info = "")
      generate footer_info
      @pdf.render_file filename
    end

    def render_pdf(footer_info = "")
      generate footer_info
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

    def generate(footer_info)
      render_on_first_page footer_info

      DanfeLib::DetBody.new(@pdf, @xml).render

      emit_header = DanfeLib::EmitHeader.new(@pdf, @xml, @options.logo, @options.logo_dimensions)
      @pdf.page_count.times do |i|
        page = i + 1
        y_position = y_position(page)

        @pdf.go_to_page(page)

        emit_header.render y_position
        @pdf.ititle 0.42, 10.00, 0.75, 18.91, "det.title"
        render_info_current_page(page, y_position)
        render_no_fiscal_value
      end

      @pdf
    end

    def render_on_first_page(footer_info)
      DanfeLib::Ticket.new(@pdf, @xml).render
      DanfeLib::Emit.new(@pdf, @xml).render
      DanfeLib::Dest.new(@pdf, @xml).render
      DanfeLib::Dup.new(@pdf, @xml).render
      DanfeLib::Icmstot.new(@pdf, @xml).render
      DanfeLib::Transp.new(@pdf, @xml).render
      n_vol = DanfeLib::Vol.new(@pdf, @xml).render
      DanfeLib::Issqn.new(@pdf, @xml).render
      DanfeLib::Infadic.new(@pdf, @xml).render(n_vol, footer_info)
    end

    def y_position(page)
      page === 1 ? 3.96 : 1.85
    end

    def render_info_current_page(page, y_position)
      render_options = { size: 8, align: :center, valign: :center, border: 0, style: :bold }
      @pdf.ibox 1.00, 2.08, 8.21, y_position + 3.00, "",
        I18n.t("danfe.others.page", current: page, total: @pdf.page_count), render_options
    end

    def render_no_fiscal_value
      @pdf.stamp("has_no_fiscal_value") if DanfeLib::Helper.has_no_fiscal_value?(@xml)
    end
  end
end
