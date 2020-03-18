module BrDanfe
  module CceLib
    class Footer
      def initialize(pdf)
        @pdf = pdf
      end

      def render
        @pdf.box(height: 110) do
          @pdf.text I18n.t('cce.legal_note')
        end
      end
    end
  end
end
