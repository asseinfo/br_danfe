module BrDanfe
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

    private
    def create_watermark
      @pdf.create_stamp("without_fiscal_value") do
        @pdf.fill_color "7d7d7d"
        @pdf.text_box I18n.t("danfe.others.without_fiscal_value"),
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
      @pdf.stamp("without_fiscal_value") if Helper.without_fiscal_value?(@xml)

      det = Det.new(@pdf, @xml)
      emit = Emit.new(@pdf, @xml, @options.logo_path)
      dest = Dest.new(@pdf, @xml)
      vol = Vol.new(@pdf, @xml)
      infadic = Infadic.new(@pdf, @xml)
      dup = Dup.new(@pdf, @xml)

      @pdf.repeat :all do
        Ticket.render(@pdf, @xml)
        emit.render
        dest.render
        dup.render
        Icmstot.render(@pdf, @xml)
        Transp.render(@pdf, @xml)
        nVol = vol.render
        det.render_header
        Issqn.render(@pdf, @xml)
        infadic.render(nVol)
      end

      det.render_body

      @pdf.page_count.times do |i|
        @pdf.go_to_page(i + 1)
        @pdf.ibox 1.00, 2.08, 8.71, 5.54, "",
          I18n.t("danfe.others.page", current: i+1, total: @pdf.page_count),
          { size: 8, align: :center, valign: :center, border: 0, style: :bold }
      end

      @pdf
    end
  end
end
