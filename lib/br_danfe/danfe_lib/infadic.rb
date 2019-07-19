module BrDanfe
  module DanfeLib
    # Class responsible for additional data in DANFE
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

        if volumes_number > 1
          render_volume_at y_position
          y_position += volumes_number * 0.15 + 0.2
        end

        @pdf.ibox 2.65, 12.45, 0.75, y_position, '', generate_additional_data,
                  size: 5, valign: :top, border: 0
      end

      def generate_additional_data
        additional_data = []
        additional_data.push(complementary_content) if complementary_content
        additional_data.push(address_content) if address_content
        additional_data.push(difal_content) if difal_content
        additional_data.join(' * ')
      end

      def complementary_content
        @xml['infAdic/infCpl'].to_s if @xml['infAdic/infCpl'].to_s != ''
      end

      def address_content
        address = Helper.generate_address @xml
        return unless Helper.address_is_too_big @pdf, address
        "Endereço: #{Helper.generate_address @xml}"
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

      def difal_content
        return unless @xml['ICMSTot/vICMSUFDest'].to_f != 0
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
            VolRenderer.render_fields(det, y_position + 0.17)
            y_position += 0.15
          end
        end
      end
    end
  end
end
