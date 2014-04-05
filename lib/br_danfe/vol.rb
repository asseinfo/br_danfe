module BrDanfe
  class Vol
    def initialize(pdf, xml)
      @pdf = pdf
      @xml = xml
    end

    def render
      nVol = 0

      @xml.collect("xmlns", "vol") do |det|
        nVol += 1
        render_vol(det) if nVol < 2
      end

      nVol
    end

    private
    def render_vol(det)
      @pdf.ibox 0.85, 2.92, 0.25, 16.60, I18n.t("danfe.vol.qVol"), det.css("qVol").text
      @pdf.ibox 0.85, 3.05, 3.17, 16.60, I18n.t("danfe.vol.esp"), det.css("esp").text
      @pdf.ibox 0.85, 3.05, 6.22, 16.60, I18n.t("danfe.vol.marca"), det.css("marca").text
      @pdf.ibox 0.85, 4.83, 9.27, 16.60, I18n.t("danfe.vol.nVol")
      @pdf.inumeric 0.85, 3.43, 14.10, 16.60, "vol.pesoB", det.css("pesoB").text, { decimals: 3 }
      @pdf.inumeric 0.85, 3.30, 17.53, 16.60, "vol.pesoL", det.css("pesoL").text, { decimals: 3 }
    end
  end
end
