module BrDanfe
  module DanfeLib
    class VolRenderer
      def initialize(pdf, det, y_position)
        @pdf = pdf
        render_fields(det, y_position)
      end

      def render_fields(det, y_position)
        render_item_title 0.5, 1.35, y_position, 'esp'
        render_item_field value(det, 'esp'), 3, 1.75, y_position

        render_item_title 0.7, 4.15, y_position, 'marca'
        render_item_field value(det, 'marca'), 2, 4.75, y_position

        render_item_title 0.7, 0.75, y_position, 'qVol'
        render_item_field value(det, 'qVol'), 0.7, 1.04, y_position

        render_item_title 1, 6.1, y_position, 'nVol'
        render_item_field value(det, 'nVol'), 1, 6.7, y_position

        render_item_title 1.3, 7, y_position, 'pesoB'
        render_peso_item_field value(det, 'pesoB'), 1.3, 7, y_position

        render_item_title 0.9, 8.5, y_position, 'pesoL'
        render_peso_item_field value(det, 'pesoL'), 1.5, 8.5, y_position
      end

      def render_item_title(width, x_position, y_position, field)
        label = I18n.t("danfe.infAdic.vol.#{field}")
        @pdf.ibox 0.35, width, x_position, y_position, '', label, style_normal
      end

      def render_item_field(value, width, x_position, y_position)
        @pdf.ibox 0.35, width, x_position, y_position, '', value, style_italic
      end

      def render_peso_item_field(value, width, x_position, y_pos)
        @pdf.inumeric 0.35, width, x_position, y_pos, '', value, style_decimal
      end

      def value(det, field)
        det.css(field).text
      end

      def style_normal
        { size: 4, border: 0 }
      end

      def style_italic
        style_normal.merge(style: :italic)
      end

      def style_decimal
        style_italic.merge(decimals: 3)
      end
    end
  end
end