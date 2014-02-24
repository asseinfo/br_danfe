module BrDanfe
  class Infadic
    def self.render(pdf, xml, nVol)
      pdf.ititle 0.42, 10.00, 0.25, 25.91, "infAdic.title"

      if nVol > 1
        self.render_extra_volumes(pdf, xml)
      else
        pdf.ibox 3.07, 12.93, 0.25, 26.33, I18n.t("danfe.infAdic.infCpl"), xml["infAdic/infCpl"], {size: 6, valign: :top}
      end

      pdf.ibox 3.07, 7.62, 13.17, 26.33, I18n.t("danfe.infAdic.reserved")
    end

    private
    def self.render_extra_volumes(pdf, xml)
      pdf.ibox 3.07, 12.93, 0.25, 26.33, I18n.t("danfe.infAdic.infCpl"), "", {size: 8, valign: :top}
      pdf.ibox 3.07, 12.93, 0.25, 26.60, "", I18n.t("danfe.infAdic.vol.title"), {size: 5, valign: :top, border: 0}

      volumes = 0
      y = 26.67
      xml.collect("xmlns", "vol") do |det|
        volumes += 1
        if volumes > 1
          self.render_extra_volume(pdf, det, y + 0.10)
          y += 0.15
        end
      end

      pdf.ibox 2.07, 12.93, 0.25, y + 0.30, "", I18n.t("danfe.infAdic.others"), { size: 6, valign: :top, border: 0 }
      pdf.ibox 2.07, 12.93, 0.25, y + 0.50, "", xml["infAdic/infCpl"], { size: 5, valign: :top, border: 0 }
    end

    def self.render_extra_volume(pdf, xml, y)
      normal = { size: 4, border: 0 }
      italic = normal.merge({ style: :italic })
      decimal = italic.merge({ decimals: 3 })

      pdf.ibox 0.35, 0.70, 0.25, y, "", I18n.t("danfe.infAdic.vol.qVol"), normal
      pdf.ibox 0.35, 0.70, 0.90, y, "", xml.css("qVol").text, italic
      pdf.ibox 0.35, 0.50, 1.35, y, "", I18n.t("danfe.infAdic.vol.esp"), normal
      pdf.ibox 0.35, 3.00, 1.75, y, "", xml.css("esp").text, italic
      pdf.ibox 0.35, 0.70, 4.15, y, "", I18n.t("danfe.infAdic.vol.marca"), normal
      pdf.ibox 0.35, 2.00, 4.75, y, "", xml.css("marca").text, italic
      pdf.ibox 0.35, 1.00, 6.10, y, "", I18n.t("danfe.infAdic.vol.nVol"), normal
      pdf.ibox 0.35, 1.00, 6.70, y, "", xml.css("nVol").text, italic
      pdf.ibox 0.35, 1.30, 7.00, y, "", I18n.t("danfe.infAdic.vol.pesoB"), normal
      pdf.inumeric 0.35, 1.30, 7.00, y, "", xml.css("pesoB").text, decimal
      pdf.ibox 0.35, 0.90, 8.50, y, "", I18n.t("danfe.infAdic.vol.pesoL"), normal
      pdf.inumeric 0.35, 1.50, 8.50, y, "", xml.css("pesoL").text, decimal
    end
  end
end
