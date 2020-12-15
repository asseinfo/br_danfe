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
      end
    end
  end
end
