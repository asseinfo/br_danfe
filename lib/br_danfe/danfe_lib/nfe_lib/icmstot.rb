module BrDanfe
  module DanfeLib
    module NfeLib
      class Icmstot
        attr_reader :y_position

        Y_POSITION = 13.77 + SPACE_BETWEEN_GROUPS
        FIELD_WIDTH = CONTENT_WIDTH / 4
        FCP_DIFAL_TOTALS = %w[ICMSTot/vFCP ICMSTot/vFCPST ICMSTot/vICMSUFDest ICMSTot/vFCPUFDest].freeze
        MONOPHASIC_TOTALS = %w[ICMSTot/qBCMono ICMSTot/vICMSMono ICMSTot/qBCMonoReten ICMSTot/vICMSMonoReten].freeze

        def self.conditional_lines(xml)
          return [] unless RtcLayout.applies?(xml)

          lines = []
          lines << FCP_DIFAL_TOTALS if FCP_DIFAL_TOTALS.any? { |xpath| xml[xpath].to_f.positive? }
          lines << MONOPHASIC_TOTALS if MONOPHASIC_TOTALS.any? { |xpath| xml[xpath].present? }
          lines
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
          self.class.conditional_lines(@xml).each_with_index do |xpaths, line|
            y_position = @l2 + (LINE_HEIGHT * (line + 1))

            xpaths.each_with_index do |xpath, index|
              @pdf.lnumeric LINE_HEIGHT, FIELD_WIDTH, 0.75 + (index * FIELD_WIDTH), y_position, @xml, xpath
            end
          end
        end
      end
    end
  end
end
