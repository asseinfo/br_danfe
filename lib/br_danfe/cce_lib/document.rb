module BrDanfe
  module CceLib
    class Document
      def initialize
        @document = Prawn::Document.new(
          page_size: "A4",
          page_layout: :portrait,
          left_margin: 30,
          right_margin: 30,
          top_margin: 30,
          botton_margin: 30)

        @document.font "Times-Roman"
        @document.line_width = 0.3
      end

      def method_missing(method_name, *args, &block)
        @document.send(method_name, *args, &block)
      end

      def box(height:, pad:5, &block)
        bounding_box([0, cursor], width: page_width, height: height) do
          pad(pad) { indent(pad) { yield if block_given? } }
          stroke_bounds
        end
      end

      def text(text, options = {})
        pad = options.delete(:pad) || 0
        options = { align: :left, size: 12, style: nil }.merge(options)

        pad(pad) do
          @document.text text, size: options[:size], style: options[:style],
            align: options[:align]
        end
      end

      private
      def page_width
        page.dimensions[2] - (page.margins[:left] + page.margins[:right])
      end
    end
  end
end
