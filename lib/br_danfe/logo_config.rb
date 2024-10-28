module BrDanfe
  module Logo
    class Config
      attr_accessor :logo, :logo_dimensions

      def initialize(new_options = {})
        @logo = new_options[:logo] || ''
        @logo_dimensions = new_options[:logo_dimensions] || {}
      end
    end
  end
end
