module BrDanfe
  class Dup
    def self.render(pdf, xml)
      pdf.ititle 0.42, 10.00, 0.25, 11.12, "dup.title"
      pdf.ibox 0.85, 20.57, 0.25, 11.51

      x = 0.25
      y = 11.51
      xml.collect("xmlns", "dup") do |det|
        normal = { size: 6, border: 0 }
        italic = normal.merge({ style: :italic })

        pdf.ibox 0.85, 2.12, x, y, "", I18n.t("danfe.dup.nDup"), italic
        pdf.ibox 0.85, 2.12, x + 0.70, y, "", det.css("nDup").text, normal
        pdf.ibox 0.85, 2.12, x, y + 0.20, "", I18n.t("danfe.dup.dVenc"), italic
        dtduplicata = det.css("dVenc").text
        dtduplicata = dtduplicata[8,2] + "/" + dtduplicata[5, 2] + "/" + dtduplicata[0, 4]
        pdf.ibox 0.85, 2.12, x + 0.70, y + 0.20, "", dtduplicata, normal
        pdf.ibox 0.85, 2.12, x, y + 0.40, "", I18n.t("danfe.dup.vDup"), italic
        pdf.inumeric 0.85, 1.25, x + 0.70, y + 0.40, "", det.css("vDup").text, normal
        x = x + 2.30
      end
    end
  end
end
