module BrDanfe
  class Infadic
    def initialize(pdf, xml)
      @pdf = pdf
      @xml = xml
    end

    def render(nVol)
      @pdf.ititle 0.42, 10.00, 0.25, 25.91, "infAdic.title"

      if nVol > 1
        render_extra_volumes
      else
        @pdf.ibox 3.07, 12.93, 0.25, 26.33, I18n.t("danfe.infAdic.infCpl"), @xml["infAdic/infCpl"], { size: 6, valign: :top }
      end

      @pdf.ibox 3.07, 7.62, 13.17, 26.33, I18n.t("danfe.infAdic.reserved")
    end

    private
    def render_extra_volumes
      @pdf.ibox 3.07, 12.93, 0.25, 26.33, I18n.t("danfe.infAdic.infCpl"), "", { size: 8, valign: :top }
      @pdf.ibox 3.07, 12.93, 0.25, 26.60, "", I18n.t("danfe.infAdic.vol.title"), { size: 5, valign: :top, border: 0 }

      volumes = 0
      y = 26.67
      @xml.collect("xmlns", "vol") do |det|
        volumes += 1
        if volumes > 1
          render_extra_volume(det, y + 0.10)
          y += 0.15
        end
      end

      @pdf.ibox 2.07, 12.93, 0.25, y + 0.30, "", I18n.t("danfe.infAdic.others"), { size: 6, valign: :top, border: 0 }
      @pdf.ibox 2.07, 12.93, 0.25, y + 0.50, "", @xml["infAdic/infCpl"], { size: 5, valign: :top, border: 0 }
    end

    def render_extra_volume(det, y)
      render_field "qVol", det, 0.70, 0.25, 0.70, 0.90, y, :text
      render_field "esp", det, 0.50, 1.35, 3.00, 1.75, y, :text
      render_field "marca", det, 0.70, 4.15, 2.00, 4.75, y, :text
      render_field "nVol", det, 1.00, 6.10, 1.00, 6.70, y, :text
      render_field "pesoB", det, 1.30, 7.00, 1.30, 7.00, y, :numeric
      render_field "pesoL", det, 0.90, 8.50, 1.50, 8.50, y, :numeric
    end

    def render_field(field, det, w1, x1, w2, x2, y, kind)
      label = I18n.t("danfe.infAdic.vol.#{field}")
      value = det.css(field).text

      @pdf.ibox 0.35, w1, x1, y, "", label, style_normal

      if kind == :numeric
        @pdf.inumeric 0.35, w2, x2, y, "", value, style_decimal
      else
        @pdf.ibox 0.35, w2, x2, y, "", value, style_italic
      end
    end

    def style_normal
      { size: 4, border: 0 }
    end

    def style_italic
      style_normal.merge({ style: :italic })
    end

    def style_decimal
      style_italic.merge({ decimals: 3 })
    end
  end
end
