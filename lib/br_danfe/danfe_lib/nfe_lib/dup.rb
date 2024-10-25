module BrDanfe
  module DanfeLib
    module NfeLib
      class Dup
        Y = 12.92

        def initialize(pdf, xml)
          @pdf = pdf
          @xml = xml
        end

        def render(has_delivery)
          y_value = has_delivery ? Y + 3.00 : Y
          @ltitle = y_value - 0.42

          @pdf.ititle 0.42, 10.00, 0.75, @ltitle, 'dup.title'
          @pdf.ibox 0.85, 19.57, 0.75, y_value

          x = 0.75
          y = y_value
          @xml.collect('xmlns', 'dup') do |det|
            render_dup(det, x, y)
            x += 2.30
          end
        end

        private

        def render_dup(det, x, y)
          @pdf.ibox 0.85, 2.12, x, y, '', I18n.t('danfe.dup.nDup'), italic
          @pdf.ibox 0.85, 2.12, x + 0.70, y, '', det.css('nDup').text, normal
          @pdf.ibox 0.85, 2.12, x, y + 0.20, '', I18n.t('danfe.dup.dVenc'), italic

          @pdf.ibox 0.85, 2.12, x + 0.70, y + 0.20, '', dtduplicata(det), normal

          @pdf.ibox 0.85, 2.12, x, y + 0.40, '', I18n.t('danfe.dup.vDup'), italic
          @pdf.inumeric 0.85, 1.25, x + 0.70, y + 0.40, '', det.css('vDup').text, normal
        end

        def dtduplicata(det)
          dtduplicata = det.css('dVenc').text
          "#{dtduplicata[8, 2]}/#{dtduplicata[5, 2]}/#{dtduplicata[0, 4]}"
        end

        def normal
          { size: 6, border: 0 }
        end

        def italic
          normal.merge(style: :italic)
        end
      end
    end
  end
end
