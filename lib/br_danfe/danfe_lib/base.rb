module BrDanfe
  module DanfeLib
    class Base
      attr_reader :options
      attr_writer :canceled

      def initialize(xmls)
        @xmls = xmls
        @document = document
        @options = BrDanfe::Logo::Config.new
        @canceled = false

        create_watermark
      end

      def save_pdf(filename, footer_info = '')
        generate footer_info
        @document.render_file filename
      end

      def render_pdf(footer_info = '')
        generate footer_info
        @document.render
      end

      private

      def document; end

      def create_watermark; end

      def generate(footer_info); end
    end
  end
end
