module BrDanfe
  module DanfeLib
    module NfeLib
      class Ibscbstot
        TOTALS = [
          'IBSCBSTot/gCBS/vCBS', 'IBSCBSTot/gIBS/gIBSUF/vIBSUF', 'IBSCBSTot/gIBS/gIBSMun/vIBSMun', 'ISTot/vIS'
        ].freeze
        MONOPHASIC_TOTALS = ['IBSCBSTot/gMono/vIBSMono', 'IBSCBSTot/gMono/vCBSMono'].freeze
        RETENTION_TOTALS = ['IBSCBSTot/gMono/vIBSMonoReten', 'IBSCBSTot/gMono/vCBSMonoReten'].freeze
        private_constant :TOTALS, :MONOPHASIC_TOTALS, :RETENTION_TOTALS

        def self.offset(xml)
          return 0.0 unless RtcLayout.applies?(xml)

          lines = monophasic?(xml) ? 2 : 1
          (LINE_HEIGHT * lines) + SPACE_BETWEEN_GROUPS
        end

        def self.monophasic?(xml)
          xml['IBSCBSTot/gMono'].present?
        end

        def initialize(pdf, xml)
          @pdf = pdf
          @xml = xml
          @y_position = Entrega.delivery_local?(@xml) ? Transp::Y_POSITION + 3.00 : Transp::Y_POSITION
          @y_position += Icmstot.offset(@xml)
        end

        def render
          return unless RtcLayout.applies?(@xml)

          @pdf.ititle 0.42, 10.00, 0.75, @y_position - 0.42, 'IBSCBSTot.title'

          @pdf.lnumeric_line LINE_HEIGHT, CONTENT_WIDTH, 0.75, @y_position, @xml, TOTALS
          return unless self.class.monophasic?(@xml)

          @pdf.inumeric_line LINE_HEIGHT, CONTENT_WIDTH, 0.75, @y_position + LINE_HEIGHT, monophasic_fields
        end

        private

        def monophasic_fields
          (MONOPHASIC_TOTALS + RETENTION_TOTALS).to_h do |xpath|
            retention_without_value = RETENTION_TOTALS.include?(xpath) && !@xml[xpath].to_f.positive?
            [xpath.tr('/', '.'), retention_without_value ? '' : @xml[xpath]]
          end
        end
      end
    end
  end
end
