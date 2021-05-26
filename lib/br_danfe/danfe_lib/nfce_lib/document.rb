module BrDanfe
  module DanfeLib
    module NfceLib
      class Document
        def initialize(page_width, page_height)
          @document = BrDanfe::DocumentBuilder.build(
            page_size: [page_width, page_height],
            page_layout: :portrait,
            left_margin: 0.3.cm,
            right_margin: 0.3.cm,
            top_margin: 0.3.cm,
            botton_margin: 0
          )

          @document.font 'Courier'
          @document.line_width = 0.3

          create_watermark(page_height)
        end

        def render_blank_line(font_size = 6)
          @document.text ' ', size: font_size
        end

        def method_missing(method_name, *args, &block)
          if @document.respond_to? method_name
            @document.send method_name, *args, &block
          else
            super
          end
        end

        def respond_to_missing?(method_name, include_private = false)
          @document.respond_to?(method_name, include_private) || super
        end

        private

        def create_watermark(page_height)
          @document.create_stamp('has_no_fiscal_value') do
            @document.fill_color '7d7d7d'
            @document.text_box I18n.t('danfe.others.has_no_fiscal_value'),
                      size: 0.8.cm,
                      width: 10.cm,
                      height: 1.2.cm,
                      at: [0, page_height - 3.8.cm],
                      rotate: 45,
                      rotate_around: :center
          end
        end
      end
    end
  end
end
