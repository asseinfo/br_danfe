module BrDanfe
  module Logo
    class Options
      def initialize(bounding_box_size, logo_dimensions)
        @bounding_box_size = bounding_box_size
        @logo_width = logo_dimensions[:width]
        @logo_height = logo_dimensions[:height]
      end

      def options
        logo_options = dimensions
        logo_options[:position] = :center
        logo_options[:vposition] = :center
        logo_options
      end

      private

      def dimensions
        @logo_width > @logo_height ? { width: calculate_size(@logo_width) } : { height: calculate_size(@logo_height) }
      end

      def calculate_size(size)
        size < @bounding_box_size ? size : @bounding_box_size
      end
    end
  end
end
