module BrDanfe
  class DanfeNfce
    PAGE_WIDTH = 8.cm
    PAGE_HEIGHT = 100.cm

    attr_reader :options

    def initialize(xml)
      @xml = DanfeNfceLib::XML.new(xml)
      @pdf = DanfeNfceLib::Document.new(PAGE_WIDTH, PAGE_HEIGHT)
      @options = BrDanfe::Helper::Logo::Config.new
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
      DanfeNfceLib::Header.new(@pdf, @xml, @options.logo, @options.logo_dimensions).render
      DanfeNfceLib::ProductList.new(@pdf, @xml).render
      DanfeNfceLib::TotalList.new(@pdf, @xml).render
      DanfeNfceLib::Key.new(@pdf, @xml).render
      DanfeNfceLib::Recipient.new(@pdf, @xml).render
      DanfeNfceLib::NfceIdentification.new(@pdf, @xml).render
      DanfeNfceLib::QrCode.new(@pdf, @xml).render
      DanfeNfceLib::Footer.new(@pdf, @xml).render

      grid
      resize_page_height
    end

    def resize_page_height
      @pdf.page.dictionary.data[:MediaBox] = [0, @pdf.y - 10, PAGE_WIDTH, PAGE_HEIGHT]
    end

    #FIXME: REMOVER
    def grid
      @pdf.canvas { stroke_grid }
    end

    def stroke_grid(options = {})
      options = { at: [0, 0], height: @pdf.bounds.height.to_i - (options[:at] || [0, 0])[1], width: @pdf.bounds.width.to_i - (options[:at] || [0, 0])[0], step_length: 50, negative_axes_length: 0, color: '000000' }.merge(options)
      Prawn.verify_options([:at, :width, :height, :step_length, :negative_axes_length, :color], options)

      @pdf.save_graphics_state do
        @pdf.fill_color(options[:color])
        @pdf.stroke_color(options[:color])
        @pdf.stroke_bounds
        @pdf.fill_circle(options[:at], 1)

        (0..options[:width]).step(5) do |point|
          @pdf.transparent(0.2) do
            @pdf.stroke_vertical_line(options[:at][1], options[:at][1] + options[:height], at: options[:at][0] + point)
          end
        end
      end
    end
  end
end
