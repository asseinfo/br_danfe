module BrDanfe
  module MdfeLib
    class Document
      def initialize
        @document = BrDanfe::DocumentBuilder.build(
          page_size: 'A4',
          page_layout: :portrait
        )

        @document.font 'tinos'
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
