module BrDanfe
  module DanfeNfeLib
    class InfadicVol
      def initialize(xml, pdf)
        @xml = xml
        @pdf = pdf
        @y_position = 27.56
      end

      def render
        render_volume_title
        render_volume
      end

      private

      def render_volume_title
        @pdf.ibox 2.65, 12.45, 0.75, @y_position + 0.30, '', I18n.t('danfe.infAdic.vol.title'), size: 5, valign: :top,
          border: 0
      end

      def render_volume
        volumes = 0
        y_position = @y_position + 0.47

        @xml.collect('xmlns', 'vol') do |det|
          volumes += 1

          if volumes > 1
            render_fields det, y_position
            y_position += 0.15
          end
        end
      end

      def render_fields(det, y_position)
        render_esp det, y_position
        render_marca det, y_position
        render_qvol det, y_position
        render_nvol det, y_position
        render_pesob det, y_position
        render_pesol det, y_position
      end

      def render_esp(det, y_position)
        render_item_title 0.5, 1.35, 'esp', y_position
        render_item_field det.css('esp').text, 3, 1.75, y_position
      end

      def render_item_title(width, x_position, field, y_position)
        label = I18n.t("danfe.infAdic.vol.#{field}")
        @pdf.ibox 0.35, width, x_position, y_position, '', label, style_normal
      end

      def style_normal
        { size: 4, border: 0 }
      end

      def render_item_field(value, width, x_position, y_position)
        @pdf.ibox 0.35, width, x_position, y_position, '', value, style_italic
      end

      def style_italic
        style_normal.merge(style: :italic)
      end

      def render_marca(det, y_position)
        render_item_title 0.7, 4.15, 'marca', y_position
        render_item_field det.css('marca').text, 2, 4.75, y_position
      end

      def render_qvol(det, y_position)
        render_item_title 0.7, 0.75, 'qVol', y_position
        render_item_field det.css('qVol').text, 0.7, 1.04, y_position
      end

      def render_nvol(det, y_position)
        render_item_title 1, 6.1, 'nVol', y_position
        render_item_field det.css('nVol').text, 1, 6.7, y_position
      end

      def render_pesob(det, y_position)
        render_item_title 1.3, 7, 'pesoB', y_position
        render_peso_item_field det.css('pesoB').text, 1.3, 7, y_position
      end

      def render_peso_item_field(value, width, x_position, y_pos)
        @pdf.inumeric 0.35, width, x_position, y_pos, '', value, style_decimal
      end

      def style_decimal
        style_italic.merge(decimals: 3)
      end

      def render_pesol(det, y_position)
        render_item_title 0.9, 8.5, 'pesoL', y_position
        render_peso_item_field det.css('pesoL').text, 1.5, 8.5, y_position
      end
    end
  end
end
