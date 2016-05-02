module BrDanfe
  module DanfeLib
    class Infadic
      Y = 27.04 + SPACE_BETWEEN_GROUPS

      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml

        @ltitle = Y - 0.41
        @l1 = Y
      end

      def render(nVol)
        @pdf.ititle 0.42, 10.00, 0.75, @ltitle, "infAdic.title"

        if nVol > 1
          render_extra_volumes
        else
          if difal?
            render_difal
          else
            @pdf.ibox 2.65, 12.45, 0.75, @l1, I18n.t("danfe.infAdic.infCpl"), @xml["infAdic/infCpl"], { size: 6, valign: :top }
          end
        end

        @pdf.ibox 2.65, 7.15, 13.20, @l1, I18n.t("danfe.infAdic.reserved")
      end

      private

      def render_difal
        @pdf.ibox 2.65, 12.45, 0.75, @l1, I18n.t("danfe.infAdic.infCpl"), "", { size: 8, valign: :top }

        y = Y + 0.20
        @pdf.ibox 1.65, 12.45, 0.75, y, "", difal_content, { size: 5, valign: :top, border: 0 }

        y += 0.10
        @pdf.ibox 1.65, 12.45, 0.75, y + 0.30, "", I18n.t("danfe.infAdic.others"), { size: 6, valign: :top, border: 0 }
        @pdf.ibox 1.65, 12.45, 0.75, y + 0.50, "", @xml["infAdic/infCpl"], { size: 5, valign: :top, border: 0 }
      end

      def difal_content
        icms_dest = @xml["ICMSTot/vICMSUFDest"]
        fcp_dest = @xml["ICMSTot/vFCPUFDest"]
        icms_remet = @xml["ICMSTot/vICMSUFRemet"]

        icms_dest = Helper.numerify(icms_dest, 2) if icms_dest != ""
        fcp_dest = Helper.numerify(fcp_dest, 2) if fcp_dest != ""
        icms_remet = Helper.numerify(icms_remet, 2) if icms_remet != ""

        I18n.t("danfe.infAdic.difal",
          vICMSUFDest: icms_dest,
          vFCPUFDest: fcp_dest,
          vICMSUFRemet: icms_remet)
      end

      def render_extra_volumes
        @pdf.ibox 2.65, 12.45, 0.75, @l1, I18n.t("danfe.infAdic.infCpl"), "", { size: 8, valign: :top }

        y = Y + 0.20

        if difal?
          @pdf.ibox 1.65, 12.45, 0.75, y, "", difal_content, { size: 5, valign: :top, border: 0 }
          y += 0.27
        else
          y += 0.07
        end

        @pdf.ibox 2.65, 12.45, 0.75, y, "", I18n.t("danfe.infAdic.vol.title"), { size: 5, valign: :top, border: 0 }

        volumes = 0
        y += 0.07

        @xml.collect("xmlns", "vol") do |det|
          volumes += 1
          if volumes > 1
            render_extra_volume(det, y + 0.10)
            y += 0.15
          end
        end

        @pdf.ibox 1.65, 12.45, 0.75, y + 0.30, "", I18n.t("danfe.infAdic.others"), { size: 6, valign: :top, border: 0 }
        @pdf.ibox 1.65, 12.45, 0.75, y + 0.50, "", @xml["infAdic/infCpl"], { size: 5, valign: :top, border: 0 }
      end

      def render_extra_volume(det, y)
        render_field "qVol", det, 0.70, 0.75, 0.70, 1.04, y, :text
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

      def difal?
        !@xml["ICMSTot/vICMSUFDest"].to_f.zero?
      end
    end
  end
end
