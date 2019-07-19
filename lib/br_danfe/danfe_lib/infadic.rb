module BrDanfe
  module DanfeLib
    class Infadic
      Y_POSITION = 27.04 + SPACE_BETWEEN_GROUPS

      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml

        @title_position = Y_POSITION - 0.41
        @y_position = Y_POSITION
      end

      def render(volumes_number)
        render_title
        render_subtitle
        render_additional_data volumes_number
        render_reserved_fisco
      end

      private

      def render_additional_data(volumes_number)
        y_position = Y_POSITION + 0.30

        if render_volume?(volumes_number)
          render_volume_at y_position
          y_position += y_position_with_volume(volumes_number)
        end

        @pdf.ibox 2.65, 12.45, 0.75, y_position, '', generate_additional_data,
                  size: 5, valign: :top, border: 0
      end

      def generate_additional_data
        additional_data = []
        additional_data.push(complementary_content) if complementary_information?
        additional_data.push(address_content) if address_too_big?
        additional_data.push(difal_content) if difal?
        additional_data.join(' * ')
      end

      def complementary_content
        @xml['infAdic/infCpl'].to_s
      end

      def complementary_information?
        @xml['infAdic/infCpl'].to_s != ''
      end

      def address_too_big?
        Helper.address_is_too_big @pdf, (Helper.generate_address @xml)
      end

      def address_content
        "Endereço: #{Helper.generate_address @xml}"
      end

      def y_position_with_volume(volumes_number)
        volumes_number * 0.15 + 0.2
      end

      def render_reserved_fisco
        @pdf.ibox 2.65, 7.15, 13.20, @y_position,
                  I18n.t('danfe.infAdic.reserved')
      end

      def render_title
        @pdf.ititle 0.42, 10.00, 0.75, @title_position, 'infAdic.title'
      end

      def render_subtitle
        @pdf.ibox 2.65, 12.45, 0.75, @y_position,
                  I18n.t('danfe.infAdic.infCpl'), '', size: 7, valign: :top
      end

      def difal?
        !@xml['ICMSTot/vICMSUFDest'].to_f.zero?
      end

      def difal_content
        I18n.t(
          'danfe.infAdic.difal',
          vICMSUFDest: numerify(@xml['ICMSTot/vICMSUFDest']),
          vFCPUFDest: numerify(@xml['ICMSTot/vFCPUFDest']),
          vICMSUFRemet: numerify(@xml['ICMSTot/vICMSUFRemet'])
        )
      end

      def numerify(value)
        Helper.numerify(value) if value != ''
      end

      def render_volume?(volumes_number)
        volumes_number > 1
      end

      def render_volume_title(y_position)
        @pdf.ibox 2.65, 12.45, 0.75, y_position, '',
                  I18n.t('danfe.infAdic.vol.title'),
                  size: 5, valign: :top, border: 0
      end

      def render_volume_at(y_position)
        render_volume_title y_position

        volumes = 0

        @xml.collect('xmlns', 'vol') do |det|
          volumes += 1

          if volumes > 1
            render_volume_fields(det, y_position + 0.17)
            y_position += 0.15
          end
        end
      end

      def render_volume_fields(det, y_position)
        render_volume_item_title 0.50, 1.35, y_position, 'esp'
        render_volume_item_field volume_value(det, 'esp'), 3.00, 1.75,
                                 y_position, :text

        render_volume_item_title 0.70, 4.15, y_position, 'marca'
        render_volume_item_field volume_value(det, 'marca'), 2.00, 4.75,
                                 y_position, :text

        volumes_fields det, y_position
        peso_fields det, y_position
      end

      def volumes_fields(det, y_position)
        render_volume_item_title 0.70, 0.75, y_position, 'qVol'
        render_volume_item_field volume_value(det, 'qVol'), 0.70, 1.04,
                                 y_position, :text

        render_volume_item_title 1.00, 6.10, y_position, 'nVol'
        render_volume_item_field volume_value(det, 'nVol'), 1.00, 6.70,
                                 y_position, :text
      end

      def peso_fields(det, y_position)
        render_volume_item_title 1.30, 7.00, y_position, 'pesoB'
        render_volume_item_field volume_value(det, 'pesoB'), 1.30, 7.00,
                                 y_position, :numeric

        render_volume_item_title 0.90, 8.50, y_position, 'pesoL'
        render_volume_item_field volume_value(det, 'pesoL'), 1.50, 8.50,
                                 y_position, :numeric
      end

      def volume_value(det, field)
        det.css(field).text
      end

      def render_volume_item_title(width, x_position, y_position, field)
        label = I18n.t("danfe.infAdic.vol.#{field}")
        @pdf.ibox 0.35, width, x_position, y_position, '', label, style_normal
      end

      def render_volume_item_field(value, width, x_position, y_position, kind)
        if kind == :numeric
          @pdf.inumeric 0.35, width, x_position, y_position, '', value,
                        style_decimal
        else
          @pdf.ibox 0.35, width, x_position, y_position, '', value,
                    style_italic
        end
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
