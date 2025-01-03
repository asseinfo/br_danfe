module BrDanfe
  module DanfeLib
    module NfeLib
      class Dup
        attr_reader :y_position

        Y_POSITION = 12.92

        def initialize(pdf, xml)
          @pdf = pdf
          @xml = xml

          @y_position = Entrega.delivery_local?(@xml) ? Y_POSITION + 3.00 : Y_POSITION

          @ltitle = @y_position - 0.42
        end

        def render
          x = 0.75
          y = @y_position

          @pdf.ititle 0.42, 10.00, x, @ltitle, 'dup.title'

          render_titles_and_box(x, y)
          det_count = 0

          @xml.collect('xmlns', 'dup') do |det|
            if det_count < 6
              y = @y_position - 0.015
            else
              if det_count == 6
                x = 0.75
              end
              y = @y_position + 0.185
            end

            render_dup(det, x, y + 0.3)
            x += 3.261666667
            det_count += 1
          end
        end

        private

        def render_titles_and_box(x, y)
          6.times do
            @pdf.ibox 0.30, 3.261666667, x, y
            @pdf.ibox 0.60, 3.261666667, x, y + 0.30
            @pdf.ibox 0.85, 1.80, x, y - 0.05, '', I18n.t('danfe.dup.nDup'), normal
            @pdf.ibox 0.85, 1.80, x + 0.87, y - 0.05, '', I18n.t('danfe.dup.dVenc'), normal
            @pdf.ibox 0.85, 1.80, x + 2.35, y - 0.05, '', I18n.t('danfe.dup.vDup'), normal
            x += 3.261666667
          end
        end

        def render_dup(det, x, y)
          @pdf.ibox 0.85, 2.12, x + 0.1, y, '', det.css('nDup').text, normal
          @pdf.ibox 0.85, 2.12, x + 0.75, y, '', dtduplicata(det), normal
          @pdf.inumeric 0.85, 2.12, x + 1.1, y, '', det.css('vDup').text, normal
        end

        def dtduplicata(det)
          dtduplicata = det.css('dVenc').text
          "#{dtduplicata[8, 2]}/#{dtduplicata[5, 2]}/#{dtduplicata[0, 4]}"
        end

        def normal
          { size: 6, border: 0 }
        end
      end
    end
  end
end
