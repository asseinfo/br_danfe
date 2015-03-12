module BrDanfe
  module DanfeLib
    class Dup
      Y = 11.50

      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml

        @ltitle = Y - 0.42
      end

      def render
        @pdf.ititle 0.42, 10.00, 0.25, @ltitle, "dup.title"
        @pdf.ibox 0.85, 20.57, 0.25, Y

        x = 0.25
        y = Y
        @xml.collect("xmlns", "dup") do |det|
          render_dup(det, x, y)
          x += 2.30
        end
      end

      private
      def render_dup(det, x, y)
        @pdf.ibox 0.85, 2.12, x, y, "", I18n.t("danfe.dup.nDup"), italic
        @pdf.ibox 0.85, 2.12, x + 0.70, y, "", det.css("nDup").text, normal
        @pdf.ibox 0.85, 2.12, x, y + 0.20, "", I18n.t("danfe.dup.dVenc"), italic

        @pdf.ibox 0.85, 2.12, x + 0.70, y + 0.20, "", dtduplicata(det), normal

        @pdf.ibox 0.85, 2.12, x, y + 0.40, "", I18n.t("danfe.dup.vDup"), italic
        @pdf.inumeric 0.85, 1.25, x + 0.70, y + 0.40, "", det.css("vDup").text, normal
      end

      def dtduplicata(det)
        dtduplicata = det.css("dVenc").text
        dtduplicata = dtduplicata[8,2] + "/" + dtduplicata[5, 2] + "/" + dtduplicata[0, 4]
        dtduplicata
      end

      def normal
        { size: 6, border: 0 }
      end

      def italic
        normal.merge({ style: :italic })
      end
    end
  end
end
