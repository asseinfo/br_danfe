module BrDanfe
  module CceLib
    class Header
      def initialize(pdf)
        @pdf = pdf
      end

      def render
        @pdf.box(height: 40) do
          @pdf.text I18n.t("cce.title"), align: :center, size: 25, pad: 6
        end
      end
    end
  end
end
