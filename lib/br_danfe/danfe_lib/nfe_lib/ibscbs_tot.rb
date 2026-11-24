module BrDanfe
  module DanfeLib
    module NfeLib
      class IbscbsTot
        Y_POSITION = 15.89 + SPACE_BETWEEN_GROUPS
        FIELD_WIDTH = CONTENT_WIDTH / 4

        TOTALS = %w[IBSCBSTot/gCBS/vCBS IBSCBSTot/gIBS/gIBSUF/vIBSUF IBSCBSTot/gIBS/gIBSMun/vIBSMun ISTot/vIS].freeze
        MONOPHASIC_TOTALS = %w[
          IBSCBSTot/gMono/vIBSMono IBSCBSTot/gMono/vCBSMono IBSCBSTot/gMono/vIBSMonoReten IBSCBSTot/gMono/vCBSMonoReten
        ].freeze

        def self.offset(xml)
          return 0 unless RtcLayout.applies?(xml)

          lines = monophasic?(xml) ? 2 : 1
          (LINE_HEIGHT * lines) + SPACE_BETWEEN_GROUPS
        end

        def self.monophasic?(xml)
          xml['IBSCBSTot/gMono'].present?
        end

        def initialize(pdf, xml)
          @pdf = pdf
          @xml = xml
          @y_position = Entrega.delivery_local?(@xml) ? Y_POSITION + 3.00 : Y_POSITION
          @y_position += Icmstot.offset(@xml)
        end

        def render
          return unless RtcLayout.applies?(@xml)

          @pdf.ititle 0.42, 10.00, 0.75, @y_position - 0.42, 'IBSCBSTot.title'

          render_line TOTALS, @y_position
          render_line MONOPHASIC_TOTALS, @y_position + LINE_HEIGHT if self.class.monophasic?(@xml)
        end

        private

        def render_line(xpaths, y_position)
          xpaths.each_with_index do |xpath, index|
            @pdf.lnumeric LINE_HEIGHT, FIELD_WIDTH, 0.75 + (index * FIELD_WIDTH), y_position, @xml, xpath
          end
        end
      end
    end
  end
end
