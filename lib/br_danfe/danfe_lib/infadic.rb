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

      def render(n_vol, footer_info)
        @pdf.ititle 0.42, 10.00, 0.75, @ltitle, "infAdic.title"

        if n_vol > 1
          render_extra_volumes
        elsif difal?
          render_difal
        else
          @pdf.ibox 2.65, 12.45, 0.75, @l1, I18n.t("danfe.infAdic.infCpl"), @xml["infAdic/infCpl"], { size: 6, valign: :top }
        end

        @pdf.ibox 2.65, 7.15, 13.20, @l1, I18n.t("danfe.infAdic.reserved")

        render_footer_information footer_info
      end

      private

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

        render_info_cpl_with_others y
      end

      def difal?
        !@xml["ICMSTot/vICMSUFDest"].to_f.zero?
      end

      def difal_content
        I18n.t("danfe.infAdic.difal",
          vICMSUFDest: numerify(@xml["ICMSTot/vICMSUFDest"]),
          vFCPUFDest: numerify(@xml["ICMSTot/vFCPUFDest"]),
          vICMSUFRemet: numerify(@xml["ICMSTot/vICMSUFRemet"]))
      end

      def numerify(value)
        Helper.numerify(value) if value != ""
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

      def render_info_cpl_with_others(y)
        @pdf.ibox 1.65, 12.45, 0.75, y + 0.30, "", I18n.t("danfe.infAdic.others"), { size: 6, valign: :top, border: 0 }
        @pdf.ibox 1.65, 12.45, 0.75, y + 0.50, "", @xml["infAdic/infCpl"], { size: 5, valign: :top, border: 0 }
      end

      def render_difal
        @pdf.ibox 2.65, 12.45, 0.75, @l1, I18n.t("danfe.infAdic.infCpl"), "", { size: 8, valign: :top }

        y = Y + 0.20
        @pdf.ibox 1.65, 12.45, 0.75, y, "", difal_content, { size: 5, valign: :top, border: 0 }

        y += 0.10

        render_info_cpl_with_others y
      end

      def render_footer_information(footer_info)
        if footer_info.present?
          @pdf.ibox 0.35, 12.45, 0.75, @l1 + 2.65, "", footer_info, { size: 5, border: 0 }
        end
      end
    end
  end
end
