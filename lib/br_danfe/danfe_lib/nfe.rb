module BrDanfe
  class DanfeNfe
    attr_reader :options

    def initialize(xml, options)
      @xml = xml
      @options = options
      @pdf = Danfe::NfeLib::Document.new

      create_watermark
    end

    def save_pdf(filename, footer_info = '')
      generate footer_info
      @pdf.render_file filename
    end

    def render_pdf(footer_info = '')
      generate footer_info
      @pdf.render
    end

    private

    def create_watermark
      @pdf.create_stamp('has_no_fiscal_value') do
        @pdf.fill_color '7d7d7d'
        @pdf.text_box I18n.t('danfe.others.has_no_fiscal_value'),
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
      render_on_first_page
      render_on_each_page footer_info
      @pdf
    end

    def render_on_first_page
      Danfe::NfeLib::Ticket.new(@pdf, @xml).render
      Danfe::NfeLib::Dest.new(@pdf, @xml).render
      Danfe::NfeLib::Dup.new(@pdf, @xml).render
      Danfe::NfeLib::Icmstot.new(@pdf, @xml).render
      Danfe::NfeLib::Transp.new(@pdf, @xml).render
      n_vol = Danfe::NfeLib::Vol.new(@pdf, @xml).render
      has_issqn = Danfe::NfeLib::Issqn.new(@pdf, @xml).render
      Danfe::NfeLib::Infadic.new(@pdf, @xml).render(n_vol)

      render_products has_issqn
    end

    def render_products(has_issqn)
      Danfe::NfeLib::DetBody.new(@pdf, @xml).render(has_issqn)
    end

    def render_on_each_page(footer_info)
      emitter = Danfe::NfeLib::EmitHeader.new(@pdf, @xml, @options.logo, @options.logo_dimensions)

      @pdf.page_count.times do |i|
        page = i + 1
        position = page == 1 ? 3.96 : 1.85
        repeated_information page, position, emitter, footer_info
      end
    end

    def repeated_information(page, y_position, emitter, footer_info)
      @pdf.go_to_page(page)

      emitter.render page, y_position
      render_product_table_title page
      render_footer_information footer_info
      render_no_fiscal_value
    end

    def render_product_table_title(page)
      y_position = page == 1 ? 18.91 : 7.40
      @pdf.ititle 0.42, 10.00, 0.75, y_position, 'det.title'
    end

    def render_footer_information(footer_info)
      if footer_info.present?
        @pdf.ibox 0.35, 12.45, 0.75, 30.21, '', footer_info, size: 5, border: 0
      end
    end

    def render_no_fiscal_value
      @pdf.stamp('has_no_fiscal_value') if Danfe::NfeLib::Helper.no_fiscal_value?(@xml)
    end
  end
end
