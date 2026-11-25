module BrDanfe
  module DanfeLib
    module NfeLib
      class Ibscbstot
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

          render_totals
          render_monophasic_totals if self.class.monophasic?(@xml)
        end

        private

        def render_totals
          @pdf.lnumeric LINE_HEIGHT, 4.89, 0.75, @y_position, @xml, 'IBSCBSTot/gCBS/vCBS'
          @pdf.lnumeric LINE_HEIGHT, 4.89, 5.64, @y_position, @xml, 'IBSCBSTot/gIBS/gIBSUF/vIBSUF'
          @pdf.lnumeric LINE_HEIGHT, 4.89, 10.53, @y_position, @xml, 'IBSCBSTot/gIBS/gIBSMun/vIBSMun'
          @pdf.lnumeric LINE_HEIGHT, 4.89, 15.42, @y_position, @xml, 'ISTot/vIS'
        end

        def render_monophasic_totals
          y_position = @y_position + LINE_HEIGHT

          @pdf.lnumeric LINE_HEIGHT, 4.89, 0.75, y_position, @xml, 'IBSCBSTot/gMono/vIBSMono'
          @pdf.lnumeric LINE_HEIGHT, 4.89, 5.64, y_position, @xml, 'IBSCBSTot/gMono/vCBSMono'
          @pdf.inumeric LINE_HEIGHT, 4.89, 10.53, y_position, 'IBSCBSTot.gMono.vIBSMonoReten',
                        retention('IBSCBSTot/gMono/vIBSMonoReten')
          @pdf.inumeric LINE_HEIGHT, 4.89, 15.42, y_position, 'IBSCBSTot.gMono.vCBSMonoReten',
                        retention('IBSCBSTot/gMono/vCBSMonoReten')
        end

        def retention(xpath)
          @xml[xpath].to_f.positive? ? @xml[xpath] : ''
        end
      end
    end
  end
end
