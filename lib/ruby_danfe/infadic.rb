module RubyDanfe
  class Infadic
    def self.render(pdf, xml, nVol)
      pdf.ititle 0.42, 10.00, 0.25, 25.91, "infAdic.title"

      if nVol > 1
        pdf.ibox 3.07, 12.93, 0.25, 26.33, I18n.t("danfe.infAdic.infCpl"), "", {size: 8, valign: :top}
        pdf.ibox 3.07, 12.93, 0.25, 26.60, "", I18n.t("danfe.infAdic.vol.title"), {size: 5, valign: :top, border: 0}
        v = 0
        y = 26.67
        xml.collect("xmlns", "vol") do |det|
          v += 1
          if v > 1
            pdf.ibox 0.35, 0.70, 0.25, y + 0.10, "", I18n.t("danfe.infAdic.vol.qVol"), { size: 4, border: 0 }
            pdf.ibox 0.35, 0.70, 0.90, y + 0.10, "", det.css("qVol").text, { size: 4, border: 0, style: :italic }
            pdf.ibox 0.35, 0.50, 1.35, y + 0.10, "", I18n.t("danfe.infAdic.vol.esp"), { size: 4, border: 0 }
            pdf.ibox 0.35, 3.00, 1.75, y + 0.10, "", det.css("esp").text, { size: 4, border: 0, style: :italic }
            pdf.ibox 0.35, 0.70, 4.15, y + 0.10, "", I18n.t("danfe.infAdic.vol.marca"), { size: 4, border: 0 }
            pdf.ibox 0.35, 2.00, 4.75, y + 0.10, "", det.css("marca").text, { size: 4, border: 0, style: :italic }
            pdf.ibox 0.35, 1.00, 6.10, y + 0.10, "", I18n.t("danfe.infAdic.vol.nVol"),  { size: 4, border: 0 }
            pdf.ibox 0.35, 1.30, 7.00, y + 0.10, "", I18n.t("danfe.infAdic.vol.pesoB"), { size: 4, border: 0 }
            pdf.inumeric 0.35, 1.30, 7.00, y + 0.10, "", det.css("pesoB").text, {decimals: 3, size: 4, border: 0, style: :italic }
            pdf.ibox 0.35, 0.90, 8.50, y + 0.10, "", I18n.t("danfe.infAdic.vol.pesoL"), { size: 4, border: 0 }
            pdf.inumeric 0.35, 1.50, 8.50, y + 0.10, "", det.css("pesoL").text, {decimals: 3, size: 4, border: 0, style: :italic }
            y = y + 0.15
          end
        end
        pdf.ibox 2.07, 12.93, 0.25, y + 0.30, "", I18n.t("danfe.infAdic.others"), {size: 6, valign: :top, border: 0}
        pdf.ibox 2.07, 12.93, 0.25, y + 0.50, "", xml["infAdic/infCpl"], {size: 5, valign: :top, border: 0}
      else
         pdf.ibox 3.07, 12.93, 0.25, 26.33, I18n.t("danfe.infAdic.infCpl"), xml["infAdic/infCpl"], {size: 6, valign: :top}
      end

      pdf.ibox 3.07, 7.62, 13.17, 26.33, I18n.t("danfe.infAdic.reserved")
    end
  end
end
