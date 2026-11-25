module BrDanfe
  module DanfeLib
    module NfeLib
      class Icmstot
        attr_reader :y_position

        Y_POSITION = 13.77 + SPACE_BETWEEN_GROUPS
        CONDITIONAL_LINES = {
          fcp_difal: ['ICMSTot/vFCP', 'ICMSTot/vFCPST', 'ICMSTot/vICMSUFDest', 'ICMSTot/vFCPUFDest'],
          monophasic: ['ICMSTot/qBCMono', 'ICMSTot/vICMSMono', 'ICMSTot/qBCMonoReten', 'ICMSTot/vICMSMonoReten']
        }.freeze
        private_constant :CONDITIONAL_LINES

        def self.conditional_lines(xml)
          return [] unless RtcLayout.applies?(xml)

          CONDITIONAL_LINES.select { |_line, xpaths| xpaths.any? { |xpath| xml[xpath].to_f.positive? } }.keys
        end

        def self.offset(xml)
          conditional_lines(xml).size * LINE_HEIGHT
        end

        def initialize(pdf, xml)
          @pdf = pdf
          @xml = xml

          @y_position = Entrega.delivery_local?(@xml) ? Y_POSITION + 3.00 : Y_POSITION

          @ltitle = @y_position - 0.42
          @l1 = @y_position
          @l2 = @y_position + LINE_HEIGHT
        end

        def render
          @pdf.ititle 0.42, 5.60, 0.75, @ltitle, 'ICMSTot.title'

          @pdf.lnumeric LINE_HEIGHT, 3.56, 0.75, @l1, @xml, 'ICMSTot/vBC'
          @pdf.lnumeric LINE_HEIGHT, 4.06, 4.31, @l1, @xml, 'ICMSTot/vICMS'
          @pdf.lnumeric LINE_HEIGHT, 4.06, 8.37, @l1, @xml, 'ICMSTot/vBCST'
          @pdf.lnumeric LINE_HEIGHT, 4.06, 12.43, @l1, @xml, 'ICMSTot/vST'
          @pdf.lnumeric LINE_HEIGHT, 3.82, 16.49, @l1, @xml, 'ICMSTot/vProd'

          @pdf.lnumeric LINE_HEIGHT, 2.55, 0.75, @l2, @xml, 'ICMSTot/vFrete'
          @pdf.lnumeric LINE_HEIGHT, 3.05, 3.30, @l2, @xml, 'ICMSTot/vSeg'
          @pdf.lnumeric LINE_HEIGHT, 3.04, 6.35, @l2, @xml, 'ICMSTot/vDesc'
          @pdf.lnumeric LINE_HEIGHT, 3.04, 9.39, @l2, @xml, 'ICMSTot/vOutro'
          @pdf.lnumeric LINE_HEIGHT, 4.06, 12.43, @l2, @xml, 'ICMSTot/vIPI'
          @pdf.lnumeric LINE_HEIGHT, 3.82, 16.49, @l2, @xml, 'ICMSTot/vNF', style: :bold

          render_conditional_lines
        end

        private

        def render_conditional_lines
          y_position = @l2

          self.class.conditional_lines(@xml).each do |line|
            y_position += LINE_HEIGHT
            line == :fcp_difal ? render_fcp_difal_line(y_position) : render_monophasic_line(y_position)
          end
        end

        def render_fcp_difal_line(y_position)
          @pdf.lnumeric LINE_HEIGHT, 4.89, 0.75, y_position, @xml, 'ICMSTot/vFCP'
          @pdf.lnumeric LINE_HEIGHT, 4.89, 5.64, y_position, @xml, 'ICMSTot/vFCPST'
          @pdf.lnumeric LINE_HEIGHT, 4.89, 10.53, y_position, @xml, 'ICMSTot/vICMSUFDest'
          @pdf.lnumeric LINE_HEIGHT, 4.89, 15.42, y_position, @xml, 'ICMSTot/vFCPUFDest'
        end

        def render_monophasic_line(y_position)
          @pdf.lnumeric LINE_HEIGHT, 4.89, 0.75, y_position, @xml, 'ICMSTot/qBCMono'
          @pdf.lnumeric LINE_HEIGHT, 4.89, 5.64, y_position, @xml, 'ICMSTot/vICMSMono'
          @pdf.lnumeric LINE_HEIGHT, 4.89, 10.53, y_position, @xml, 'ICMSTot/qBCMonoReten'
          @pdf.lnumeric LINE_HEIGHT, 4.89, 15.42, y_position, @xml, 'ICMSTot/vICMSMonoReten'
        end
      end
    end
  end
end
