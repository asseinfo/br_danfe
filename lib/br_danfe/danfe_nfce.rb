module BrDanfe
  class DanfeNfce
    PAGE_WIDTH = 8.cm
    PAGE_HEIGHT = 100.cm

    attr_reader :options

    def initialize(xml)
      @xml = DanfeNfceLib::XML.new(xml)
      @pdf = DanfeNfceLib::Document.new(PAGE_WIDTH, PAGE_HEIGHT)
      @options = DanfeLib::Options.new # FIXME: centralizar
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
      # DanfeNfceLib::QrCode.new(@pdf, @xml).render
      # DanfeNfceLib::Footer.new(@pdf, @xml).render

      # grid
      @pdf.page.dictionary.data[:MediaBox] = [0, @pdf.y - 10, PAGE_WIDTH, PAGE_HEIGHT]
    end

    def grid
      @pdf.canvas { stroke_grid }
      1.times { @pdf.text(' ') }
    end

    def stroke_grid(options = {})
      options = { at: [0, 0], height: @pdf.bounds.height.to_i - (options[:at] || [0, 0])[1], width: @pdf.bounds.width.to_i - (options[:at] || [0, 0])[0], step_length: 50, negative_axes_length: 0, color: '000000' }.merge(options)
      Prawn.verify_options([:at, :width, :height, :step_length, :negative_axes_length, :color], options)

      @pdf.save_graphics_state do
        @pdf.fill_color(options[:color])
        @pdf.stroke_color(options[:color])

        @pdf.stroke_bounds

        @pdf.fill_circle(options[:at], 1)

        (options[:step_length]..options[:width]).step(options[:step_length]) do |point|
          @pdf.fill_circle([options[:at][0] + point, options[:at][1]], 1)
          @pdf.draw_text(point, at: [options[:at][0] + point - 5, options[:at][1] + 10], size: 7)
        end

        (options[:step_length]..options[:height]).step(options[:step_length]) do |point|
          @pdf.fill_circle([options[:at][0], options[:at][1] + point], 1)
          @pdf.draw_text(point, at: [options[:at][0] + 10, options[:at][1] + point - 2], size: 7)
        end

        @pdf.line_width = 0.5
        (0..options[:height]).step(5) do |point|
          tp = point % 50 == 0 ? 0.5 : 0.1
          @pdf.transparent(tp) do
            @pdf.stroke_horizontal_line(options[:at][0], options[:at][0] + options[:width], at: options[:at][1] + point)
          end
        end

        (0..options[:width]).step(5) do |point|
          tp = point % 50 == 0 ? 0.5 : 0.1
          @pdf.transparent(tp) do
            @pdf.stroke_vertical_line(options[:at][1], options[:at][1] + options[:height], at: options[:at][0] + point)
          end
        end
      end
    end

    # @pdf.ibox 1, 7.6, 0.0, 6.6, '', @xml['emit/xNome'], { size: 7, align: :center, border: 0, style: :bold }
    # @pdf.iboxI 1, 7.65, 0, 0, '', '--------', { size: 7, align: :center, border: 1, style: :bold }
    # @pdf.iboxI 1, 7.65, 0, 0, '', '------- [1] -------', { size: 7, align: :center, border: 1, style: :bold }
    # @pdf.iboxI 0.35, 7.65, 0, 0, '', '[2] ------- -------', { size: 7, align: :center, border: 1, style: :bold }
    # @pdf.iboxI 0.85, 7.65, 0, 0, '', '------- ------- [3]', { size: 7, align: :center, border: 1, style: :bold }

    # @pdf.text @xml['emit/xNome'] + '<>', { size: 7, align: :center, border: 1, style: :bold }
    # @pdf.text "Hello World 12327362678 3284assdasds dfsdfsdfsdfs dfsdfsdfsd", :at => [0, 0], height: 4, width: 2

    # def ibox(h, w, x, y, title = '', info = '', options = {})
    #   box [x.cm, Helper.invert(y.cm)], w.cm, h.cm, title, info, options
    # address_company

    # pdf.bounding_box([40,50], :width => 800, :height => 1150) do
    #   pdf.text @application.name
    #   pdf.text @application.address.try(:split, '|').select{|x| !x.blank?}.join("\n") rescue ''
    # end
  end
end
