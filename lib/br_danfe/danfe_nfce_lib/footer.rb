module BrDanfe
  module DanfeNfceLib
    class Footer
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def render
        @pdf.box(height: 110) do
          @pdf.text I18n.t('cce.legal_note')
        end
      end
    end
  end
end
