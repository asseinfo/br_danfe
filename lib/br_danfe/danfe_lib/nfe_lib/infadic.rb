module BrDanfe
  module DanfeLib
    module NfeLib
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
          render_volumes if volumes_number > 1
          render_additional_data generate_y_position(volumes_number) if complementary? || address? || difal? || fisco? || dup_content.to_s.present?
          render_reserved_fisco
        end

        private

        def render_title
          @pdf.ititle 0.42, 10.00, 0.75, @title_position, 'infAdic.title'
        end

        def render_subtitle
          @pdf.ibox 2.65, 12.45, 0.75, @y_position, I18n.t('danfe.infAdic.infCpl'), '', size: 8, valign: :top
        end

        def render_volumes
          InfadicVol.new(@xml, @pdf).render
        end

        def render_additional_data(y_position)
          data = generate_additional_data
          @pdf.ibox 2.65, 12.45, 0.75, y_position, '', data, size: 6, valign: :top, border: 0
        end

        def generate_additional_data
          additional_data = []
          additional_data.push(complementary_content) if complementary?
          additional_data.push(address_content) if address?
          additional_data.push(difal_content) if difal?
          additional_data.push(fisco_content) if fisco?
          additional_data.push(dup_content) if dup_content.any?
          additional_data.join(' * ')
        end

        def complementary_content
          @xml['infAdic/infCpl'].to_s
        end

        def complementary?
          @xml['infAdic/infCpl'].to_s != ''
        end

        def address_content
          "Endereço: #{Helper.generate_address @xml, 'enderDest'}"
        end

        def address?
          Helper.address_is_too_big @pdf, Helper.generate_address(@xml, 'enderDest')
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
          BrDanfe::Helper.numerify(value) if value != ''
        end

        def difal?
          value = @xml['ICMSTot/vICMSUFDest'].presence || '0.0'
          BigDecimal(value).positive?
        end

        def fisco_content
          @xml['infAdic/infAdFisco'].to_s
        end

        def fisco?
          @xml['infAdic/infAdFisco'].to_s.present?
        end

        def format_dup_date(_det, dup_date)
          dtduplicata = dup_date
          "#{dtduplicata[8, 2]}/#{dtduplicata[5, 2]}/#{dtduplicata[0, 4]}"
        end

        def dup_content
          value_dups = []

          @xml.collect('xmlns', 'dup') { _1 }[NfeLib::Dup::DUP_MAX_QUANTITY..]&.each_with_index do |det, index|
            value = "#{det.css('nDup').text} - #{format_dup_date(det, det.css('dVenc').text)} - R$ #{BrDanfe::Helper.numerify(det.css('vDup').text.to_f)}"

            if index.zero?
              value_dups.push("Faturas: #{value}")
            elsif index.positive?
              value_dups.push(value.to_s)
            end
          end

          value_dups
        end

        def generate_y_position(volumes_number)
          if volumes_number > 1
            return Y_POSITION + 0.30 + (volumes_number * 0.15) + 0.2
          end

          Y_POSITION + 0.30
        end

        def render_reserved_fisco
          @pdf.ibox 2.65, 7.15, 13.20, @y_position, I18n.t('danfe.infAdic.reserved')
        end
      end
    end
  end
end
